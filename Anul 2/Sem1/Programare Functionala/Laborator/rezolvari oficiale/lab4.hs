mymap3 :: [Int] -> [Int] -> [Int] -> [(Int, (Int, Int))]
mymap3 l1 l2 l3 = zip l1 (zip l2 l3)

factori :: Int -> [Int]
factori n = [f | f <- [1..n], n `mod` f == 0]

prim :: Int -> Bool
prim n = length (factori n) == 2

numerePrime :: Int -> [Int]
numerePrime n = [p | p <- [2..n], prim n]

firstEl :: [(a,b)] -> [a]
firstEl = map fst

sumList :: [[Int]] -> [Int]
sumList = map sum

prel2 :: [Int] -> [Int]
prel2 = map (\x -> if even x then x `div` 2 else x * 2)

ex9 :: Char -> [String] -> [String]
ex9 c = filter (c `elem`)

ex10 :: [Int] -> [Int]
ex10 = (map (^ 2)) . (filter odd)

ex11 :: [Int] -> [Int]
ex11 xs = map (\x -> fst x ^ 2) $ filter (odd . snd) (zip xs [0..])

ex11' :: [Int] -> [Int]
ex11' xs = map (\(a, b) -> a ^ 2) $ filter (\(a, b) -> odd b) (zip xs [0..])

ex12 :: [String] -> [String]
ex12 =
    let isVowel = \x -> elem x ['a', 'e', 'i', 'o', 'u'] in
        map (filter isVowel)

ex12' :: [String] -> [String]
ex12' = map (filter isVowel) where
    isVowel = \x -> elem x ['a', 'e', 'i', 'o', 'u']

mymap :: (a -> b) -> [a] -> [b]
mymap f [] = []
mymap f (h:t) = (f h) : mymap f t

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter p [] = []
myfilter p (h:t)
    | p h   =   h : myfilter p t
    | otherwise = myfilter p t

step :: (Int, Int) -> Char -> [(Int, Int, Char)] -> [[(Int, Int, Char)]]
step (xMax, yMax) p c =
    let availablePos = [(x, y) | x <- [0..xMax], y <- [0..yMax], elem (x, y) [(a, b) | (a, b, _) <- c] == False] in
        [(x, y, p) : c | (x, y) <- availablePos]

next :: (Int, Int) -> Char -> [[(Int, Int, Char)]] -> [[(Int, Int, Char)]]
next (xMax, yMax) p cs =
    concat $ map (step (xMax, yMax) p) cs

win :: (Int, Int) -> Char -> [[(Int, Int, Char)]] -> [[(Int, Int, Char)]]
win (xMax, yMax) p cs =
    filter (winning xMax yMax p) cs where
        lines xMax yMax = [[(x, y) | y <- [0..yMax]] | x <- [0..xMax]]
        cols xMax yMax = [[(x, y) | x <- [0..xMax]] | y <- [0..yMax]]
        digs xMax yMax =
            [princ, sec] where
                princ = [(d, d) | d <- [0..min xMax yMax]]
                sec = [(y, x) | (x, y) <- princ]
        winning xMax yMax p c =
            any (\coords -> all (\(x, y) -> elem (x, y, p) c) coords) (lines xMax yMax ++ cols xMax yMax ++ digs xMax yMax)

takeTurns :: (Int, Int) -> String -> [[(Int, Int, Char)]] -> [[(Int, Int, Char)]]
takeTurns size ('X':rest) configs = takeTurns size rest (next size 'X' configs)
takeTurns size ('O':rest) configs = takeTurns size rest (next size 'O' configs)
takeTurns size "" configs = configs

playXO :: (Int, Int) -> String -> [[[(Int, Int, Char)]]]
playXO size turns = [win size 'X' possConf, win size 'O' possConf] where
    possConf = takeTurns size turns [[]]
