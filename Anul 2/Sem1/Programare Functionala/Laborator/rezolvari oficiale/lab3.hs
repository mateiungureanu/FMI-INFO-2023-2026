import Data.Char


verifL :: [Int] -> Bool
verifL = \l -> ($) even (length l)

takefinal l n = drop (len - n) l
    where len = length l

remove :: [a] -> Int -> [a]
remove [] _ = []
remove (x:xs) 1 = xs
remove (x:xs) n = x : (remove xs (n-1))

remove' :: [a] -> Int -> [a]
remove' xs n = (take (n-1) xs) ++ (drop n xs)

semiPareRec :: [Int] -> [Int]
semiPareRec [] = []
semiPareRec (x:xs)
    | even x    =   (x `div` 2) : (semiPareRec xs)
    | otherwise =   semiPareRec xs

semiPareRec' xs = map (`div` 2) $ filter even xs

semiPareRec'' xs = [x `div` 2 | x <- xs, even x]

myreplicate :: Int -> a -> [a]
myreplicate 0 v = []
myreplicate n v = v : myreplicate (n-1) v

sumImp :: [Int] -> Int
sumImp [] = 0
sumImp (x:xs)
    | even x    =   sumImp xs
    | otherwise =   x + sumImp xs

sumImp' :: [Int] -> Int
sumImp' xs = foldr (+) 0 $ filter odd xs

totalLen :: [String] -> Int
totalLen [] = 0
totalLen (('a':tail):xs) = 1 + length tail + totalLen xs
totalLen (x:xs) = totalLen xs


totalLen' :: [String] -> Int
totalLen' xs = foldr (+) 0 $ map measure xs where
    measure ('a':xs) = 1 + length xs
    measure xs = 0

nrVocale' :: [String] -> Int
nrVocale' xs = foldr (+) 0 $ map length palindromeVowels where
    palindromeVowels = [filter (\char -> elem char ['a', 'e', 'i', 'o', 'u']) p | p <- palindromes]
    palindromes = filter (\str -> str == reverse str) xs

f :: Int -> [Int] -> [Int]
f n [] = []
f n (x:xs)
    | even x    = x : n : (f n xs)
    | otherwise = x : (f n xs)

divizori :: Int -> [Int]
divizori n = [d | d <- [1..n], n `mod` d == 0]

listadiv :: [Int] -> [[Int]]
listadiv xs = map divizori xs

listadiv' :: [Int] -> [[Int]]
listadiv' ln = do
    n <- ln
    return $ divizori n

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec lb gb [] = []
inIntervalRec lb gb (x:xs)
    | x >= lb && x <= gb    =   x : inIntervalRec lb gb xs
    | otherwise = inIntervalRec lb gb xs

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp lb gb xs = [x | x <- xs, x >= lb && x <= gb]

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
    | x > 0     = 1 + pozitiveRec xs
    | otherwise = pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp l = length [x | x <- l, x > 0]

pozitive' :: [Int] -> Int
pozitive' l = length $ filter (\x -> x > 0) l

pozitiiImpare :: [Int] -> [Int]
pozitiiImpare = pozitiiImpare' 0  where
    pozitiiImpare' :: Int -> [Int] -> [Int]
    pozitiiImpare' n []  = []
    pozitiiImpare' n (x:xs)
        | odd x       =   n : pozitiiImpare' (n+1) xs
        | otherwise   =   pozitiiImpare' (n+1) xs

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [snd tup | tup <- zip l [0..], odd $ fst tup]


multDigits :: String -> Int
multDigits []       = 1
multDigits (char:string)
    | isDigit char  =   digitToInt char * multDigits string
    | otherwise     =   multDigits string

multDigitsComp :: String -> Int
multDigitsComp string = product [digitToInt c | c <- string, isDigit c]

insertAt :: Int -> a -> [a] -> [a]
insertAt 0 el list = el:list
insertAt n el [] = [el]
insertAt n el (h:t) = h : (insertAt (n-1) el t)


permutations :: [a] -> [[a]]
permutations [] = [[]]
permutations (h:t) = [insertAt idx h perm | perm <- permutations t, idx <- [0..length t]]

arrangements :: Eq a => [a] -> Int -> [[a]]
arrangements l 0 = [[]]
arrangements l k = [elemChoice:restChoices | elemChoice <- l, restChoices <- [arr | arr <- arrangements l (k-1), not $ elem elemChoice arr]]

combinations :: Ord a => [a] -> Int -> [[a]]
combinations l 0 = [[]]
combinations l k = [elemChoice:restChoices | elemChoice <- l, restChoices <- [c | c <- combinations l (k-1), all (> elemChoice) c]]


type ChessConfig = (Int, Int)
type ChessPos = (Int, Int)

queenPosition :: ChessConfig -> [ChessPos]
-- for one queen
queenPosition (rows, cols) = [(p1, p2) | p1 <- [1..rows], p2 <- [1..cols]]

queensDistribtion :: ChessConfig -> Int -> [[ChessPos]]
queensDistribtion config numQueens = combinations (queenPosition config) numQueens

queenAttack :: ChessPos -> ChessPos -> Bool 
queenAttack (p11, p12) (p21, p22)
    | p11 == p21    =   True
    | p12 == p22    =   True
    | abs (p11 - p21) == abs (p12 - p22) = True
    | otherwise     =   False

canAttack :: [ChessPos] -> Bool
canAttack ps = any (uncurry queenAttack) [(q1, q2) | q1 <- ps, q2 <- ps, q1 /= q2]

queens :: ChessConfig -> Int -> [[ChessPos]]
queens config numQueens = [dist | dist <- queensDistribtion config numQueens, not (canAttack dist)]




permutations' :: [a] -> [[a]]
permutations' [] = [[]]
permutations' (h:t) = do
    p   <- permutations' t
    idx <- [0..length t]
    return $ insertAt idx h p

arrangements' :: Eq a => [a] -> Int -> [[a]]
arrangements' l 0 = [[]]
arrangements' l k = do
    elemChoice <- l
    restChoices <- [c | c <- arrangements' l (k-1), not $ elem elemChoice c]
    return $ elemChoice : restChoices

combinations' :: Ord a => [a] -> Int -> [[a]]
combinations' l 0 = [[]]
combinations' l k = do
    elemChoice <- l
    restChoices <- [c | c <- combinations' l (k-1), all (> elemChoice) c]
    return $ elemChoice : restChoices
