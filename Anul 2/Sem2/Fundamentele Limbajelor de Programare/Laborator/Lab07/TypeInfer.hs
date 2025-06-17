module TypeInfer where
import Syntax (Variable(..), Type(..), Expr(..), Equation(..), tVarSample, toTypeVar)
import HasVars (vars)
import Parser (Parser, commaSep0, pvar, symbol, ptype, parseFirst, pexpr)
import Unification (unify)
import Data.List (nub, sort, intercalate)
import Data.Either (fromRight)
import Substitution (SubstitutionLike(apply), Substitution (vapply))

newtype TypeAssignment = TypeAssignment [(Variable, Type)]

instance Show TypeAssignment where
    show (TypeAssignment assgn) = intercalate ", " [show v ++ " :: " ++ show t | (v, t) <- assgn]

vlookup :: TypeAssignment -> Variable -> Either String Type
vlookup (TypeAssignment assgn) x = maybe (Left "variable not found") Right (lookup x assgn)

update :: Variable -> Type -> TypeAssignment -> TypeAssignment
update x t (TypeAssignment gamma) = TypeAssignment ((x, t) : gamma)

freeVars :: Expr -> [Variable]
freeVars = nub . go
  where
    go (Var x) = [x]
    go (App e1 e2) = go e1 ++ go e2
    go (Lambda x e) = filter (x /=) (go e)

boundVars ::  Expr -> [Variable]
boundVars (Var _) = []
boundVars (App e1 e2) = boundVars e1 ++ boundVars e2
boundVars (Lambda x e) = x : boundVars e

exprNeedsRenaming :: Expr -> Bool
exprNeedsRenaming e = length (nub vs) /= length vs
  where vs = freeVars e ++ boundVars e

freshVar :: Variable -> [Variable] -> Variable
freshVar (V x _) xs = V x n
  where
    n = firstNotIn 0 (sort [n | V y n <- xs, y == x])
    firstNotIn n [] = n
    firstNotIn n (m:t)
      | n == m    = firstNotIn (n + 1) t
      | otherwise = n


{-| Gathers the constraints which must be satisfied so that the given expression has 
    the given type under the given type assignment.

    Takes as an extra argument the list/set of variables already used to avoid using
    them when generating fresh variables.
-}

getConstraints :: Expr -> TypeAssignment -> Type -> [Variable] -> [Equation]
-- vs de la variables: lista variabilelor de tip (placeholdere) introduse pana acum
getConstraints (Var x) gamma z vs
  -- daca x are tipul t in gamma, intoarcem lista [Z :=: t]
  | Right t <- vlookup gamma x = [z :=: t]
  -- daca x nu e deloc in gamma, aruncam o eroare
  | otherwise = error "Variable not found!"
getConstraints (Lambda x e) gamma z vs = getConstraints e (update x sigma gamma) tw (w:vs) ++ [z :=: TArr sigma tw]
  -- update x sigma gamma = gamma reunit cu {x : sigma}
  where
    w = freshVar (V "T" 0) vs -- va intoarce un Tn pentru un n anume (cu pp ca n e cel mai mic indice > 0 care nu e in vs)
    -- cum w are tipul Variable, iar noi vrem un Type, trebuie sa il trecem prin constructorul TVar
    tw = TVar w
    -- lambda variabila x ==> X
    -- x :: X
    sigma = TVar (toTypeVar x) -- adnotarea x :: sigma
getConstraints (App e1 e2) gamma z vs = constrainsLeft ++ constrainsRight ++ [tw1 :=: TArr tw2 z]
  where
    constrainsLeft = getConstraints e1 gamma tw1 newVs
    constrainsRight = getConstraints e2 gamma tw2 (nub $ vars constrainsLeft ++ newVs)
    w1 = freshVar (V "T" 0) vs
    w2 = freshVar (V "T" 0) (w1:vs)
    tw1 = TVar w1
    tw2 = TVar w2
    newVs = w1:w2:vs

{-| Type inferencer

    Given an expression `e` in untyped lambda calculus, find whether
    there exists a type assignment `Gamma` and a type `t` such that
    `Gamma |- e : t` according to the Curry typing rules.

    If so, it outputs the pair `(Gamma, t)`. If not it outputs an error.

Examples:

>>> testTypeInfer "x y"
Right (x :: Y -> T, y :: Y,T)

>>> testTypeInfer "(\\ z u -> z) (y x)"
Right (y :: X -> Z, x :: X,U -> Z)

>>> testTypeInfer "x x"
Left "Cycle on T_2"
-}
typeInfer :: Expr -> Either String (TypeAssignment, Type)
typeInfer e
  | exprNeedsRenaming e = Left "Expression uses the same variable name with different purposes"
  | otherwise
    = do 
      theta <- unify constraints
      Right (TypeAssignment [(x, apply theta t) | (x,t) <- gamma], vapply theta z)
    where
      fvs = freeVars e
      bs = boundVars e
      tvars = map toTypeVar (fvs ++ bs)
      z = freshVar tVarSample tvars
      gamma = [(x, TVar (toTypeVar x)) | x <- fvs]
      constraints = getConstraints e (TypeAssignment gamma) (TVar z) (z : tvars)

testTypeInfer :: String -> Either String (TypeAssignment, Type)
testTypeInfer sExpr
  = do
    expr <- parseFirst pexpr sExpr
    typeInfer expr
