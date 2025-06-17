module Configurations ( Conf1(..), Conf (..) ) where

import Syntax ( AExpr, BExpr, Stmt )
import State ( State )

newtype Conf1 t = Conf1 t

instance Show t => Show (Conf1 t) where
  show (Conf1 t) = "< " ++ show t ++ " >"

data Conf t = Conf t State

instance Show t => Show (Conf t) where
  show (Conf t s) = "< " ++ show t ++ ", " ++ show s ++ " >"


-- <aexpr, sigma> se evalueaza in <int>
-- <bexpr, sigma> se evalueaza in <bool>
-- <stmt, sigma> se evalueaza in <state>