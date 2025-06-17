module Substitution where

import Data.List (intercalate, nub, sort)

import Syntax ( Expr(..), Variable(..) )
import Parser (parseFirst, pexpr, pvar, symbol)
import System.Win32 (xBUTTON1)

{-| The free variables of an expression

>>> testFreeVars "x"
Right [x]

>>> testFreeVars "x y"
Right [x,y]

>>> testFreeVars "(\\x -> x y) (\\y -> y z)"
Right [y,z]
-}
freeVars :: Expr -> [Variable]
freeVars (Var x) = [x]
freeVars (App e1 e2) = nub $ freeVars e1 ++ freeVars e2 -- nub elimina duplicatele dintr o lista
freeVars (Lambda x e) = filter (/= x) (freeVars e)

{-| A fresh variable with the same name as the first argument and not ocurring in the second argument
It chooses the least index possible with the property above.

>>> freshVar (V "x" 0) [V "x" 1]
x

>>> freshVar (V "x" 0) [V "x" 0]
x_1

>>> freshVar (V "x" 0) [V "y" 0]
x

>>> freshVar (V "x" 0) [V "x" 0, V "x" 1, V "x" 3]
x_2
-}
freshVar :: Variable -> [Variable] -> Variable
freshVar (V x _) xs = V x n
  where
    n = firstNotIn 0 (sort [n | V y n <- xs, y == x])
    firstNotIn n [] = n
    firstNotIn n (m:t)
      | n == m    = firstNotIn (n + 1) t
      | otherwise = n

{-| Substitutes the occurences of first argument with the second argument in the third.
Avoids variable capture.

Examples:

>>> testSubstitute "x[x := y]"
Right y

>>> testSubstitute "(x x)[x := y]"
Right (y y)

>>> testSubstitute "(x (\\x -> x))[x := y]"
Right (y (\ x -> x))

>>> testSubstitute "(x (\\y -> x))[x := y]"
Right (y (\ y_1 -> y))

>>> testSubstitute "\\y -> x (\\w -> v w x)[x := u v]"
Right (\ y -> ((u v) (\ w -> ((v w) (u v)))))

>>> testSubstitute "\\y -> x (\\x -> x)[x := \\y -> x y]"
Right (\ y -> ((\ y -> (x y)) (\ x -> x)))

>>> testSubstitute "y (\\v -> x v)[x := \\y -> v y]"
Right (y (\ v_1 -> ((\ y -> (v y)) v_1)))

>>> testSubstitute "\\x -> z y[x := u v]"
Right (\ x -> (z y))
-}
substitute :: Variable -> Expr -> Expr -> Expr
-- y [x := e]
substitute x e (Var y)
  | x == y = e
  | otherwise = Var y
-- (e1 e2) [x := e]
substitute x e (App e1 e2) = App (substitute x e e1) (substitute x e e2)
-- (\x. t)[x := e] si
-- (\y. t)[x := e], x /= y
substitute x e (Lambda y t)
  | x == y = Lambda y t
  | y `notElem` freeVars e = Lambda y (substitute x e t)
  | otherwise = Lambda y_1 (substitute x e (substitute y (Var y_1) t)) where
    y_1 = freshVar y (freeVars t ++ freeVars e) -- :: Variable


testFreeVars :: String -> Either String [Variable]
testFreeVars s = freeVars <$> parseFirst pexpr s

testSubstitute :: String -> Either String Expr
testSubstitute = parseFirst (handle <$> pexpr <*> (symbol "[" *> pvar <* symbol ":=") <*> (pexpr <* symbol "]"))
  where
    handle e x ex = substitute x ex e
