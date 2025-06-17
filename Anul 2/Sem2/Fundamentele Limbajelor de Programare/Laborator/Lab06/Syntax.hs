{- | This module defines the syntax of the language. -}
module Syntax where
import Data.List (intercalate, nub)

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
