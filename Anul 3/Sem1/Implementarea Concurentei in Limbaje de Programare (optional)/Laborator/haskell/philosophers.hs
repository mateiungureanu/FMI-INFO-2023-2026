import Control.Concurrent 
import Control.Concurrent.STM 
import Control.Monad 
 
{-
    Problema filosofilor 
 
    Fiecare filosof executa la infinit urmatorul ciclu: 
    - asteapta sa manance 
    - ia furculita din stanga 
    - o ia si pe cea din dreapta 
    - mananca 
    - elibereaza furculita din stanga 
    - o elibereaza si pe ce din dreapta 
    - filosofeaza 
 
    Probleme:
    - excludere mutuala: doi filosofi diferiti nu pot folosi aceeasi furculita simultan
    - coada circulara: filosofii se asteapta unul pe celalalt 
 
    Deadlock: fiecare filosof are o furculita si asteapta ca ceilalti vecini sa mai elibereze una 
    Starvation: un filosof nu mananca niciodata 
 
    Solutie: 
    - daca luarea/eliberarea furculitelor sunt operatii atomice, atunci eliminam deadlock-ul 
    - daca actiunea de a manca are si durata finita, eliminam starvation-ul 
-}
 
type Fork = TVar Bool -- True daca furculita este libera 
type Name = String -- pentru numele filosofului 
 
takeFork :: Fork -> STM () 
takeFork fork = do 
    b <- readTVar fork  
    if b then writeTVar fork False else retry 
 
releaseFork :: Fork -> STM ()
releaseFork fork = writeTVar fork True  
 
runPhilosopher :: (Name, (Fork, Fork)) -> IO () 
runPhilosopher (name, (left, right)) = forever $ do 
    putStrLn $ name ++ " e flamand"
    atomically $ do 
        takeFork left 
        takeFork right 
    putStrLn $ name ++ " poate manca"
    threadDelay 2000000 
    putStrLn $ name ++ " a terminat de mancat si acum poate filosofa linistit"
    atomically $ do 
        releaseFork left 
        releaseFork right 
    threadDelay 3000000 
 
philosophers :: [Name]
philosophers = ["Kant", "Chomsky", "Descartes", "Socrate", "Kripke"]
 
main = do 
    forks <- atomically $ do 
        mapM (const $ newTVar True) [1..length philosophers]
    let forkPairs = zip forks (tail forks ++ [head forks])
    let philosophersWithForks = zip philosophers forkPairs 
 
    mapM_ (forkIO . runPhilosopher) philosophersWithForks
 
    getLine 