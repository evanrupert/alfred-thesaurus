module Main where

import           Control.Applicative
import           Database
import           Database.SQLite.Simple
import           System.Environment
import           Types

main :: IO ()
main = do
  args <- getArgs
  conn <- open "thesaurus.db"
  synonyms <- querySynonyms conn (head args)
  mapM_ (putStrLn . synonym) synonyms
  close conn
