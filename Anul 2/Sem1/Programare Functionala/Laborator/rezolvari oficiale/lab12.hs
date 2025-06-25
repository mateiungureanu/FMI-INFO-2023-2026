{- 
class Functor f where 
     fmap :: (a -> b) -> f a -> f b 

fmap id = id
fmap (g . h) = fmap g . fmap h

class Functor f => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b

pure id <*> v = v               -- Identity
pure f <*> pure v = pure (f v)  -- Homomorphism
u <*> pure y = pure ($ y) <*> u -- Interchange
pure (.) <*> u <*> v <*> w = u <*> (v <*> w) -- Composition


Bonus:
    fmap f x = pure f <*> x                      -- fmap

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
    fmap f Nil = Nil
    fmap f (Cons h t) = Cons (f h) (fmap f t)
instance Applicative List where
    -- pure :: a -> List a
    pure x = Cons x Nil
    -- (<*>) :: List (a -> b) -> List a -> List b
    -- if defined as zipping, <*> breaks Identity: pure id <*> v = v 
    (<*>) Nil _ = Nil
    (<*>) (Cons f fs) xs = concat (f <$> xs) (fs <*> xs) where
        concat Nil ys = ys
        concat (Cons x xs) ys = Cons x (concat xs ys)

f = Cons (+1) (Cons (*2) Nil)
v = Cons 1 (Cons 2 Nil)
test1 = (f <*> v) == Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil)))

data Cow = Cow {
        name :: String
        , age :: Int
        , weight :: Int
        } deriving (Eq, Show)

noEmpty :: String -> Maybe String
noEmpty "" = Nothing
noEmpty str = Just str

noNegative :: Int -> Maybe Int
noNegative x
    | x < 0     =   Nothing
    | otherwise =   Just x

test21 = noEmpty "abc" == Just "abc"
test22 = noNegative (-5) == Nothing 
test23 = noNegative 5 == Just 5 

cowFromString' :: String -> Int -> Int -> Maybe Cow
cowFromString' name age weight
    | (noEmpty name) /= Nothing && (noNegative age) /= Nothing && (noNegative weight) /= Nothing = Just $ Cow name age weight
    | otherwise = Nothing

cowFromString :: String -> Int -> Int -> Maybe Cow
cowFromString name age weight = Cow <$> noEmpty name <*> noNegative age <*> noNegative weight

test24 = cowFromString "Milka" 5 100 == Just (Cow {name = "Milka", age = 5, weight = 100})

newtype Name = Name String deriving (Eq, Show)
newtype Address = Address String deriving (Eq, Show)

data Person = Person Name Address
    deriving (Eq, Show)

validateLength :: Int -> String -> Maybe String
validateLength x str
    | length str < x = Just str
    | otherwise = Nothing

test31 = validateLength 5 "abc" == Just "abc"
mkName :: String -> Maybe Name
mkName str = Name <$> validateLength 25 str

mkName' :: String -> Maybe Name
mkName' str =
    case validateLength 25 str of
        Nothing -> Nothing
        Just x -> Just $ Name x

mkAddress :: String -> Maybe Address
mkAddress adr = Address <$> validateLength 100 adr

mkAddress' :: String -> Maybe Address
mkAddress' str =
    case validateLength 100 str of
        Nothing -> Nothing
        Just x -> Just $ Address x

test32 = mkName "Gigel" ==  Just (Name "Gigel")
test33 = mkAddress "Str Academiei" ==  Just (Address "Str Academiei")

mkPerson :: String -> String -> Maybe Person
mkPerson str adr = Person <$> mkName str <*> mkAddress adr 

test34 = mkPerson "Gigel" "Str Academiei" == Just (Person (Name "Gigel") (Address "Str Academiei"))

mkPerson' :: String -> String -> Maybe Person
mkPerson' str1 str2 =
    case mkAddress' str1 of
        Nothing -> Nothing
        Just adr -> case mkName' str2 of
                        Nothing -> Nothing
                        Just name -> Just $ Person name adr
