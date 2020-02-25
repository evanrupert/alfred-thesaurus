module Main where

import Lib
import Control.Applicative

data Word = Word { id :: Int
                 , word :: String
                 }


main :: IO ()
main = greet "Evan"


greet :: String -> IO ()
greet name = putStrLn ("Hello, " ++ name ++ "!")
