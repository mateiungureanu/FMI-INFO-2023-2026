{-
[x^2 |x <- [1..10], x `rem` 3 == 2]
[(x,y) | x <- [1..5], y <- [x..(x+2)]]
[(x,y) | x <- [1..3], let k = x^2, y <- [1..k]]
[x | x <- "Facultatea de Matematica si Informatica", elem x ['A'..'Z']]
[[x..y] | x <- [1..5], y <- [1..5], x < y]
-}

factori :: Int -> [Int]
factori val = [i | i <- [1..val], val `mod` i == 0]
--factori = \val -> [i | i <- [1..val], val `mod` i == 0]

prim :: Int -> Bool
prim n = length (factori n) == 2

numerePrime :: Int -> [Int]
numerePrime n = [x | x <-  [2..n], prim x]

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 _ _ [] = []
myzip3 _ [] _ = []
myzip3 [] _ _ = []
myzip3 (h1:l1) (h2:l2) (h3:l3) = (h1, h2, h3) : myzip3 l1 l2 l3
myzip31 l1 l2 l3 = [(a,b,c) | (a,(b,c)) <- zip l1 (zip l2 l3)]

firstEl :: [(a,b)] -> [a]
firstEl = map fst

sumList :: [[Int]] -> [Int]
sumList = map sum

prel2 :: [Int] -> [Int]
prel2 xs = map transformare xs where
        transformare x
            |even x     = x `div` 2
            |otherwise  = x * 2

contineCaracter :: Char -> [String] -> [String]
contineCaracter c lista = filter (c `elem`) lista

patrate :: [Int] -> [Int]
patrate xs = map (^2) (filter odd xs)

patratepoz :: [Int] -> [Int]
patratepoz l = map ((^2) . fst) (filter (odd . snd) (zip l [1..]))

ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = undefined

ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata = undefined
