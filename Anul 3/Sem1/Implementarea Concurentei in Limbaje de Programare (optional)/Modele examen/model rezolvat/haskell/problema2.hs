import Control.Concurrent
import Control.Monad
import Control.Concurrent.STM

delay :: IO ()
delay = threadDelay 2000000

writeStdOut stdw str = do
    takeMVar stdw
    putStrLn str
    putMVar stdw ()

data Gate = MkGate Int (TVar Int)

newGate :: Int -> STM Gate
newGate n = do
    tv <- newTVar 0 -- Zero for strict control (Santa opens it)
    return (MkGate n tv)

passGate :: Gate -> IO ()
passGate (MkGate n tv) = atomically $ do
    n_left <- readTVar tv
    if n_left == 0 then retry
    else writeTVar tv (n_left - 1)

operateGate :: Gate -> IO ()
operateGate (MkGate n tv) = do
    atomically $ writeTVar tv n
    atomically $ do
        n_left <- readTVar tv
        when (n_left > 0) retry


data Group = MkGroup Int (TVar (Int, Gate, Gate)) 

newGroup :: Int -> IO Group
newGroup n = atomically $ do
    g1 <- newGate n
    g2 <- newGate n
    tv <- newTVar (n, g1, g2)
    return (MkGroup n tv)

joinGroup :: Group -> IO (Gate, Gate)
joinGroup (MkGroup n tv) = atomically $  do
    (n_left, g1, g2) <- readTVar tv
    if n_left == 0 then retry
    else do
        writeTVar tv (n_left -1, g1, g2)
        return (g1, g2)

awaitGroup :: Group -> STM (Gate, Gate)
awaitGroup (MkGroup n tv) = do
    (n_left, g1, g2) <- readTVar tv 
    if n_left > 0 then retry
    else do
        new_g1 <- newGate n
        new_g2 <- newGate n 
        writeTVar tv (n, new_g1, new_g2)
        return (g1, g2)

helper :: Group -> IO () -> IO ()
helper group do_task = do
    (in_gate, out_gate) <- joinGroup group 
    passGate in_gate
    do_task
    passGate out_gate

-- Actions
meetInStudy :: Int -> MVar () -> IO ()
meetInStudy id stdw = writeStdOut stdw $ "Car (Elf) " ++ show id ++ " passing on Green\n"

deliverToys :: Int -> MVar () -> IO ()
deliverToys id stdw = writeStdOut stdw $ "Pedestrian (Reindeer) " ++ show id ++ " crossing street\n"

animalCrossing :: Int -> MVar () -> IO ()
animalCrossing id stdw = writeStdOut stdw $ "Animal " ++ show id ++ " crossing street\n"

elfHelper :: Group -> Int -> MVar () -> IO ()
elfHelper group id stdw = helper group (meetInStudy id stdw)

reindeerHelper :: Group -> Int -> MVar () -> IO ()
reindeerHelper group id stdw = helper group (deliverToys id stdw)

animalHelper :: Group -> Int -> MVar () -> IO ()
animalHelper group id stdw = helper group (animalCrossing id stdw)

elf :: Group -> Int -> MVar () -> IO ThreadId
elf group id stdw = (forkIO . forever) $ do
    elfHelper group id stdw 
    delay

reindeer :: Group -> Int -> MVar () -> IO ThreadId
reindeer group id stdw = (forkIO . forever) $ do
    reindeerHelper group id stdw 
    delay

animal :: Group -> Int -> MVar () -> IO ThreadId -- New Animal Thread
animal group id stdw = (forkIO . forever) $ do
    animalHelper group id stdw 
    delay

chooseGroup :: Group -> String -> STM (String, (Gate, Gate))
chooseGroup group task = do
    gates <- awaitGroup group
    return (task, gates)

santa :: MVar () -> Group -> Group -> Group -> IO () -- Adjusted signature
santa stdw elf_group reindeer_group animal_group = do
    (task, (in_gate, out_gate)) <- atomically $ orElse
        (chooseGroup animal_group "STOP CARS! Animal Crossing")
        (orElse
            (chooseGroup reindeer_group "STOP CARS! Pedestrians Crossing")
            (chooseGroup elf_group "GREEN LIGHT! Cars Passing")
        )
    writeStdOut stdw $ "Traffic Light (Santa): " ++ task ++ "\n"
    operateGate in_gate
    operateGate out_gate


main = do
    stdw <- newMVar ()
    
    -- Elves (Cars): Group of 10
    elf_group <- newGroup 10
    -- 50 Cars
    sequence_ [elf elf_group n stdw | n <- [1..50]]

    -- Reindeer (Pedestrians): Group of 5
    reindeer_group <- newGroup 5
    -- 20 Pedestrians
    sequence_ [reindeer reindeer_group n stdw | n <- [1..20]]

    -- Animals (New): Group of 1
    animal_group <- newGroup 1
    -- 3 Animals
    sequence_ [animal animal_group n stdw | n <- [1..3]]

    forever $ santa stdw elf_group reindeer_group animal_group
