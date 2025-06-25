import Data.List (nub)
import Data.Maybe (fromJust)

type Nume = String
data Prop
  = Var Nume
  | F
  | T
  | Not Prop
  | Prop :|: Prop
  | Prop :&: Prop
  | Prop :->: Prop
  | Prop :<->: Prop
  deriving (Eq, Read)
infixr 2 :<->:
infixr 3 :->:
infixr 4 :|:
infixr 5 :&:

p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: ((Not (Var "P") :|: Not (Var "Q")) :&: (Not (Var "P") :|: Not (Var "R")))

instance Show Prop where
  show (Var str) = str
  show F = "F"
  show T = "T"
  show (Not p) = "(~" ++ show p ++ ")"
  show (p1 :|: p2) = "(" ++ show p1 ++ "|" ++ show p2 ++ ")"
  show (p1 :&: p2) = "(" ++ show p1 ++ "&" ++ show p2 ++ ")"
  show (p1 :->: p2) = "(" ++ show p1 ++ "->" ++ show p2 ++ ")"
  show (p1 :<->: p2) = "(" ++ show p1 ++ "<->" ++ show p2 ++ ")"
 
test_ShowProp :: Bool
test_ShowProp =
    show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

eval :: Prop -> Env -> Bool
eval (Var str) env = impureLookup str env
eval F _ = False
eval T _ = True
eval (Not p) env = not (eval p env)
eval (p1 :|: p2) env = (eval p1 env) || (eval p2 env)
eval (p1 :&: p2) env = (eval p1 env) && (eval p2 env)
eval (p1 :->: p2) env = eval (Not p1 :|: p2) env
eval (p1 :<->: p2) env = eval ((p1 :->: p2) :&: (p2 :->: p1)) env

test_eval = eval  (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True

variabile :: Prop -> [Nume]
variabile (Var str) = [str]
variabile F = []
variabile T = []
variabile (Not p) = variabile p
variabile (p1 :&: p2) = nub $ variabile p1 ++ variabile p2
variabile (p1 :|: p2) = nub $ variabile p1 ++ variabile p2
variabile (p1 :->: p2) = nub $ variabile p1 ++ variabile p2
variabile (p1 :<->: p2) = nub $ variabile p1 ++ variabile p2
 
test_variabile =
  variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]

envs :: [Nume] -> [Env]
envs [] = [[]]
envs (h:t) = [e ++ ePlus | e <- [ [(h, False)], [(h, True)] ], ePlus <- envs t]
test_envs = 
    envs ["P", "Q"]
    ==
    [ [ ("P",False)
      , ("Q",False)
      ]
    , [ ("P",False)
      , ("Q",True)
      ]
    , [ ("P",True)
      , ("Q",False)
      ]
    , [ ("P",True)
      , ("Q",True)
      ]
    ]

satisfiabila :: Prop -> Bool
satisfiabila p = any (eval p) (envs $ variabile p)
 
test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False

valida :: Prop -> Bool
valida p = all (eval p) (envs $ variabile p)

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True


echivalenta :: Prop -> Prop -> Bool
echivalenta p1 p2 = let es = envs $ nub $ variabile p1 ++ variabile p2 in
    map (eval p1) es == map (eval p2) es

echivalenta' :: Prop -> Prop -> Bool
echivalenta' p1 p2 = valida (p1 :<->: p2)

test_echivalenta1 =
  True
  ==
  (Var "P" :&: Var "Q") `echivalenta'` (Not (Not (Var "P") :|: Not (Var "Q")))
test_echivalenta2 =
  False
  ==
  (Var "P") `echivalenta'` (Var "Q")
test_echivalenta3 =
  True
  ==
  (Var "R" :|: Not (Var "R")) `echivalenta'` (Var "Q" :|: Not (Var "Q"))

