import System.Win32 (xBUTTON1, sCS_32BIT_BINARY)
{- 
class Functor f where 
     fmap :: (a -> b) -> f a -> f b 
class Functor f => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b

Just length <*> Just "world"

Just (++" world") <*> Just "hello,"
pure (+) <*> Just 3 <*> Just 5
pure (+) <*> Just 3 <*> Nothing
(++) <$> ["ha","heh"] <*> ["?","!"]
-}
data List a = Nil
            | Cons a (List a)
        deriving (Eq, Show)

instance Functor List where
    fmap _ Nil = Nil
    fmap f (Cons x xs) = Cons (f x) (fmap f xs)

instance Applicative List where
    pure x = Cons x Nil

    (<*>) _ Nil = Nil
    (<*>) Nil _ = Nil
    (<*>) (Cons f fs) xs = append (f <$> xs) (fs <*> xs)
        where 
            append Nil ys = ys
            append (Cons x xs) ys = Cons x (append xs ys)

f = Cons (+1) (Cons (*2) Nil)
v = Cons 1 (Cons 2 Nil)
test1 = (f <*> v) == Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil)))

data Cow = Cow {
        name :: String
        , age :: Int
        , weight :: Int
        } deriving (Eq, Show)

noEmpty :: String -> Maybe String
noEmpty s
    | length s == 0  = Nothing
    | otherwise      = Just s 

noEmpty' s = Just s

noNegative :: Int -> Maybe Int
noNegative x
    | x < 0     = Nothing
    | otherwise = Just x

test21 = noEmpty "abc" == Just "abc"
test22 = noNegative (-5) == Nothing 
test23 = noNegative 5 == Just 5 

cowFromString :: String -> Int -> Int -> Maybe Cow
cowFromString name age weight
    | noEmpty name == Nothing = Nothing
    | noNegative age == Nothing = Nothing
    | noNegative weight == Nothing = Nothing
    | otherwise = Just (Cow name age weight)

cowFromString' name age weight
    | noEmpty name /= Nothing && noNegative age /= Nothing && noNegative weight /= Nothing = Just (Cow name age weight)
    | otherwise = Nothing

cowFromString'' name age weight = 
    case noEmpty name of
        Nothing -> Nothing
        Just validName -> case noNegative age of
            Nothing -> Nothing
            Just validAge -> case noNegative weight of
                Nothing -> Nothing
                Just validWeight -> Just (Cow validName validAge validWeight)

-- Cow :: String -> (Int -> Int -> Maybe Cow)
--     Maybe String
-- fmap Cow :: Maybe String -> Maybe (Int -> Int -> Cow)
-- fmap Cow (noEmpty name) :: Maybe (Int -> Int -> Cow)
cowFromStringApplicative :: String -> Int -> Int -> Maybe Cow
cowFromStringApplicative name age weight = Cow <$> noEmpty name <*> noNegative age <*> noNegative weight

test24 = cowFromString "Milka" 5 100 == Just (Cow {name = "Milka", age = 5, weight = 100})

newtype Name = Name String deriving (Eq, Show)
newtype Address = Address String deriving (Eq, Show)

data Person = Person Name Address
    deriving (Eq, Show)

validateLength :: Int -> String -> Maybe String
validateLength n s
    | length s >= n = Nothing
    | otherwise = Just s 

test31 = validateLength 5 "abc" == Just "abc"
mkName :: String -> Maybe Name
mkName s
    | validateLength 25 s == Nothing = Nothing
    | otherwise = Just $ Name s

mkNameFunctor :: String -> Maybe Name
mkNameFunctor s = Name <$> validateLength 25 s

mkAddress :: String -> Maybe Address
mkAddress s
    | validateLength 100 s == Nothing = Nothing
    | otherwise = Just $ Address s

mkAddressFunctor :: String -> Maybe Address
mkAddressFunctor s = Address <$> validateLength 100 s 

mkAddressFunctor' :: String -> Maybe Address
mkAddressFunctor' s = pure Address <*> validateLength 100 s

-- fmap f e == pure f <*> e
-- f <$> e == pure f <*> e

test32 = mkName "Gigel" ==  Just (Name "Gigel")
test33 = mkAddress "Str Academiei" ==  Just (Address "Str Academiei")

mkPerson :: String -> String -> Maybe Person
mkPerson nameStr addrStr = pure Person <*> mkNameFunctor nameStr <*> mkAddressFunctor addrStr

mkPerson' nameStr addrStr = (Person <$> mkNameFunctor nameStr) <*> mkAddressFunctor addrStr

test34 = mkPerson "Gigel" "Str Academiei" == Just (Person (Name "Gigel") (Address "Str Academiei"))
