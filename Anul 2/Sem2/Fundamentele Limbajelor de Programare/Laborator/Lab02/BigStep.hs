module BigStep ( bsStmt ) where

import Syntax ( AExpr(..), BExpr(..), Stmt(..) )
import State ( get, set, State )
import Configurations ( Conf(..), Conf1(..) )
import Parser ( aconf, bconf, parseFirst, sconf, Parser ) -- for testing purposes

{- big-step semantics for arithmetic expressions

Examples:

>>> testExpr "< 5 , >"
< 5 >

>>> testExpr "< x , a |-> 3, x |-> 4 >"
< 4 >

>>> testExpr "< x + a, a |-> 3, x |-> 4 >"
< 7 >

>>> testExpr "< x - a, a |-> 3, x |-> 4 >"
< 1 >

>>> testExpr "< x * a, a |-> 3, x |-> 4 >"
< 12 >
-}
bsExpr :: Conf AExpr -> Conf1 Integer
bsExpr (Conf (ENum i) _) = Conf1 i
bsExpr (Conf (EId x) sig) = Conf1 (get sig x)
bsExpr (Conf (EPlu a1 a2) sig) = Conf1 (i1 + i2)
  where
    Conf1 i1 = bsExpr (Conf a1 sig)
    Conf1 i2 = bsExpr (Conf a2 sig)
bsExpr (Conf (EMinu a1 a2) sig) = Conf1 (i1 - i2)
  where
    Conf1 i1 = bsExpr (Conf a1 sig)
    Conf1 i2 = bsExpr (Conf a2 sig)
bsExpr (Conf (EMul a1 a2) sig) = Conf1 (i1 * i2)
  where
    Conf1 i1 = bsExpr (Conf a1 sig)
    Conf1 i2 = bsExpr (Conf a2 sig)

{- big-step semantics for boolean expressions

Examples:
>>> testBExpr "< true, >"
Prelude.undefined

>>> testBExpr "< false, >"
Prelude.undefined

>>> testBExpr "< x == a, a |-> 3, x |-> 4 >"
Prelude.undefined

>>> testBExpr "< a <= x, a |-> 3, x |-> 4 >"
Prelude.undefined

>>> testBExpr "< !(a <= x), a |-> 3, x |-> 4 >"
Prelude.undefined

>>> testBExpr "< true && false, >"
Prelude.undefined

>>> testBExpr "< true || false, >"
Prelude.undefined
-}
bsBExpr :: Conf BExpr -> Conf1 Bool
bsBExpr (Conf BTrue sig) = Conf1 True
bsBExpr (Conf BFalse sig) = Conf1 False
bsBExpr (Conf (BEq e1 e2) sig) = Conf1 (i1 == i2)
  where
    Conf1 i1 = bsExpr (Conf e1 sig)
    Conf1 i2 = bsExpr (Conf e2 sig)
bsBExpr (Conf (BLe e1 e2) sig) = Conf1 (i1 <= i2)
  where
    Conf1 i1 = bsExpr (Conf e1 sig)
    Conf1 i2 = bsExpr (Conf e2 sig)
bsBExpr (Conf (BNot b) sig) = Conf1 (not t)
  where
    Conf1 t = bsBExpr (Conf b sig)
bsBExpr (Conf (BAnd b1 b2) sig) = Conf1 (t1 && t2)
  where
    Conf1 t1 = bsBExpr (Conf b1 sig)
    Conf1 t2 = bsBExpr (Conf b2 sig)
bsBExpr (Conf (BOr b1 b2) sig) = Conf1 (t1 || t2)
  where
    Conf1 t1 = bsBExpr (Conf b1 sig)
    Conf1 t2 = bsBExpr (Conf b2 sig)

{- big-step semantics for statements

Examples:

>>> testStmt "< skip, >"
<  >

>>> testStmt "< x := x + 1, a |-> 3, x |-> 4 >"
< x |-> 5, a |-> 3 >

>>> testStmt "< x := x + 1; a := x + a, a |-> 3, x |-> 4 >"
< a |-> 8, x |-> 5 >

>>> testStmt "< if a <= x then max := x else max := a, a |-> 3, x |-> 4 >"
< max |-> 4, a |-> 3, x |-> 4 >

>>> testStmt "< while a <= x do x := x - a, a |-> 7, x |-> 33 >"
< x |-> 5, a |-> 7 >
-}
bsStmt :: Conf Stmt -> Conf1 State
bsStmt (Conf SSkip sig) = Conf1 sig
bsStmt (Conf (SAss x a) sig) = Conf1 sig'
  where
    Conf1 i = bsExpr (Conf a sig)
    sig' = set sig x i
bsStmt (Conf (SSeq s1 s2) sig) = Conf1 sig''
  where
    Conf1 sig' = bsStmt (Conf s1 sig)
    Conf1 sig'' = bsStmt (Conf s2 sig')
bsStmt (Conf (SIf b s1 s2) sig) = 
  if t then
    bsStmt (Conf s1 sig)
  else
    bsStmt (Conf s2 sig)
  where
    Conf1 t = bsBExpr (Conf b sig)
bsStmt (Conf (SWhile b s) sig) =
  if t then
    let Conf1 sig' = bsStmt (Conf s sig)
    in bsStmt (Conf (SWhile b s) sig')
  else
    Conf1 sig
  where
    Conf1 t = bsBExpr (Conf b sig)

-- Below are the functions used for a nice testing experience
-- they combine running the actual function being tested with parsing
-- to allow specifying the input configuration as a string
--
-- These, together with the Show instances in the Configurations, State, and Syntax modules
-- make the input and output look closer to how it would look on paper.

test :: Show c => (c -> c') -> Parser c -> String -> c'
test f p s = f c
  where
    c = case parseFirst p s of
      Right c -> c
      Left err -> error ("parse error: " ++ err)

testExpr :: String -> Conf1 Integer
testExpr = test bsExpr aconf

testBExpr :: String -> Conf1 Bool
testBExpr = test bsBExpr bconf

testStmt :: String -> Conf1 State
testStmt = test bsStmt sconf
