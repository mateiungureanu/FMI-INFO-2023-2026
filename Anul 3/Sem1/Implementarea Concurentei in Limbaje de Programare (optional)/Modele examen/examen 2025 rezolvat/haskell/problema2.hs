import Control.Concurrent 
import Control.Monad 
import Control.Concurrent.STM
import Data.Char 
import Text.Printf

-- Data type for our "List of Bounded Channels"
-- It holds a list of TBQueues (Transactional Bounded Queues)
data ChannelList a = ChannelList [TBQueue a] Int

-- Create the list of channels
-- numChans: number of channels to create
-- limit: N (capacity)
newChannelList :: Int -> Int -> IO (ChannelList a)
newChannelList numChans limit = do
    queues <- atomically $ replicateM numChans (newTBQueue (fromIntegral limit))
    
    return $ ChannelList queues limit

-- Write operation
-- Index: channel index (0-based)
-- Item: item to write
writeToChannel :: ChannelList a -> Int -> a -> IO ()
writeToChannel (ChannelList queues n) idx item = do
    if idx < 0 || idx >= length queues
        then putStrLn $ "Error: Channel index " ++ show idx ++ " does not exist."
        else do
             let queue = queues !! idx
             atomically $ writeTBQueue queue item
             -- writeTBQueue blocks if full, satisfying "apelul va fi blocant"

-- Read operation
-- Index: from which channel to read
readFromChannel :: ChannelList a -> Int -> IO () 
readFromChannel (ChannelList queues n) idx = do
    if idx < 0 || idx >= length queues
        then putStrLn $ "Error: Channel index " ++ show idx ++ " does not exist."
        else do
            let queue = queues !! idx
            -- Try to read. If empty, non-blocking -> print message.
            -- blocking read is readTBQueue. non-blocking check is tryReadTBQueue.
            res <- atomically $ tryReadTBQueue queue
            case res of
                Nothing -> putStrLn "Channel is empty"
                Just val -> print "Read item (consumed)"

-- Simulation Helper
simulate :: IO ()
simulate = do
    let n = 3 -- Capacity
    let m = 3 -- Number of channels
    putStrLn $ "Creating " ++ show m ++ " channels with capacity " ++ show n
    
    -- Start with String channels
    -- Problem says "generic" effectively ("obiecte").
    channels <- newChannelList m n :: IO (ChannelList String)

    -- Test 1: Write to valid index
    putStrLn "Writing 'A' to channel 0"
    writeToChannel channels 0 "A"
    
    -- Test 2: Read from valid index
    putStrLn "Reading from channel 0"
    readFromChannel channels 0
    
    -- Test 3: Read from empty channel
    putStrLn "Reading from empty channel 0"
    readFromChannel channels 0
    
    -- Test 4: Write until full (Blocking check requires thread)
    putStrLn "Filling channel 1..."
    writeToChannel channels 1 "1"
    writeToChannel channels 1 "2"
    writeToChannel channels 1 "3"
    putStrLn "Channel 1 full. Next write should block (will run in fork)."
    
    forkIO $ do
        putStrLn "Thread: Attempting write to full channel 1..."
        writeToChannel channels 1 "4"
        putStrLn "Thread: Write successful (means space freed)!"

    threadDelay 2000000 -- 2s
    putStrLn "Main: Reading from channel 1 to free space"
    readFromChannel channels 1
    
    -- Test 5: Invalid index
    putStrLn "Accessing invalid index 10"
    readFromChannel channels 10
    
    threadDelay 1000000
    
main = simulate