{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Applicative
import           Data.List
import qualified Data.Text              as T
import qualified Data.Text.IO           as TIO
import           Database
import           Database.SQLite.Simple
import           NeatInterpolation      (text)
import           Serialization
import           System.Environment
import           Types

main :: IO ()
main = do
  args <- getArgs
  conn <- open "/Users/evan/Programs/thesaurus/thesaurus.db"
  synonyms <- querySynonyms conn (head args)
  TIO.putStrLn . serializeResult $ synonyms
  close conn
