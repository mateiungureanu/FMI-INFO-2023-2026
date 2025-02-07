data Point = Pt [Int] deriving Show

data Arb = Empty | Node Int Arb Arb deriving Show

class ToFromArb a where
    toArb :: a -> Arb
    fromArb :: Arb -> a 

instance ToFromArb Point where
    toArb (Pt xs) = foldr insert Empty xs
      where
        insert x Empty = Node x Empty Empty
        insert x (Node y left right)
          | x < y     = Node y (insert x left) right
          | otherwise = Node y left (insert x right)

    fromArb Empty = Pt []
    fromArb (Node val left right) =
        let Pt l = fromArb left
            Pt r = fromArb right
        in Pt (l ++ [val] ++ r)

getFromInterval :: Int -> Int -> [Int] -> [Int]
getFromInterval a b xs = filter (\x -> a <= x && x <= b) xs

getFromIntervalM :: Int -> Int -> [Int] -> [Int]
getFromIntervalM a b xs = do
    x <- xs
    if a <= x && x <= b then return x else []


newtype ReaderWriter env a = RW { getRW :: env -> (a, String) }

instance Monad (ReaderWriter env) where
    return x = RW (\_ -> (x, ""))
    
    (RW rw) >>= f = RW $ \env ->
        let (x, log1) = rw env
            (RW rw') = f x
            (y, log2) = rw' env
        in (y, log1 ++ log2)


newtype ReaderM env a =  ReaderM { runReaderM :: env -> Either String a}

instance Functor (ReaderM env) where
    fmap f ma = f <$> ma

instance Applicative (ReaderM env) where
    pure=return
    mf <*> ma = do
            f<- mf
            f<$> ma

instance Monad (ReaderM env) where
    return x = ReaderM (\env -> (Right x) )
    
    ma >>= k = ReaderM f
        where 
            f env = case runReaderM ma env  of
                    Left str -> Left str
                    Right x -> runReaderM (k x) env