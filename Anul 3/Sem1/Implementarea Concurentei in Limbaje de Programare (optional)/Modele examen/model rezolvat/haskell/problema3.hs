import Control.Concurrent
import System.IO
import Control.Monad (when)

{-
   Model Problem 3 (Haskell) - Testare 2022
   Channel: MList via MVar [Int]
   Writer: Prepend (Left) from stdin
   Reader: Take Last (Right), print double, remove. Terminate on 0.
-}

data MList = ML (MVar [Int])

newMList :: IO MList
newMList = do
    m <- newMVar []
    return (ML m)

-- Writer Thread
writerThread :: MList -> IO ()
writerThread (ML mvar) = do
    putStrLn "Writer: Enter integer:"
    input <- getLine
    let val = read input :: Int
    
    -- "Scrie incepand din stanga" -> Prepend
    list <- takeMVar mvar
    putMVar mvar (val : list)
    
    if val == 0 
        then return () -- Writer job done (but Reader handles term)
        else writerThread (ML mvar)

-- Reader Thread
readerThread :: MList -> MVar () -> IO ()
readerThread (ML mvar) doneMVar = do
    list <- takeMVar mvar
    
    if null list
        then do
             putMVar mvar list -- Put back empty
             threadDelay 100000 -- Wait a bit
             readerThread (ML mvar) doneMVar
        else do
             -- "Citi din dreapta" -> Last element
             let val = last list
             let newList = init list
             
             -- Remove processed info
             putMVar mvar newList
             
             if val == 0
                 then do
                     putStrLn "Reader: Received 0. Terminating."
                     putMVar doneMVar () -- Signal main to exit
                 else do
                     putStrLn $ "Reader: Processed " ++ show (val * 2)
                     readerThread (ML mvar) doneMVar

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    
    mlist <- newMList
    doneMVar <- newEmptyMVar
    
    forkIO $ readerThread mlist doneMVar
    forkIO $ writerThread mlist
    
    -- Main thread waits for Reader to signal completion
    takeMVar doneMVar
    putStrLn "Simulation finished."
