module WeakPre where

import Syntax (Stmt(..), BExpr(..), AExpr, subst, implies, HoareTriple (..))
import Parser ( Parser, parseFirst, hoare )
import Data.Maybe (fromJust)

data Condition = Condition { condition :: BExpr, goals :: Maybe BExpr }
unit :: BExpr -> Condition
unit c = Condition c Nothing

{- | The weakest precondition of a statement with respect to a postcondition. -}
wlp :: Stmt -> Condition -> Condition
wlp SSkip post = post
wlp (SAss x e) (Condition cond goals) = Condition(subst x e cond) goals
wlp (SSeq s1 s2) (Condition c1 g1) = wlp s1 cond2 where
  cond2 = wlp s2 (Condition c1 g1)
wlp (SIf b s1 s2) (Condition c g) = Condition pre newGoals where
  cond1 = wlp s1 (Condition c g)
  cond2 = wlp s2 (Condition c g)
  pre = BOr (BAnd b (condition cond1)) (BAnd (BNot b) (condition cond2))
  newGoals = goals cond1 <> goals cond2
wlp (SWhile b s inv) post@(Condition cond g0) = Condition inv (g1 <> g2 <> g0) where
  g1 = Just $ (inv <> BNot b) `implies` cond
  g2 = Just $ (inv <> b) `implies` condition (wlp s (unit inv))

{- | The verification condition of a Hoare triple. -}
verificationCondition :: HoareTriple -> BExpr
verificationCondition (HoareTriple pre stmt post) =
    fromJust (Just (pre `implies` condition preStmt) <> goals preStmt)
  where
    preStmt = wlp stmt (unit post)

{- tests

>>> testvc "{true} skip {true}"
! (true) || true

>>> testvc "{true} x := 0 {x == 0}"
not implemented

>>> testvc "{true} x := 0; x := x + 1 {x == 1}"
not implemented

>>> testvc "{!(x <= 0)} y := 0 - x {y <= 0 && ! (y == 0) && ! (y == x)}"
not implemented

>>> testvc "{true} if x <= 0 then x := 0 else x := 1 {x == 0 || x == 1}"
not implemented

>>> testvc "{true} if x <= y then m := y else m := x {(m == x || m == y) && x <= m && y <= m}"
not implemented

>>> testvc "{true} while true do skip invariant true {ultimateQuestionOfLife == 42}"
not implemented

>>> testvc "{true} s := 0;\ni := 0;\nwhile i <= n do (\n    s := s + i;\n    i := i + 1\n) invariant i <= n + 1 && 2 * s == i * (i - 1) {2 * s == n * (n + 1)}"
not implemented

-}

testvc :: String -> BExpr
testvc = test verificationCondition hoare

test :: Show c => (c -> d) -> Parser c -> String -> d
test f p s = f c
  where
    c = case parseFirst p s of
      Right c -> c
      Left err -> error ("parse error: " ++ err)
