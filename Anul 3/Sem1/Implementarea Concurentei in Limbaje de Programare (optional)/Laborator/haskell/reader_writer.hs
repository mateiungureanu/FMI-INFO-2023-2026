import Control.Concurrent 
import Control.Monad 
 
{-
    Reader-Writer 
    - mai multe threaduri au acces la o resursa 
    - unele threaduri scriu (Writer), altele citesc (Reader)
    - resursa poate fi accesata simultan de mai multi cititori 
    - resursa poate fi accesata doar de un singur scriitor 
    - nu poate fi accesata simultan si de cititori, si de scriitori 
 
    Folosim 
    - un semafor binar care da acces la citit sau la scris, writeL 
    - un monitor pentru sincronizarea cititorilor, readL 
-}
 
type MyLock = MVar () 
newLock = newMVar () 
acquireLock = takeMVar
releaseLock m = putMVar m () 
 
data MyRWLock = MyRWL { readL :: MVar Int, writeL :: MyLock }
 
newMyRWLock :: IO MyRWLock
newMyRWLock = do 
    readL <- newMVar 0 
    writeL <- newLock
    return $ MyRWL readL writeL 
 
-- acquireWrite, releaseWrite 
-- acquireReader, releaseReader 
 
acquireWrite :: MyRWLock -> IO () 
acquireWrite (MyRWL readL writeL) = acquireLock writeL 
 
releaseWrite :: MyRWLock -> IO ()
releaseWrite (MyRWL readL writeL) = releaseLock writeL 
 
acquireRead :: MyRWLock -> IO () 
acquireRead (MyRWL readL writeL) = do 
    n <- takeMVar readL 
    if n == 0 then do 
        acquireLock writeL 
        putMVar readL 1 
    else 
        putMVar readL (n + 1)
 
releaseRead :: MyRWLock -> IO () 
releaseRead (MyRWL readL writeL) = do 
    n <- takeMVar readL 
    if n == 1 then do 
        releaseLock writeL 
        putMVar readL 0 
    else 
        putMVar readL (n - 1)
 
-- finalizati problema scriind rolurile pt reader, writer, si un scenariu cu mai multi din fiecare rol 
 
takeprint :: MVar String -> IO ()
takeprint stdo = do 
    s <- takeMVar stdo 
    print s 
 
reader :: (Show a1, Show a2) => MVar String -> MyRWLock -> MVar a2 -> a1 -> IO ()
reader stdo rwl buf i = do 
    acquireRead rwl 
    threadDelay 1000000 
    c <- readMVar buf 
    putMVar stdo $ "Readerul " ++ show i ++ " citeste: " ++ show c
    releaseRead rwl 
 
writer :: Show a => MVar String -> MyRWLock -> MVar a -> a -> IO ()
writer stdo rwl buf i = do 
    acquireWrite rwl 
    threadDelay 2000000
    putMVar stdo $ "Writerul " ++ show i ++ " scrie " ++ show i 
    c <- takeMVar buf 
    putMVar buf i 
    releaseWrite rwl 
    threadDelay 2000000
 
main = do 
    buf <- newMVar 0 
    rwl <- newMyRWLock 
    stdo <- newEmptyMVar 
 
    forkIO $ writer stdo rwl buf 1 
    forkIO $ reader stdo rwl buf 1 
    forkIO $ reader stdo rwl buf 2
    forkIO $ writer stdo rwl buf 2
    forkIO $ reader stdo rwl buf 3
    forkIO $ reader stdo rwl buf 4
 
    forkIO $ forever $ takeprint stdo 
 
    getLine 
