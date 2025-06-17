{- | This module defines the syntax of the language. -}
module Syntax where

{- | The data type 'AExpr' represents the abstract syntax Arithmetic Expressions. -}
data AExpr
  = ENum Integer
  | EId String
  | EPlu AExpr AExpr
  | EMinu AExpr AExpr
  | EMul AExpr AExpr
--   | EDiv AExpr AExpr
--   | EminuU AExpr

parens :: String -> String
parens s = "(" ++ s ++ ")"

showE :: AExpr -> String
showE e@(EPlu _ _) = parens (show e)
showE e@(EMinu _ _) = parens (show e)
showE e = show e

instance Show AExpr where
  show (ENum n) = show n
  show (EId x) = x
  show (EPlu e1 e2) = show e1 ++ " + " ++ show e2
  show (EMinu e1 e2@(EPlu _ _)) = show e1 ++ " - " ++ showE e2
  show (EMinu e1 e2@(EMinu _ _)) = show e1 ++ " - " ++ showE e2
  show (EMinu e1 e2) = show e1 ++ " - " ++ show e2
  show (EMul e1 e2) = showE e1 ++ " * " ++ showE e2

{- | The data type 'BExpr' represents the abstract syntax Boolean Expressions. -}
data BExpr
  = BTrue
  | BFalse
  | BEq AExpr AExpr
--   | BNeq AExpr AExpr
--   | BLt AExpr AExpr
--   | BGt AExpr AExpr
  | BLe AExpr AExpr
--   | BGe AExpr AExpr
  | BNot BExpr
  | BAnd BExpr BExpr
  | BOr BExpr BExpr

instance Show BExpr where
  show BTrue = "true"
  show BFalse = "false"
  show (BEq e1 e2) = show e1 ++ " == " ++ show e2
  show (BLe e1 e2) = show e1 ++ " <= " ++ show e2
  show (BNot b) = "! (" ++ show b ++ ")"
  show (BOr b1 b2) = show b1 ++ " || " ++ show b2
  show (BAnd b1 b2) = showB b1 ++ " && " ++ showB b2

showB :: BExpr -> String
showB b@(BOr _ _) = parens (show b)
showB b = show b

{- | The data type 'Stmt' represents the abstract syntax Statements. -}
data Stmt
  = SSkip
  | SAss String AExpr
  | SSeq Stmt Stmt
  | SIf BExpr Stmt Stmt
  | SWhile BExpr Stmt BExpr

instance Show Stmt where
  show SSkip = "skip"
  show (SAss x e) = x ++ " := " ++ show e
  show (SSeq s1 s2) = show s1 ++ "; " ++ show s2
  show (SIf b s1 s2) = "if " ++ show b ++ " then " ++ showS s1 ++ " else " ++ showS s2
  show (SWhile b s inv) = "while " ++ show b ++ " do " ++ showS s ++ " invariant " ++ show inv

showS :: Stmt -> String
showS s@(SSeq _ _) = parens (show s)
showS s = show s

class AExprSubstitutable a where
  subst :: String -> AExpr -> a -> a

instance AExprSubstitutable AExpr where
  subst :: String -> AExpr -> AExpr -> AExpr
  subst x e = go
    where
      go (ENum i) = ENum i
      go (EId y)
        | x == y = e
        | otherwise = EId y
      go (EPlu a1 a2) = EPlu (go a1) (go a2)
      go (EMinu a1 a2) = EMinu (go a1) (go a2)
      go (EMul a1 a2) = EMul (go a1) (go a2)

instance AExprSubstitutable BExpr where
  subst :: String -> AExpr -> BExpr -> BExpr
  subst x e = go
    where
      ago = subst x e
      go BTrue = BTrue
      go BFalse = BFalse
      go (BEq a1 a2) = BEq (ago a1) (ago a2)
      go (BLe a1 a2) = BLe (ago a1) (ago a2)
      go (BNot b) = BNot (go b)
      go (BAnd b1 b2) = BAnd (go b1) (go b2)
      go (BOr b1 b2) = BOr (go b1) (go b2)

implies :: BExpr -> BExpr -> BExpr
b1 `implies` b2 = BNot b1 `BOr` b2

data HoareTriple = HoareTriple BExpr Stmt BExpr

instance Show HoareTriple where
  show (HoareTriple pre stmt post) =
    "{" ++ show pre ++ "} " ++ show stmt ++ " {" ++ show post ++ "}"


instance Semigroup BExpr where
  (<>) = BAnd

instance Monoid BExpr where
  mempty = BTrue
