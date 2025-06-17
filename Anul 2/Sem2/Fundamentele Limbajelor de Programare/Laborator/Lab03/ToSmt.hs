module ToSmt (bexprToSmt) where


import Syntax (BExpr(..), AExpr(..))
import Data.List (nub)

class ToSmt a where
    toSmt :: a -> String

class HasVars a where
    getVars :: a -> [String]

instance ToSmt BExpr where
    toSmt :: BExpr -> String
    toSmt (BTrue) = "true"
    toSmt (BFalse) = "false"
    toSmt (BNot b) = "(not " ++ toSmt b ++ ")"
    toSmt (BAnd b1 b2) = "(and " ++ toSmt b1 ++ " " ++ toSmt b2 ++ ")"
    toSmt (BOr b1 b2) = "(or " ++ toSmt b1 ++ " " ++ toSmt b2 ++ ")"
    toSmt (BEq a1 a2) = "(= " ++ toSmt a1 ++ " " ++ toSmt a2 ++ ")"
    toSmt (BLe a1 a2) = "(<= " ++ toSmt a1 ++ " " ++ toSmt a2 ++ ")"

instance ToSmt AExpr where
    toSmt :: AExpr -> String
    toSmt (ENum n) = show n
    toSmt (EId x) = x
    toSmt (EPlu a1 a2) = "(+ " ++ toSmt a1 ++ " " ++ toSmt a2 ++ ")"
    toSmt (EMinu a1 a2) = "(- " ++ toSmt a1 ++ " " ++ toSmt a2 ++ ")"
    toSmt (EMul a1 a2) = "(* " ++ toSmt a1 ++ " " ++ toSmt a2 ++ ")"

instance HasVars BExpr where
    getVars :: BExpr -> [String]
    getVars BTrue = []
    getVars BFalse = []
    getVars (BNot b) = getVars b
    getVars (BAnd b1 b2) = nub $ getVars b1 ++ getVars b2
    getVars (BOr b1 b2) = nub $ getVars b1 ++ getVars b2
    getVars (BEq a1 a2) = nub $ getVars a1 ++ getVars a2
    getVars (BLe a1 a2) = nub $ getVars a1 ++ getVars a2

instance HasVars AExpr where
    getVars :: AExpr -> [String]
    getVars (ENum _) = []
    getVars (EId x) = [x]
    getVars (EPlu a1 a2) = nub $ getVars a1 ++ getVars a2
    getVars (EMinu a1 a2) = nub $ getVars a1 ++ getVars a2
    getVars (EMul a1 a2) = nub $ getVars a1 ++ getVars a2

bexprToSmt :: BExpr -> String
bexprToSmt e = unlines $
    ["(set-logic QF_NIA)", "(set-option :produce-models true)"]
    ++ declareSmtConsts (getVars e)
    ++ ["(assert (not " ++ toSmt e ++ "))", "(check-sat)"]

declareSmtConsts :: [String] -> [String]
declareSmtConsts = map (\x -> "(declare-const " ++ x ++ " Int)")
