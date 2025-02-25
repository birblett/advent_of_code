import System.IO
import Data.Array
import Data.List
import Control.Monad
import qualified Data.Text as T

bchar :: (Array Int (Array Int Char)) -> Integer -> Integer -> Char
bchar board x y = (board ! (fromIntegral x)) ! (fromIntegral y)

p1 :: (Array Int (Array Int Char)) -> (Integer)
p1 (board) = (b) where
    (max_x, max_y) = ((fromIntegral $ length board) - 1, (fromIntegral . length $ board ! 0) - 1)
    points = [(x,y) | x <- [0..max_x], y <- [0..max_y]]
    point_sum :: (Integer, Integer) -> (Integer)
    point_sum(x, y) = (s) where
        s = if (bchar board x y) == 'X'
            then do
                let x_dim = [if x - 3 >= 0 then -1 else 0, if x + 3 <= max_x then 1 else 0]
                let y_dim = [if y - 3 >= 0 then -1 else 0, if y + 3 <= max_y then 1 else 0]
                let dirs = [(dx, dy)| dx <- [(x_dim !! 0)..(x_dim !! 1)], dy <- [(y_dim !! 0)..(y_dim !! 1)]]
                let xmas = [[bchar board (x + dx * dt) (y + dy * dt) | dt <- [0..3]] | (dx, dy) <- dirs]
                sum (map (\str -> if str == "XMAS" then 1 else 0) xmas)
            else 0
    b = sum $ map point_sum points

p2 :: (Array Int (Array Int Char)) -> (Integer)
p2 (board) = (b) where
    points = [(x,y) | x <- [1..((fromIntegral $ length board) - 2)], y <- [1..((fromIntegral . length $ board ! 0) - 2)]]
    point_val :: (Integer, Integer) -> (Integer)
    point_val(x, y) = (s) where
        s = if (if (bchar board x y) == 'A'
            then elemIndex [bchar board (x + dx) (y + dy) | dx <- [-1, 1], dy <- [-1, 1]] ["MSMS", "SMSM", "SSMM", "MMSS"]
            else Nothing) == Nothing then 0 else 1
    b = sum $ map point_val points

main = do
    file <- readFile "in.txt"
    let input = T.splitOn (T.pack "\r\n") (T.pack file)
    let board = listArray (0, length input - 1) [listArray (0, T.length (input !! 0) - 1) $ concat [[c] | c <- (T.unpack s)] | s <- input]
    print $ p1 board
    print $ p2 board