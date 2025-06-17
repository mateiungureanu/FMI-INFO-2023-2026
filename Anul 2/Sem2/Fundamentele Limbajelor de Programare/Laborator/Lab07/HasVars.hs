module HasVars where

import Syntax ( Equation(..), Expr(..), Type(..), Variable )
import Data.List (nub)

{-| Class for types for which the set of variables can be computed.
-}
class HasVars e where
  vars :: e -> [Variable]

{-| Extends a 'HasVars' instance to lists
-}
instance HasVars e => HasVars [e] where
  vars = nub . concatMap vars

instance HasVars Expr where
  vars (Var x) = [x]
  vars (App e1 e2) = vars e1 ++ vars e2
  vars (Lambda x e) = x : vars e

instance HasVars Type where
    vars (TVar x) = [x]
    vars (Base t) = []
    vars (TArr t1 t2) = vars [t1, t2]

instance HasVars Equation where
  vars (e1 :=: e2) = vars [e1, e2]
