data Tree = Empty  -- arbore vid
   | Node Int Tree Tree Tree -- arbore cu valoare de tip Int in radacina si 3 fii
      
-- extree :: Tree
-- extree = Node 4 (Node 5 Empty Empty Empty) 
--                 (Node 3 Empty Empty (Node 1 Empty Empty Empty)) Empty

class ArbInfo t where
  level :: t -> Int -- intoarce inaltimea arborelui; pt un arbore vid
                      -- se considera ca are inaltimea 0
  sumval :: t -> Int -- intoarce suma valorilor din arbore
  nrFrunze :: t -> Int -- intoarce nr de frunze al arborelui
-- level extree
-- 3
-- sumval extree
-- 13
-- nrFrunze extree
-- 2

instance ArbInfo Tree where
  level Empty = 0
  level (Node _ t1 t2 t3) = 1 + max (level t1) (max (level t2) (level t3))

  sumval Empty = 0
  sumval (Node v t1 t2 t3) = v + sumval t1 + sumval t2 + sumval t3

  nrFrunze Empty = 0
  nrFrunze (Node v t1 t2 t3)
    | level (Node v t1 t2 t3) == 1 = 1
    | otherwise = nrFrunze t1 + nrFrunze t2 + nrFrunze t3

class Scalar a where
  zero :: a
  one :: a
  adds :: a -> a -> a
  mult :: a -> a -> a
  negates :: a -> a
  recips :: a -> a

instance Scalar Rational where
    zero = 0
    one = 1
    adds = (+)
    mult = (*)
    negates x = -x
    recips = recip

class (Scalar a) => Vector v a where
  zerov :: v a
  onev :: v a
  addv :: v a -> v a -> v a -- adunare vector
  smult :: a -> v a -> v a  -- inmultire cu scalare
  negatev :: v a -> v a -- negare vector

data V2D a = V2D a a
  deriving Show

instance (Scalar a) => Vector V2D a where
  zerov = V2D zero zero
  onev = V2D one one
  addv (V2D v11 v12) (V2D v21 v22) = V2D (adds v11 v21) (adds v12 v22)
  smult a (V2D v1 v2) = V2D (mult a v1) (mult a v2)
  negatev (V2D v1 v2) = V2D (negates v1) (negates v2)
