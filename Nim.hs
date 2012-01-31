module Nim where
    import System.IO
    
    main = play [1,2,3,4,5] ["Player 1","Player 2"]
    
    play :: [Int] -> [String] -> IO ()
    play board players = do
        (newBoard,winner) <- takeTurns board players
        if null winner
        then play newBoard players
        else do putStrLn (winner ++ " won!")
                return ()
    
    takeTurns :: [Int] -> [String] -> IO ([Int],String)
    takeTurns board [] = return (board,[])
    takeTurns board (player:players) = do
        newBoard <- takeTurn board player
        if sum newBoard == 0
        then return (newBoard,player)
        else takeTurns newBoard players
    
    takeTurn :: [Int] -> String -> IO [Int]
    takeTurn board player = do
        putStrLn ("\n" ++ player ++ "'s Turn")
        displayBoard board
        row   <- getRow board
        count <- getInt "How many stars? " 1 (board!!row)
        return $ take row board ++ [board!!row - count] ++ drop (row+1) board
    
    displayBoard :: [Int] -> IO ()
    displayBoard [] = return ()
    displayBoard board = do
        putStrLn $ show (length board) ++ " : " ++ take (last board) (repeat '*')
        displayBoard (init board)
    
    getRow :: [Int] -> IO Int
    getRow board = do
        row <- getInt "Which row? " 1 (length board)
        if board!!(row-1) == 0
        then do putStrLn "That row is empty!"
                getRow board
        else return (row-1)
    
    getInt msg min max = do
        putStr msg
        input <- getLine
        let parsed = reads input :: [(Int,String)]
        if null parsed
        then badNumber "That's not a number!"
        else testNumber (fst (head parsed))
        where
            badNumber error = do putStrLn error
                                 getInt msg min max
            testNumber number
                | number < min = badNumber "That number is too small."
                | number > max = badNumber "That number is too big."
                | otherwise    = do return number
