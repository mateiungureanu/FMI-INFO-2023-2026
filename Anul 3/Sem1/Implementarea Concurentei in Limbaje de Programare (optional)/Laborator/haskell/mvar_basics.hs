import Control.Concurrent
import Control.Monad

takePrint :: MVar () -> String -> IO ()
takePrint m str = do
    takeMVar m -- acquire
    putStrLn str
    putMVar m () -- release

hello :: MVar () -> MVar () -> IO ()
hello m finish = do
    takePrint m " Hello"
    putMVar finish () -- release

main = do
    m <- newMVar ()
    finish <- newEmptyMVar
    forkIO $ hello m finish

    takeMVar finish -- acquire