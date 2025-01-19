sumapatrateimpare :: [Int] -> Int
--sumapatrateimpare xs = foldr (+) 0 (^2) (odd) $ xs
-- nu merge pt ca odd e operatie de filtrare, rezultatul e Bool
sumapatrateimpare xs = foldr (+) 0 (map (^2) (filter odd xs))
sumapatrateimpare' xs = foldr ((+) . (^2)) 0 (filter odd xs)

toatetrue :: [Bool] -> Bool
toatetrue xs = foldr (&&) True xs

allVerifies :: (Int -> Bool) -> [Int] -> Bool
allVerifies f xs = toatetrue (map f xs)
allVerifies' f xs = foldr (\x acc -> f x && acc) True xs

unatrue :: [Bool] -> Bool
unatrue xs = foldr (||) False xs

anyVerifies :: (Int -> Bool) -> [Int] -> Bool
anyVerifies f xs = unatrue (map f xs)

mapFoldr :: (a -> b) -> [a] -> [b]
mapFoldr f xs = foldr (\ x acc -> ((f x):acc)) [] xs

filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr p l = foldr f e l
    where
        f x acc = if p x then x:acc else acc
        e = []

listToInt :: [Integer]-> Integer
listToInt xs = foldl (\ acc x -> acc*10+x) 0 xs

rmChar :: Char -> String -> String
rmChar c x = filter (/= c) x

rmCharsRec :: String -> String -> String
rmCharsRec [] _ = []
rmCharsRec (h:t) s = rmCharsRec t (rmChar h s)

rmCharsFold :: String -> String -> String
rmCharsFold s1 s2 = foldr rmChar s2 s1

myReverse :: [a] -> [a]
myReverse list = foldr f e list
    where
        f x acc = acc ++ [x] 
        e = []

myReverse' list = foldl (:) [] list
    
myUnzip :: [(a, b)] -> ([a], [b])
myUnzip = undefined

