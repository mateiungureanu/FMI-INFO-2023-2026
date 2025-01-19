myInt = 31415926535897932384626433832795028841971693993751058209749445923

double :: Integer -> Integer
double x = x+x

--maxim :: Integer -> Integer -> Integer
maxim x y = if (x > y)
               then x
          else y

maxim3 :: Integer -> Integer -> Integer -> Integer
maxim3 x y z = 
    if (x >= y)
        then 
            if (x >= z)
                then x
                else z
        else 
            if (y <= z)
                then z
                else y

max3 x y z = let
             u = maxim x y
             in (maxim  u z)

--max3test :: Integer -> Integer -> Integer -> Bool
max3test x y z = 
    let
        u = max3 x y z
    in (u >= x && u >= y && u >= z)

data Bool232 = True232 | False232

and232 :: Bool232 -> Bool232 -> Bool232
and232 _ False232 = False232
and232 False232 _ = False232
and232 _ _ = True232

suma :: Integer -> Integer -> Integer
suma x y = x*x + y^2

paritate :: Integer -> String
paritate x =
    if (x `mod` 2 == 0)
        then "par"
        else "impar"
-- sau even x

fact :: Integer -> Integer
fact x = 
    if x==0
        then 1
        else x * fact(x-1)

fact2 :: Integer -> Integer
fact2 0 = 1
fact2 x = x * fact2(x-1)

fact3 :: Integer -> Integer
fact3 x
    | x==0 = 1
    | otherwise = x*fact3(x-1)

get_max :: [Integer] -> Integer
get_max [elem] = elem
get_max (head:tail) = maxim head (get_max tail)
--get_max (head:tail) = maxim head $ get_max tail

poly :: Double -> Double -> Double -> Double -> Double
poly a b c x = a*x^2+b*x+c

eeny :: Integer -> String
eeny x =
    if even x
        then "eeny"
        else "meeny"

fizzbuzz :: Integer -> String
fizzbuzz x =
    if x `mod` 15 == 0
        then "fizzbuzz"
        else
            if x `mod` 3 == 0
                then "fizz"
                else
                    if x `mod` 5 == 0
                        then "buzz"
                        else ""

fizzbuzz2 :: Integer -> String
fizzbuzz2 x
    | x `mod` 15 == 0 ="fizzbuzz"
    | x `mod` 5 == 0 ="fizz"
    | x `mod` 3 == 0 ="buzz"
    | otherwise = ""

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
    | n < 2     = n
    | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)
    
fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)

tribonacciCazuri :: Integer -> Integer
tribonacciCazuri n
    | n == 1     = 1
    | n == 2     = 1
    | n == 3     = 2
    | otherwise = tribonacciCazuri (n - 1) + tribonacciCazuri (n - 2) + tribonacciCazuri (n - 3)

tribonacciEccuational :: Integer -> Integer
tribonacciEccuational 1 = 1
tribonacciEccuational 2 = 1
tribonacciEccuational 3 = 2
tribonacciEccuational n = tribonacciEccuational (n-1) + tribonacciEccuational (n-2) + tribonacciEccuational (n-3)



binomial :: Integer -> Integer -> Integer
binomial _ 0 = 1
binomial 0 _ = 0
binomial n k = binomial (n-1) k + binomial (n-1) (k-1)
