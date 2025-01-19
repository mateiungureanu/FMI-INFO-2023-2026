import Data.Char

verifL :: [Int] -> Bool
verifL l = (length l) `mod` 2 == 0

verifL2 l = even $ length l

takefinal :: [Int] -> Int -> [Int]
takefinal l n
    | n < length l  = drop (length l - n) l
    | otherwise     = l

remove :: [Int] -> Int -> [Int]
remove l n = (take (n-1) l) ++ (drop n l)

-- semiPareRec [0,2,1,7,8,56,17,18] == [0,1,4,28,9]
semiPareRec :: [Int] -> [Int]
semiPareRec [] = []
semiPareRec (h:t)
    | even h    = h `div` 2 : t'
    | otherwise = t'
    where t' = semiPareRec t

myreplicate :: Int -> Int -> [Int]
myreplicate 0 v = []
myreplicate n v = v : (myreplicate (n-1) v)

sumimp :: [Int] -> Int
sumimp [] = 0
sumimp (h:t) 
    | even h    = sumimp t
    | otherwise = sumimp t + h

totalLen :: [String] -> Int
totalLen [] = 0
--totalLen (h:t) = if (h !! 0 == 'A') then length h + totalLen t else totalLen t
totalLen (('A':string):t) = 1 + length string + totalLen t
totalLen (h:t) = totalLen t

palindrom :: String -> Bool
palindrom str = str == reverse str

divizori :: Int -> [Int]
divizori n = [divizor | divizor <- [1..n], n `mod` divizor == 0]

divizori2 n = filter (\divizor -> n `mod` divizor == 0) [1..n]

divizori3 :: Int -> Int -> Bool
divizori3 n divizor = n `mod` divizor == 0
--divizori3 n = \divizor -> n `mod` divizor == 0

listadiv :: [Int] -> [[Int]]
listadiv l = [divizori n | n <- l]
-- listadiv [1,4,6,8] == [[1],[1,2,4],[1,2,3,6],[1,2,4,8]]

nrVocale :: [String] -> Int
nrVocale = undefined
-- nrVocale ["sos", "civic", "palton", "desen", "aerisirea"] == 9

-- f 3 [1,2,3,4,5,6] = [1,2,3,3,4,3,5,6,3]

semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]

-- divizori 4 == [1,2,4]

inInterval :: Int -> Int -> [Int] -> [Int]
inInterval x y l = [n | n <- l, x <= n && n <= y]

inintervalRec :: Int -> Int -> [Int] -> [Int]
inintervalRec x y [] = []
inintervalRec x y (h:t) = if (x <= h && h <= y) then h : (inintervalRec x y t) else inintervalRec x y t

-- inInterval 5 10 [1..15] == [5,6,7,8,9,10]
-- inInterval 5 10 [1,3,5,2,8,-1] == [5,8]


pozitive :: [Int] -> Int
pozitive l = length [n | n<-l, n>0]

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (h:t)
    | h>0       = pozitiveRec t + 1
    | otherwise = pozitiveRec t
-- pozitive [0,1,-3,-2,8,-1,6] == 3

pozitii :: [Int] -> Int -> [Int]
pozitii [] n = []
pozitii (h:t) n
    | even n    = pozitii t (n+1)
    | otherwise = n : pozitii t (n+1)

pozitiiImpare :: [Int] -> [Int]
pozitiiImpare l = pozitii l 0

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = [fst x | x <- zip l [0..], odd (snd x)]
-- pozitiiImpare [0,1,-3,-2,8,-1,6,1] == [1,2,5,7]

multiDigitsRec :: String -> Int
multiDigitsRec [] = 1
multiDigitsRec(h:t)
    | isDigit h = digitToInt h * multiDigitsRec t
    | otherwise = multiDigitsRec t
-- multDigits "The time is 4:25" == 40
-- multDigits "No digits here!" == 1
