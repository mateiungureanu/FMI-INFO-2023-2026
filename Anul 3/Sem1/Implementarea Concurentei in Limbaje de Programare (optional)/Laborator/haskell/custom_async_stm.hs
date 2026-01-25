import Control.Concurrent
import Control.Monad
import Control.Concurrent.STM

data TMVar' a = TMVar (TVar (Maybe a))

-- Nothing care specifica faptul ca variabila e empty
-- pentru a avea apelul blocant folosim retry

newEmptyTMVar' :: STM (TMVar' a)
newEmptyTMVar' = do
    t <- newTVar Nothing
    return (TMVar t) -- return duce in STM

takeTMVar' :: TMVar' a -> STM a
takeTMVar' (TMVar t) = do
    m <- readTVar t 
    case m of 
        Nothing -> retry
        Just a -> do
            writeTVar t Nothing
            return a

putTMVar' :: TMVar' a -> a -> STM ()
putTMVar' (TMVar t) x = do
    m <- readTVar t 
    case m of
        Just _ -> retry
        Nothing -> do
            writeTVar t (Just x)
            return ()


-- async cu tmvar
data Async a = Async (TMVar' a)

async :: IO a -> IO (Async a)
async action = do
    var <- atomically $ do
        var <- newEmptyTMVar'
        return var
    forkIO $ do
        r <- action
        (atomically . putTMVar' var) r
    return (Async var)

await :: Async a -> STM a
await (Async var) = takeTMVar' var

fibo :: Int -> Int 
fibo 0 = 1 
fibo 1 = 1 
fibo n = fibo (n - 1) + fibo (n - 2)

-- faceti main singuri
main = do
    a1 <- async $ return $ fibo 35
    a2 <- async $ return $ fibo 36 

    (r1, r2) <- atomically $ do
        x <- await a1
        y <- await a2
        return (x, y)

    print (r1, r2)