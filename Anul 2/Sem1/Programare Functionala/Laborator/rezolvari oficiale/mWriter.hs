--- Monada Writer

newtype WriterS a = Writer { runWriter :: (a, String) } 
-- runWriter  ::  WriterS a  ->  (a, String)
--   ma       ::  WriterS a       --------    computație în monada WriterS,
--                                                 care întoarce un termen de tip a, și manipulează un environment de tip String
-- runWriter ma  :: (a, String) -> rezultatul computației ma, care include valoarea calculată, și environmentul produs

instance  Monad WriterS where
  return va = Writer (va, "")
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)

instance  Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance  Functor WriterS where              
  fmap f ma = pure f <*> ma     

tell :: String -> WriterS () 
tell log = Writer ((), log)
  
logIncrement :: Int  -> WriterS Int
logIncrement x = do
    tell $ "incremented " ++ show x ++ " to " ++ show (x+1) ++ "\n"
    return (x + 1)

logIncrement2 :: Int -> WriterS Int
logIncrement2 x = do
    new_x <- logIncrement x
    logIncrement new_x

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x n = do
    new_x <- logIncrement x
    if (n > 0) then
        logIncrementN new_x (n-1)
    else
        return new_x

newtype WriterLS a = WriterLS { runWriterLS :: (a, [String]) }

instance Monad WriterLS where
    return val = WriterLS (val, [])
    ma >>= k = let (va1, log1) = runWriterLS ma
                   (va2, log2) = runWriterLS (k va1) in
                WriterLS (va2, log1 ++ log2)

instance Applicative WriterLS where
    pure = return
    writerf <*> writerx = do
        f <- writerf
        x <- writerx
        return $ f x

instance Functor WriterLS where
    fmap f x = pure f <*> x

tellLS :: String -> WriterLS ()
tellLS msg = WriterLS ((), [msg])

logIncrementLS :: Int -> WriterLS Int
logIncrementLS x = do
    tellLS $ "incrementing " ++ show x ++ " to " ++ show (x + 1)
    return $ x + 1

logIncrementLSN :: Int -> Int -> WriterLS Int
logIncrementLSN x n = do
    new_x <- logIncrementLS x
    if (n > 0) then
        logIncrementLSN new_x (n-1)
    else
        return new_x
