module Reduction where

import Syntax ( Expr(..), Variable )
import Substitution ( substitute )
import Equivalence ( alphaEquiv )
import Parser (parseFirst, pexpr)
import Language.Haskell.TH (Exp(LamCaseE))

{-| Applies a beta reduction to the leftmost-outermost redex (if present).

Examples:

>>> testBetaRed "(\\x -> x) x"
Right (Just x)

>>> testBetaRed "x x"
Right Nothing

>>> testBetaRed "x (\\x -> x) y"
Right Nothing

>>> testBetaRed "x ((\\x -> x) y)"
Right (Just (x y))

>>> testBetaRed "(\\x -> x) x y"
Right (Just (x y))

>>> testBetaRed "(\\x -> (\\x -> y) x) y"
Right (Just ((\ x -> y) y))

>>> testBetaRed "y (\\x -> (\\x -> y) x)"
Right (Just (y (\ x -> y)))

>>> testBetaRed "(\\x -> y) ((\\z -> z z) (\\w -> w))"
Right (Just y)

>>> testBetaRed "(\\x y -> y) ((\\x -> x x) (\\x -> x x)) (\\z -> z)"
Right (Just ((\ y -> y) (\ z -> z)))

>>> testBetaRed "(\\ y -> y) (\\ z -> z)"
Right (Just (\ z -> z))
-}
betaRed :: Expr -> Maybe Expr
betaRed (App (Lambda x t) t') = Just (substitute x t' t)
-- Daca betaRed t1 este un Just t1Red, vrem sa intoarcem Just $ App t1Red t2
-- Altfel, daca betaRed t2 este un Just t2Red, vrem sa intoarcem Just $ App t1 t2Red
betaRed (App t1 t2)
    | Just t1Red <- betaRed t1 = Just $ App t1Red t2
    | Just t2Red <- betaRed t2 = Just $ App t1 t2Red
    | otherwise = Nothing -- optional
betaRed (Lambda x t)
    | Just tRed <- betaRed t = Just $ Lambda x tRed
    | otherwise = Nothing -- optional
betaRed _ = Nothing 


{-| Repeats applying 'betaRed' until reaching a normal form

Examples:

>>> testBetaNormalForm "(\\x -> (\\x -> y) x) y"
Right y

>>> testBetaNormalForm "(\\x -> y) ((\\z -> z z) (\\w -> w))"
Right y

>>> testBetaNormalForm "(\\x y -> y) ((\\x -> x x) (\\x -> x x)) (\\z -> z)"
Right (\ z -> z)

>>> testBetaNormalForm "(\\x -> x y x) (\\z -> z)"
Right (y (\ z -> z))

>>> testBetaNormalForm "(\\x y -> x) y z"
Right y

>>> testBetaNormalForm "(\\z x y -> z y) (v y)"
Right (\ x -> (\ y_1 -> ((v y) y_1)))

>>> testBetaNormalForm "(\\s -> s s) (\\q -> q) (\\q -> q)"
Right (\ q -> q)

3 * 3  = 9
>>> testBetaNormalForm "(\\mul c3 -> mul c3 c3) (\\n m s -> n (m s)) (\\s z -> s (s (s z)))"
Right (\ s -> (\ z -> (s (s (s (s (s (s (s (s (s z)))))))))))
-}
betaNormalForm :: Expr -> Expr
betaNormalForm e = maybe e betaNormalForm (betaRed e)

testBetaRed :: String -> Either String (Maybe Expr)
testBetaRed s = betaRed <$> parseFirst pexpr s

testBetaNormalForm :: String -> Either String Expr
testBetaNormalForm s = betaNormalForm <$> parseFirst pexpr s
