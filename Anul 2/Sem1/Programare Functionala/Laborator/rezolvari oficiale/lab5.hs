sumaPatImp :: [Int] -> Int
sumaPatImp = (foldr (+) 0) . map (^2) . filter odd

allTrue :: [Bool] -> Bool
allTrue = foldr (&&) True

allVerifies :: (Int -> Bool) -> [Int] -> Bool
allVerifies p xs = foldr ((&&) . p) True xs

anyVerifies :: (Int -> Bool) -> [Int] -> Bool
anyVerifies p xs = foldr ((||) . p) False xs

mapFoldr :: (a -> b) -> [a] -> [b]
mapFoldr f = foldr ((:) . f) []

filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr p = foldr f e
    where
        f x interm = if p x then x : interm else interm
        e = []

listToInt :: [Integer] -> Integer
listToInt = foldl f e
    where
        f interm x = 10 * interm + x
        e = 0

rmChar :: Char -> String -> String
rmChar c = filter (/= c)

rmCharsRec :: String -> String -> String
rmCharsRec str1 "" = str1
rmCharsRec str1 (c:str2) = rmCharsRec (rmChar c str1) str2

rmCharsFold :: String -> String -> String
rmCharsFold str1 str2 = foldr rmChar str2 str1

myReverse :: [Int] -> [Int]
myReverse = foldr (\x interm -> interm ++ [x]) []

myElem :: Int -> [Int] -> Bool
myElem el = foldr ((||) . (== el)) False

myUnzip :: [(a, b)] -> ([a], [b])
myUnzip = foldr f e
    where
        f (xa, xb) (xsa, xsb) = (xa : xsa, xb : xsb)
        e = ([], [])

union :: [Int] -> [Int] -> [Int]
union l1 = foldr f e
    where
        f x interm | x `elem` interm    =   interm
                   | otherwise          =   x : interm
        e = l1

intersect :: [Int] -> [Int] -> [Int]
intersect l1 = foldr f e
    where
        f x interm | x `elem` l1 && not (x `elem` interm) =  x : interm
                   | otherwise    =  interm
        e = []

insertEverywhere :: Int -> [Int] -> [[Int]]
insertEverywhere a [] = [[a]]
insertEverywhere a (x:xs) = (a:x:xs) : (map (x:) (insertEverywhere x xs))

permutations :: [Int] -> [[Int]]
permutations = foldr f e
    where
        f x permPoss = concatMap (insertEverywhere x) permPoss
        e = [[]]
        insertEverywhere x xs = undefined
