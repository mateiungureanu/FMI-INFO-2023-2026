import Control.Concurrent
import Control.Concurrent.STM

{-
    STM = software transactional memory

    lucram tranzactional
    def: tranzactie = un set de operatii pe care le executam ca un tot unitar si care respecta 4 principii:
        A = atomicitate
        C = consistenta
        I = izolare
        D = durabilitate
    
    pentru implementare:
    - prin variabile atomice (IORef a) - implementate folosing instr. hardware compare-and-swap
    - prin STM - sincronizare fara lock-uri, blocuri de instructiuni executate atomic

    vom lucra in monada STM - asemanatoare monadei IO
    - nu mai avem MVar ci TVar
    - in loc de takeMvar avem readTVar
    - in loc de putMVar avem writeTVar
    - atomically :: STM a -> IO a
    - retry :: STM a -- daca folosim retry, atunci tranzactia curenta e abandonata si va fi reincercata ulterior 
-}

type Account = TVar Int

deposit :: Account -> Int -> STM ()
deposit acc amount = do
    currentAmount <- readTVar acc
    writeTVar acc (currentAmount + amount)

withdraw :: Account -> Int -> STM ()
withdraw acc amount = do
    currentAmount <- readTVar acc
    writeTVar acc (currentAmount - amount)

showBalance :: Account -> String -> IO ()
showBalance acc accountName = do
    -- currentAmount <- takeMVar acc
    -- putMVar acc currentAmount
    currentAmount <- readTVarIO acc --atomically $ readTVar acc
    putStrLn $ "Account " ++ accountName ++ ": " ++ show currentAmount

transfer :: Account -> Account -> Int -> IO ()
transfer from to amount = atomically $ do
    withdraw from amount
    -- un moment de inconsistenta (in varainta fara STM)
    deposit to amount

main = do
    (a, b) <- atomically $ do
        a <- newTVar 1000
        b <- newTVar 1000
        return (a, b)
    forkIO $ transfer a b 300
    threadDelay 1000000
    showBalance a "a"
    showBalance b "b"