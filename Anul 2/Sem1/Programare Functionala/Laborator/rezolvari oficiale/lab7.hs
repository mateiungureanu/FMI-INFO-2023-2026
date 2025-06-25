data Expr = Const Int -- integer constant
          | Expr :+: Expr -- addition
          | Expr :*: Expr -- multiplication
           deriving Eq

data Operation = Add | Mult deriving (Eq, Show)

data Tree = Lf Int -- leaf
          | Node Operation Tree Tree -- branch
           deriving (Eq, Show)
           
instance Show Expr where
  show (Const x) = show x
  show (e1 :+: e2) = "(" ++ show e1 ++ " + "++ show e2 ++ ")"
  show (e1 :*: e2) = "(" ++ show e1 ++ " * "++ show e2 ++ ")"           

evalExp :: Expr -> Int
evalExp (Const n) = n
evalExp (e1 :+: e2) = evalExp e1 + evalExp e2
evalExp (e1 :*: e2) = evalExp e1 * evalExp e2

exp1 = ((Const 2 :*: Const 3) :+: (Const 0 :*: Const 5))
exp2 = (Const 2 :*: (Const 3 :+: Const 4))
exp3 = (Const 4 :+: (Const 3 :*: Const 3))
exp4 = (((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2)
test11 = evalExp exp1 == 6
test12 = evalExp exp2 == 14
test13 = evalExp exp3 == 13
test14 = evalExp exp4 == 16

evalArb :: Tree -> Int
evalArb (Lf n) = n
evalArb (Node Add t1 t2) = evalArb t1 + evalArb t2
evalArb (Node Mult t1 t2) = evalArb t1 * evalArb t2


arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)

test21 = evalArb arb1 == 6
test22 = evalArb arb2 == 14
test23 = evalArb arb3 == 13
test24 = evalArb arb4 == 16


expToArb :: Expr -> Tree
expToArb (Const n) = Lf n
expToArb (e1 :+: e2) = Node Add (expToArb e1) (expToArb e2)
expToArb (e1 :*: e2) = Node Mult (expToArb e1) (expToArb e2)


data IntSearchTree value
  = Empty
  | BNode
      (IntSearchTree value)     -- elemente cu cheia mai mica
      Int                       -- cheia elementului
      (Maybe value)             -- valoarea elementului
      (IntSearchTree value)     -- elemente cu cheia mai mare
    deriving Show
  
lookup' :: Int -> IntSearchTree value -> Maybe value
lookup' n Empty = Nothing
lookup' n (BNode left key val right)
    | key == n  = val
    | key < n   = lookup' n right
    | key > n   = lookup' n left

keys ::  IntSearchTree value -> [Int]
keys Empty = []
keys (BNode left key (Just _) right) = keys left ++ [key] ++ keys right
keys (BNode left key Nothing right) = keys left ++ keys right

values :: IntSearchTree value -> [value]
values Empty = []
values (BNode left _ (Just val) right) = values left ++ [val] ++ values right
values (BNode left _ _ right) = values left ++ values right

insert :: Int -> value -> IntSearchTree value -> IntSearchTree value
insert key val Empty = BNode Empty key (Just val) Empty
insert key val (BNode left treeKey treeVal right)
    | key == treeKey = BNode left key (Just val) right
    | key < treeKey  = BNode (insert key val left) treeKey treeVal right
    | key > treeKey  = BNode left treeKey treeVal (insert key val right)

delete :: Int -> IntSearchTree value -> IntSearchTree value
delete key Empty = Empty
delete key (BNode left treeKey treeVal right)
    | key == treeKey = BNode left key Nothing right
    | key < treeKey  = BNode (delete key left) treeKey treeVal right
    | key > treeKey  = BNode left treeKey treeVal (delete key right)

toList :: IntSearchTree value -> [(Int, value)]
toList Empty = []
toList (BNode left key (Just val) right) = toList left ++ [(key, val)] ++ toList right
toList (BNode left _ Nothing right) = toList left ++ toList right

fromList :: [(Int,value)] -> IntSearchTree value 
fromList = foldr (uncurry insert) Empty

printTree :: IntSearchTree value -> String
printTree Empty = ""
printTree (BNode Empty key _ Empty) = show key
printTree (BNode Empty key _ right) = show key ++ " (" ++ printTree right ++ ")"
printTree (BNode left key _ Empty) = "(" ++ printTree left ++ ") " ++ show key
printTree (BNode left key _ right) = "(" ++ printTree left ++ ") " ++ show key ++ " (" ++ printTree right ++ ")"

getMedian :: [a] -> ([a], Maybe a, [a])
getMedian [] = ([], Nothing, [])
getMedian list = let mid = length list `div` 2 in
    (take mid list, Just $ list !! mid, drop (mid+1) list)

balance :: IntSearchTree value -> IntSearchTree value
balance tree = let (leftItems, root, rightItems) = getMedian $ toList tree in
    case root of
        Nothing -> Empty
        Just (key, val) -> BNode (balance $ fromList leftItems) key (Just val) (balance $ fromList rightItems)
