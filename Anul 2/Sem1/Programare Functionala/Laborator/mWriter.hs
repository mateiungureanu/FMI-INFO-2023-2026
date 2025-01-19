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
  if (n > 0) do
    logIncrementN new_x (n-1)
  else
    return new_x
