{- | This module defines the syntax of the language. -}
module Syntax where
import Data.List (intercalate, nub)
import Data.Char (toUpper)

data Type
  = TVar Variable
  | Base String
  | TArr Type Type
  deriving (Eq)

instance Show Type where
    show (TVar v) = show v
    show (Base s) = s
    show (TArr fst snd) = showPrec fst ++ " -> " ++ show snd
      where
        showPrec p@(TArr _ _) = "(" ++ show p ++ ")"
        showPrec p = show p

data Variable
  = V String Integer
  deriving (Eq)

instance Show Variable where
  show (V x 0) = x
  show (V x i) = x ++ "_" ++ show i

data Expr
  = Var Variable
  | App Expr Expr
  | Lambda Variable Expr
  deriving (Eq)

instance Show Expr where
  show (Var x) = show x
  show (App e1 e2) = "(" ++ show e1 ++ " " ++ show e2 ++ ")"
  show (Lambda x e) = "(\\ " ++ show x ++ " -> " ++ show e ++ ")"

data Equation = Type :=: Type
  deriving (Show)

toTypeVar :: Variable -> Variable
toTypeVar (V (fst:name) count) = V (toUpper fst:name) count

tVarSample :: Variable
tVarSample = V "T" 0
