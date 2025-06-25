{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
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

fctDo :: Maybe Int -> Maybe Bool
fctDo mx = do
    x <- mx
    return $ pos x

addM :: Maybe Int -> Maybe Int -> Maybe Int
addM mx my = mx >>= (\x -> (my >>= \y -> return $ x + y))

addMDo :: Maybe Int -> Maybe Int -> Maybe Int
addMDo mx my = do
    x <- mx
    y <- my
    return $ x + y

cartesian_product :: (Monad m) => m a -> m b -> m (a, b)
cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y-> return (x,y)))

cartesian_productDo :: (Monad m) => m a -> m b -> m (a, b)
cartesian_productDo xs ys = do
    x <- xs
    y <- ys
    return (x, y)

prod :: (a -> b -> c) -> [a] -> [b] -> [c]
prod f xs ys = [f x y | x <- xs, y<-ys]

prod' f xs ys = xs >>= (\x -> (ys >>= (\y -> [f x y])))

prodDo f xs ys = do
    x <- xs
    y <- ys
    [f x y]

myGetLine :: IO String
myGetLine = getChar >>= \x ->
      if x == '\n' then
          return []
      else
          myGetLine >>= \xs -> return (x:xs)

myGetLineDo :: IO String
myGetLineDo = do
    x <- getChar
    if x == '\n' then
        return []
    else do
        xs <- myGetLine
        return (x:xs)

prelNo noin =  sqrt noin

ioNumber = do
     noin  <- readLn :: IO Float
     putStrLn $ "Intrare\n" ++ (show noin)
     let  noout = prelNo noin
     putStrLn $ "Iesire"
     print noout

ioNumberSeq :: IO ()
ioNumberSeq =
    (readLn :: IO Float) >>= (\noin ->
    putStrLn ("Intrare\n" ++ (show noin)) >>
    let noout = prelNo noin in
        putStrLn "Iesire" >>
        print noout
    )

data Person = Person { name :: String, age :: Int }

showPersonN :: Person -> String
showPersonN p = "NAME: " ++ name p
showPersonA :: Person -> String
showPersonA p = "AGE: " ++ (show $ age p)

{-
showPersonN $ Person "ada" 20
"NAME: ada"
showPersonA $ Person "ada" 20
"AGE: 20"
-}

showPerson :: Person -> String
showPerson p = "(" ++ showPersonN p ++ ", " ++ showPersonA p ++ ")"

{-
showPerson $ Person "ada" 20
"(NAME: ada, AGE: 20)"
-}


newtype Reader env a = Reader { runReader :: env -> a }
-- runReader :: Reader env a -> env -> a
--    ma    ::   Reader env a    ----   computație în monada Reader,
--                                           care întoarce un termen de tip a în orice environment de tip env
--    glob  ::          env      ----   un environment (valoarea variabilei globale în contextul în care vom executa computația)
--  runReader ma glob :: a       ----   rezultatul computației în contextul ma

instance Monad (Reader env) where
  return x = Reader (\_ -> x)
  ma >>= k = Reader f
    where f env = let a = runReader ma env
                  in  runReader (k a) env



instance Applicative (Reader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor (Reader env) where              
  fmap f ma = pure f <*> ma    

ask :: Reader env env
ask = Reader id

mshowPersonN ::  Reader Person String
mshowPersonN = do
    person <- ask
    return $ "NAME:" ++ name person

mshowPersonA ::  Reader Person String
mshowPersonA = do
    person <- ask
    return $ "AGE:" ++ show (age person)
 
mshowPerson ::  Reader Person String
mshowPerson = do
    name <- mshowPersonN
    age <- mshowPersonA
    return $ "(" ++ name ++ "," ++ age ++ ")"
 
{-
runReader mshowPersonN  $ Person "ada" 20
"NAME:ada"
runReader mshowPersonA  $ Person "ada" 20
"AGE:20"
runReader mshowPerson  $ Person "ada" 20
"(NAME:ada,AGE:20)"
-}
