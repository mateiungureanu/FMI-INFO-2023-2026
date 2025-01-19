
{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  va :: a
  Just va :: Maybe a
  k :: a -> Maybe b
  (va >>= k) :: Maybe b

  return = Just
  Just va >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor Maybe where              
  fmap f ma = pure f <*> ma   
-}

pos :: Int -> Bool
pos  x = if (x>=0) then True else False

fct :: Maybe Int ->  Maybe Bool
fct  mx =  mx  >>= (\x -> Just (pos x))

fctDo :: Maybe Int ->  Maybe Bool
fctDo mx = do
    x <- mx
    return (pos x)

addM :: Maybe Int -> Maybe Int -> Maybe Int
-- addM Nothing my = Nothing
-- addM mx Nothing = Nothing
-- addM (Just x) (Just y) = Just (x+y)
addM mx my = mx >>= (\x -> (my >>= (\y -> Just (x+y)))) 

addMDo :: Maybe Int -> Maybe Int -> Maybe Int
addMDo mx my = do
  x <- mx
  y <- my
  Just (x+y)

cartesian_product :: Monad m => m a -> m b -> m (a, b)
cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y-> return (x,y)))

cartesian_productDo xs ys = do
  x <- xs
  y <- ys
  return (x,y)

prod :: (a -> b -> c) -> [a] -> [b] -> [c]
prod f xs ys = [f x y | x <- xs, y<-ys]

prod2 f xs ys = xs >>= (\x -> (ys >>= (\y -> return (f x y))))
                    -- x :: a
                          -- (ys >>= (\y -> return (f x y))) :: [c]
                                -- a :: [c]
prod3 f xs ys = do
  x <- xs
  y <- ys
  return (f x y)


myGetLine :: IO String
-- getChar :: IO Char
--               x :: Char
-- tipul de la dreapta lui >>= Char -> IO String
myGetLine = getChar >>= \x ->
      if x == '\n' then
          return []
      else
          myGetLine >>= \xs -> return (x:xs)

myGetLineDo = do
  x <- getChar
  if x == '\n' then
      return []
  else
      do
        xs <- myGetLineDo
        return (x:xs)

prelNo noin =  sqrt noin

-- () :: Unit
-- () :: ()
-- actions
ioNumber = do
    noin  <- readLn :: IO Float
    putStrLn $ "Intrare\n" ++ (show noin)
    let  noout = prelNo noin
    putStrLn $ "Iesire"
    print noout

-- la dreapta primului >>= termenul o sa aiba tipul
--                                float -> IO ()
ioNumberBind = (readLn :: IO Float) >>= (\noin -> putStrLn ("Intrare\n" ++ (show noin)) >> let noout = prelNo noin in putStrLn "Iesire" >> print noout)

-- >>= :: m a -> (a -> m b) -> m b
-- >> :: m a -> m b -> m b
-- >>= :: IO () -> (() -> IO b) -> IO b

-- >> e echivalent cu >>= \_ ->
-- (ma >>= \_ -> mb) e echivalent cu (ma >> mb)

--- Monada Writer

newtype WriterS a = Writer { runWriter :: (a, String) } 
--              Writer :: (a, String) -> WriterS a
--              runWriter :: WriterS a -> (a, String)

instance Monad WriterS where
  return va = Writer (va, "")
        -- k :: a -> WriterS b
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)


instance Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor WriterS where              
  fmap f ma = pure f <*> ma     

tell :: String -> WriterS () 
tell log = Writer ((), log)

logIncrement :: Int  -> WriterS Int
logIncrement x = do
  tell ("Am incrementat pe " ++ show x ++ " la " ++ show (x+1) ++ "\n")
  return (x + 1)

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x n = do
  new_x <- logIncrement x
  if (n > 0) then
    logIncrementN new_x (n-1)
  else
    return new_x

--- Monada Reader

data Person = Person { name :: String, age :: Int }

showPersonN :: Person -> String
showPersonN p = "NAME: " ++ name p
showPersonA :: Person -> String
showPersonA p = "AGE: " ++ show (age p)

{-
showPersonN $ Person "ada" 20
"NAME: ada"
showPersonA $ Person "ada" 20
"AGE: 20"
-}

showPerson :: Person -> String
showPerson p = "(" ++ showPersonN p ++ "," ++ showPersonA p ++ ")"

{-
showPerson $ Person "ada" 20
"(NAME: ada, AGE: 20)"
-}


newtype Reader env a = Reader { runReader :: env -> a }


instance Monad (Reader env) where
  return x = Reader (\_ -> x)
  ma >>= k = Reader f
    where f env = let a = runReader ma env
                  in  runReader (k a) env

ask :: Reader env env
ask = Reader id

instance Applicative (Reader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor (Reader env) where              
  fmap f ma = pure f <*> ma    

mshowPersonN ::  Reader Person String
mshowPersonN = do
  p <- ask
  return $ showPersonN p
mshowPersonA ::  Reader Person String
mshowPersonA = do
  p <- ask
  return $ showPersonA p
mshowPerson ::  Reader Person String
mshowPerson = do
  name <- mshowPersonN
  age <- mshowPersonA
  return $ "(" ++ name ++ ", " ++ age ++ ")"
{-
runReader mshowPersonN  $ Person "ada" 20
"NAME:ada"
runReader mshowPersonA  $ Person "ada" 20
"AGE:20"
runReader mshowPerson  $ Person "ada" 20
"(NAME:ada,AGE:20)"
-}