import Control.Concurrent 

{-
    Comunicarea asincrona 
    - se creeaza un thread pentru fiecare actiune si apoi se asteapta rezultatul actiunii respective 
-}

data Async a = Async (MVar a) 

async :: IO a -> IO (Async a)
async action = do 
    var <- newEmptyMVar 
    forkIO $ do 
        r <- action 
        putMVar var r 
    return (Async var) 

await :: Async a -> IO a
await (Async var) = readMVar var 

fibo :: Int -> Int 
fibo 0 = 1 
fibo 1 = 1 
fibo n = fibo (n - 1) + fibo (n - 2)

main = do 
    a1 <- async $ return $ fibo 35
    a2 <- async $ return $ fibo 36 

    r1 <- await a1 
    r2 <- await a2 

    print (r1, r2)