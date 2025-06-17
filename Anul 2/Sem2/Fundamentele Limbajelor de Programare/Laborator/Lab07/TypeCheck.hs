module TypeCheck where
import Syntax (Variable, Type(..), Expr(..))
import Parser (Parser, commaSep0, pvar, symbol, ptype, parseFirst, pexpr)

type TypeAssignment = [(Variable, Type)]

vlookup :: TypeAssignment -> Variable -> Either String Type
vlookup assgn x = maybe (Left "variable not found") Right (lookup x assgn)

{-| Type checker

    Given a type assignment (which gives the unique type for each variable) and
    an expression `e` verifies whether there exist a type `t` such that
    the expresison `e:t` is well-formed according to the Church typing rules.

    If so, it outputs t. If not it outputs an error.

Examples:

>>> testTypeCheck "x :: (a -> b) -> c, y :: a -> b" "x y"
Right c

>>> testTypeCheck "x :: a -> a, y :: (a -> a) -> b, z :: b, u :: c" "(\\ z u -> z) (y x)"
Right c -> b

>>> testTypeCheck "x :: a -> a" "x x"
Left "x :: a -> a cannot be applied to x :: a -> a"
-}

-- Cel mai natural de implementat in Haskell
-- Either String a este o monada
-- Dar simplificam ca sa implementam nemonadic
typeCheck :: TypeAssignment -> Expr -> Either String Type
typeCheck gamma (Var x) = vlookup gamma x
typeCheck gamma (App e1 e2)
  | (Right (TArr t1 t2), Right t1') <- (typeCheck gamma e1, typeCheck gamma e2) = 
    if t1 == t1' then
      Right t2
    else
      Left $ show e1 ++ " :: " ++ show t1 ++ " -> " ++ show t2 ++ " cannot be applied to " ++ show e2 ++ " :: " ++ show t1'
typeCheck gamma (Lambda x e)
  | (Right t1, Right t2) <- (vlookup gamma x, typeCheck gamma e) = Right $ TArr t1 t2
typeCheck gamma _ = Left "Lambda expression not typeable!"

{-| parser for  a singleton variable - type pair

Examples:

>>> parseFirst psingleTypeAssgn "x :: (a -> v) -> c"
Right (x,(a -> v) -> c)
-}
psingleTypeAssgn :: Parser (Variable, Type)
psingleTypeAssgn = (,) <$> pvar <*> (symbol "::" *> ptype)

{-| parser for a TypeAssignment

Examples:
>>> parseFirst pTypeAssgn "x :: (a -> b) -> c, y :: a -> b -> c"
Right [(x,(a -> b) -> c),(y,a -> b -> c)]
-}
pTypeAssgn :: Parser TypeAssignment
pTypeAssgn = commaSep0 psingleTypeAssgn

testTypeCheck :: String -> String -> Either String Type
testTypeCheck sAssgn sExpr
  = do
    assgn <- parseFirst pTypeAssgn sAssgn
    expr <- parseFirst pexpr sExpr
    typeCheck assgn expr
