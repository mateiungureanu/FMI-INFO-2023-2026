{-
    Problema producer consumer
    MVar ca monitor
    producerul va citi incontinuu mesaje de la stdin si le va pune intr-o locatie partajata de memorie
    un numar finit de consumeri vor afisa mesajele respective la stdout
-}

import Control.Concurrent
import Control.Monad

producer :: MVar String -> IO () 
producer m = forever $ do 
    msg <- getLine 
    putMVar m msg 

consumer :: MVar String -> Int -> IO () 
consumer m n = if n == 0 
    then return () 
    else do 
        msg <- takeMVar m 
        putStrLn $ "Msg: " ++ msg 
        consumer m (n - 1)

main = do 
    m <- newEmptyMVar 
    forkIO $ producer m 
    consumer m 5