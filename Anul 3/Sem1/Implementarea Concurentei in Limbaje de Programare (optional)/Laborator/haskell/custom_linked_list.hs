removeOddHalfEven :: [Int] -> [Int]
removeOddHalfEven [] = []
removeOddHalfEven (x:xs)
    | even x = (x `div` 2) : removeOddHalfEven xs
    | otherwise = removeOddHalfEven xs

removeOddHalfEven' :: [Int] -> [Int]
removeOddHalfEven' ls = map (\x -> x `div` 2)
    $ filter (even) ls

removeOddHalfEven'' ls = [a `div` 2 | a <- ls, even a]

--cu foldr
removeOddHalfEven''' :: [Int] -> [Int]
removeOddHalfEven''' = foldr (\x u -> if even x then (x `div` 2) : u else u) []

-- Proprietatea de universalitate
-- g [] = init
-- g(x:xs) = f x (g xs)
-- =>
-- g = foldr f init

data LList a = Nil | Cons a (LList a)

l1 :: LList Int
l1 = Cons 1 $ Cons 2 $ Cons 3 Nil

instance Eq a => Eq (LList a) where
    Nil == Nil = True
    (Cons x xs) == (Cons y ys) = x == y && xs == ys

instance (Show a) => Show (LList a) where
    show Nil = "[]"
    show (Cons x xs) = show x ++ ", " ++ show xs

lAppend :: LList a -> LList a -> LList a
lAppend Nil l2 = l2
lAppend (Cons x xs) l2 = Cons x (lAppend xs l2)

l2 :: LList Int
l2 = Cons 4 $ Cons 5 $ Cons 6 Nil

instance Semigroup (LList a) where
    (<>) = lAppend

instance Monoid (LList a) where
    mempty = Nil

lMap :: (a -> b) -> LList a -> LList b
lMap _ Nil = Nil
lMap f (Cons x xs) = Cons (f x) $ lMap f xs

instance Functor LList where
    fmap = lMap

lFilter :: (a -> Bool) -> LList a -> LList a 
lFilter _ Nil = Nil
lFilter p (Cons x xs)
    | p x = Cons x $ lFilter p xs
    | otherwise = lFilter p xs

lFoldr :: (a -> b -> b) -> b -> LList a -> b 
lFoldr _ init Nil = init
lFoldr f init (Cons x xs) = f x $ lFoldr f init xs

instance Foldable LList where
    foldr = lFoldr

lToList :: LList a -> [a]
lToList Nil = []
lToList (Cons x xs) = x : lToList xs