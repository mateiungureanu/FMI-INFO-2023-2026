module Unification (unify, unifyAsList) where

import Syntax ( Type(..), Equation(..), Variable(..) )
import HasVars ( HasVars(..) )
import Substitution
    ( SubstitutionLike(..),
      SubstitutionGraph(..),
      Substitution,
      makeGraph )

import Parser (Parser, parseFirst, symbol, pexpr, commaSep0, tvar, pequations, pequation, ptype)

{-| A configuration for the unification algorithm.

It consists of the list of equations (still) to be reasolved
and the current computed substitution.

The substitution is parameterized to allow any substitution-like type.
-}
data Config s = Config [Equation] s

instance Show s => Show (Config s) where
  show (Config eqs s) = "< " ++ show eqs ++ ", " ++ show s ++ " >"

{-| Implements a step of the unification algorithm.

If successful, it yields the new configuration.
If failing it returns an appropriate error message.

Examples:

>>> testUnifyStep "g(Y) = X, f(X,h(X),Y) = f(g(Z),W,Z)" ""
Right < [f(g(Y), h(g(Y)), Y) = f(g(Z), W, Z)], X |-> g(Y) >

>>> testUnifyStep "f(g(Y), h(g(Y)), Y) = f(g(Z), W, Z)" "X |-> g(Y)"
Right < [g(Y) = g(Z),h(g(Y)) = W,Y = Z], X |-> g(Y) >

>>> testUnifyStep "g(Y) = g(Z),h(g(Y)) = W,Y = Z" "X |-> g(Y)"
Right < [Y = Z,h(g(Y)) = W,Y = Z], X |-> g(Y) >

>>> testUnifyStep "Y = Z,h(g(Y)) = W,Y = Z" "X |-> g(Y)"
Right < [h(g(Z)) = W,Z = Z], Y |-> Z, X |-> g(Z) >

>>> testUnifyStep "h(g(Z)) = W,Z = Z" "Y |-> Z, X |-> g(Z)"
Right < [Z = Z], W |-> h(g(Z)), Y |-> Z, X |-> g(Z) >

>>> testUnifyStep "Z = Z" "Y |-> Z, X |-> g(Z)"
Right < [], Y |-> Z, X |-> g(Z) >


-}
unifyStep :: SubstitutionLike s => Config s -> Either String (Config s)
unifyStep (Config (TVar x :=: TVar y : eqs) s)
  | x == y
  = Right (Config eqs s)
unifyStep (Config (TVar x :=: t : eqs) s)
  | x `elem` vars t
  = Left $ "Cycle on " ++ show x
  | otherwise
  = Right (Config (eapply (singletonSubst x t :: SubstitutionGraph) <$> eqs) (extend s x t))
unifyStep (Config (t :=: TVar x : eqs) s)
  | x `elem` vars t
  = Left $ "Cycle on " ++ show x
  | otherwise
  = Right (Config (eapply sxt <$> eqs) (s >>> sxt))
  where
    sxt = singletonSubst x t
unifyStep (Config (TArr _ _ :=: Base f : eqs) s) 
  = Left $ "Conflict between type arrow and the base type " ++ f
unifyStep (Config (Base f :=:TArr _ _  : eqs) s) 
  = Left $ "Conflict between type arrow and the base type " ++ f
unifyStep (Config (Base f :=: Base f' : eqs) s) 
  | f /= f' = Left $ "Conflict between base types " ++ f ++ " and " ++ f'
  | otherwise = Right (Config eqs s)
unifyStep (Config (TArr t1 t2 :=: TArr t1' t2' : eqs) s)
  = Right (Config  (t1 :=: t1' : t2 :=: t2' : eqs) s)

class HasUnify eqs where
  unify :: SubstitutionLike s => eqs -> Either String s

  unifyAsList :: HasVars eqs => eqs -> Either String SubstitutionGraph
  unifyAsList eqs = makeGraph (vars eqs) <$> unify eqs

{-| HasUnify instance for lists of equations uses 'unifyStep' to
implement the actual unification algorithm described in the class.

Examples:

>>> testUnifyEqs "g(Y) = X, f(X,h(X),Y) = f(g(Z),W,Z)"
Right Y |-> Z, X |-> g(Z), W |-> h(g(Z))

>>> testUnifyEqs "g(Y) = X, f(X,h(Y),Y) =  f(g(Z),b,Z)"
Left "Conflict between h/1 and b/0"

>>> testUnifyEqs "g(Y) = X, f(X,h(X),Y) = f(Y,W,Z)"
Left "Cycle on Y"
-}
instance HasUnify [Equation] where
  unify eqs = go (Config eqs idSubst)
    where
      go (Config [] s) = Right s
      go cfg = unifyStep cfg >>= go

{-| Special instance of the unification algorithm for a single equation.

Examples:

>>> testUnifyEq "plus(X,mul(Y,Y)) = plus(X,mul(Y,X))"
Right Y |-> X
-}
instance HasUnify Equation where
  unify eq = unify [eq]

{-| Special instance of the unification algorithm for lists of expressions.
We transform them in equations each with the next in sequence.

Examples:

>>> testUnifyExprs "f(X,Y), f(h(X),X), f(X,b)"
Left "Cycle on X"

>>> testUnifyExprs "f(X,f(X,g(Y))), f(U,Z), f(g(Y), Y)"
Left "Cycle on Y"

>>> testUnifyExprs "f(f(X,Y),X), f(g(Y), Z), f(U,h(Z))"
Left "Conflict between f/2 and g/1"

>>> testUnifyExprs "f(f(X,Y),X), f(V,U), f(U,h(Z))"
Left "Cycle on U"

>>> testUnifyExprs "f(f(X,Y),X), f(V,U), f(U,Z)"
Left "Cycle on U"

>>> testUnifyExprs "f(f(g(X),h(Y)),h(Z)), f(f(U,h(h(X))),h(Y)), f(V,W)"
Right Y |-> h(X), Z |-> h(X), U |-> g(X), V |-> f(g(X), h(h(X))), W |-> h(h(X))

>>> testUnifyExprs "p(X, X,Z), p(f(a,a), Y,Y), p(f(X,a), b,Z)"
Left "Conflict between a/0 and f/2"

>>> testUnifyExprs "p(X,X,Z), p(f(a,a), Y,Y), p(X,b,Z)"
Left "Conflict between f/2 and b/0"

>>> testUnifyExprs "p(X,X,Z), p(f(a,a), Y,Y), p(X,f(a,a), Z)"
Right X |-> f(a, a), Z |-> f(a, a), Y |-> f(a, a)

>>> testUnifyExprs "p(f(X,a), g(Y), Z), p(f(a,a), Z,U), p(V,U,Z)"
Right X |-> a, Z |-> g(Y), U |-> g(Y), V |-> f(a, a)
-}
instance HasUnify [Type] where
  unify es = unify (zipWith (:=:) es (tail es))

-- Extra stuff for testing

testUnify :: (HasUnify e, HasVars e, Show e) => Parser e -> String -> Either String SubstitutionGraph
testUnify p s = parseFirst p s >>= unifyAsList 
    
testUnifyEqs :: String -> Either String SubstitutionGraph
testUnifyEqs = testUnify pequations

testUnifyEq :: String -> Either String SubstitutionGraph
testUnifyEq = testUnify pequation

testUnifyStep :: String -> String -> Either String (Config SubstitutionGraph)
testUnifyStep eqss substs 
  = do
    eqs <- parseFirst pequations eqss
    subst <- parseFirst pSubstitutionGraph substs
    unifyStep (Config eqs subst)

{-| parser for  a singleton substitution pair

Examples:

>>> parseFirst psingletonSubst "X |-> f(a, T)"
Right (X,f(a, T))
-}
psingletonSubst :: Parser (Variable, Type)
psingletonSubst = (,) <$> tvar <*> (symbol "|->" *> ptype)

{-| parser for a substitution represented as a 'SubstitutionGraph'

Examples:
>>> parseFirst pSubstitutionGraph "X |-> a, Z |-> g(Y), U |-> g(Y), V |-> f(a, a)"
Right X |-> a, Z |-> g(Y), U |-> g(Y), V |-> f(a, a)
-}
pSubstitutionGraph :: Parser SubstitutionGraph
pSubstitutionGraph = SubstitutionGraph <$> commaSep0 psingletonSubst
