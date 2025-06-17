module Equivalence where

import Syntax ( Expr(..), Variable )
import Substitution ( substitute, freshVar, freeVars )
import Parser (parseFirst, pexpr)

{-| Tests whether two expressions are alpha-equivalent

Examples:

>>> testAlphaEquiv "x" "x"
Right True

>>> testAlphaEquiv "x" "y"
Right False

>>> testAlphaEquiv "\\x -> x" "\\y -> y"
Right True

>>> testAlphaEquiv "\\x -> y" "\\y -> x"
Right False

>>> testAlphaEquiv "\\x -> y" "\\z -> y"
Right True

>>> testAlphaEquiv "\\x -> y" "\\y -> y"
Right False

>>> testAlphaEquiv "\\x x x x x -> x" "\\x y z t u -> u"
Right True

>>> testAlphaEquiv "\\x x x x x -> x" "\\x y z t u -> x"
Right False
-}
alphaEquiv :: Expr -> Expr -> Bool
alphaEquiv (Var x) (Var y) = x == y
alphaEquiv (App t1 t2) (App t1' t2') = alphaEquiv t1 t1' && alphaEquiv t2 t2'
alphaEquiv (Lambda x t) (Lambda y t')
  | x == y = alphaEquiv t t'
  | otherwise = substitute x z t `alphaEquiv` substitute y z t' where
    z = Var $ freshVar x (freeVars t ++ freeVars t')
alphaEquiv _ _ = False

testAlphaEquiv :: String -> String -> Either String Bool
testAlphaEquiv s1 s2 = alphaEquiv <$> parse s1 <*> parse s2
  where
    parse = parseFirst pexpr
