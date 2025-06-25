data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]
    deriving Show

verifica :: Matrice -> Int -> Bool
-- verifica (M lines) n = foldr ((&&) . \(L line) -> sum line == n) True lines
verifica (M lines) n = all (\(L line) -> sum line == n) lines

doarPozN :: Matrice -> Int -> Bool
-- doarPozN (M lines) len = all (\(L line) -> all (>0) line) (filter (\(L line) -> length line == len) lines)
doarPozN (M lines) len = all allPos nLengthLines
    where
        nLengthLines = filter (\(L line) -> length line == len) lines
        allPos (L line) = all (>0) line

corect :: Matrice -> Bool
corect (M lines) = allEq $ map (\(L line) -> length line) lines
    where
        allEq :: [Int] -> Bool
        allEq [] = True
        allEq (h:t) = foldr ((&&) . (== h)) True t


data Orientation = N | W | S | E
    deriving Show
data Turtle = T (Int, Int) Orientation
    deriving Show
data Action = Step | Turn
    deriving Show
data Command = Do Action | Repeat Int Action | Seq Command Command | Wait
    deriving Show

getPizza :: Turtle -> [Command] -> Turtle
getPizza turtle [] = turtle

getPizza (T (x, y) N) ((Do Step):t) = getPizza (T (x, y+1) N) t
getPizza (T (x, y) W) ((Do Step):t) = getPizza (T (x-1, y) W) t
getPizza (T (x, y) S) ((Do Step):t) = getPizza (T (x, y-1) S) t
getPizza (T (x, y) E) ((Do Step):t) = getPizza (T (x+1, y) E) t

getPizza (T (x, y) N) ((Do Turn):t) = getPizza (T (x, y) E) t
getPizza (T (x, y) E) ((Do Turn):t) = getPizza (T (x, y) S) t
getPizza (T (x, y) S) ((Do Turn):t) = getPizza (T (x, y) W) t
getPizza (T (x, y) W) ((Do Turn):t) = getPizza (T (x, y) N) t

getPizza turtle (Repeat n a:t) = getPizza turtle $ replicate n (Do a) ++ t
getPizza turtle (Seq c1 c2:t) = getPizza turtle (c1:c2:t)
getPizza turtle (Wait:t) = getPizza turtle t


listToComm :: [Command] -> Command
listToComm = foldr Seq Wait

exec :: Command -> Turtle -> Turtle
exec Wait turtle = turtle

exec (Do Step) (T (x, y) N) = T (x, y+1) N
exec (Do Step) (T (x, y) W) = T (x-1, y) W
exec (Do Step) (T (x, y) S) = T (x, y-1) S
exec (Do Step) (T (x, y) E) = T (x+1, y) E

exec (Do Turn) (T (x, y) N) = T (x, y) E
exec (Do Turn) (T (x, y) E) = T (x, y) S
exec (Do Turn) (T (x, y) S) = T (x, y) W
exec (Do Turn) (T (x, y) W) = T (x, y) N

exec (Repeat 0 a) turtle = turtle
exec (Repeat n a) turtle = (exec (Repeat (n-1) a) . exec (Do a)) turtle
exec (Seq c1 c2) turtle = (exec c2 . exec c1) turtle

getPizza' :: [Command] -> Turtle -> Turtle
getPizza' l = exec $ listToComm l
