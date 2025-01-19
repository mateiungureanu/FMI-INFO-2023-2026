data Tree = Empty  -- arbore vid
    | Node Int Tree Tree Tree -- arbore cu valoare de tip Int in radacina si 3 fii
      
extree :: Tree
extree = Node 4 (Node 5 Empty Empty Empty) 
                (Node 3 Empty Empty (Node 1 Empty Empty Empty)) Empty

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
  level (Node k left mid right) = maximum[level left, level mid, level right] + 1
  sumval Empty = 0
  sumval (Node k left mid right) = k + sum[sumval left, sumval mid, sumval right]
  nrFrunze Empty = 0
  nrFrunze (Node k Empty Empty Empty) = 1
  nrFrunze (Node k left mid right) = nrFrunze left + nrFrunze mid + nrFrunze right
  
  -- nrFrunze (Node k left mid right)
  --   | level (Node k left mid right) == 1 = 1
  --   | otherwise = nrFrunze left + nrFrunze mid + nrFrunze right

class Scalar a where
  zero :: a
  one :: a
  adds :: a -> a -> a
  mult :: a -> a -> a
  negates :: a -> a
  recips :: a -> a --inversa la inmultire; exista recip, asta e recip scalar

instance Scalar Rational where
  zero = 0
  one = 1
  adds = (+)
  mult = (*)
  negates = negate
  recips = recip

-- recips (toRational 3)
-- 1 % 3
-- negates (toRational 7) 
-- (-7) % 1

class (Scalar a) => Vector v a where
  zerov :: v a
  onev :: v a
  addv :: v a -> v a -> v a -- adunare vector
  smult :: a -> v a -> v a  -- inmultire cu scalare
  negatev :: v a -> v a -- negare vector

data Vec2D a = Vec2D a a
  deriving Show

instance (Scalar a) => Vector Vec2D a where
  zerov = Vec2D zero zero
  onev = Vec2D one one
  addv (Vec2D x1 y1) (Vec2D x2 y2) = Vec2D (adds x1 x2) (adds y1 y2) 
  smult k (Vec2D x y) = Vec2D (mult k x) (mult k y)
  negatev (Vec2D x y) = Vec2D (negates x) (negates y)

-- addv (Vec2D (toRational 0) (toRational 0)) (Vec2D (toRational 1) (toRational 1))
-- Vec2D (1 % 1) (1 % 1)

data Vec3D a = Vec3D a a a
  deriving Show

instance (Scalar a) => Vector Vec3D a where
  zerov = Vec3D zero zero zero
  onev = Vec3D one one one
  addv (Vec3D x1 y1 z1) (Vec3D x2 y2 z2) = Vec3D (adds x1 x2) (adds y1 y2) (adds z1 z2)
  smult k (Vec3D x y z) = Vec3D (mult k x) (mult k y) (mult k z)
  negatev (Vec3D x y z) = Vec3D (negates x) (negates y) (negates z)

-- addv (Vec3D (toRational 0) (toRational 0) (toRational 0)) (Vec3D (toRational 1) (toRational 1) (toRational 1))
-- Vec3D (1 % 1) (1 % 1) (1 % 1)

disjElim :: Either a b -> (a -> c) -> (b -> c) -> c
disjElim (Right b) f g = g b
disjElim (Left a) f g = f a