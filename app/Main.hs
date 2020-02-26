{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import           Control.Applicative
import           Database
import           Database.SQLite.Simple
import           NeatInterpolation (text)
import           System.Environment
import           Types
import qualified Data.Text as T
import Data.List
import qualified Data.Text.IO as TIO

-- TODO: Transition all Strings to Text
-- TODO: Support multi word queries
-- TODO: Remove hard coded references to home directory
main :: IO ()
main = do
  args <- getArgs
  conn <- open "/Users/evan/Programs/thesaurus/thesaurus.db"
  synonyms <- querySynonyms conn (head args)
  TIO.putStrLn . serializeResult $ synonyms
  close conn

serializeResult :: [Synonym] -> T.Text
serializeResult synonyms = [text|
{
  "items": [
    $serializedSynonyms
  ]
}|]
  where serializedSynonyms = T.intercalate "," . map serializeSynonym $ synonyms


serializeSynonym :: Synonym -> T.Text
serializeSynonym (Synonym _ synonym) = [text|
{
  "uid": "$word",
  "title":"$word",
  "autocomplete": "$word",
  "subtitle": "Synonym of $word",
  "icon": {
    "path": "/Users/evan/Programs/thesaurus/flat-book-icon.png"
  }
}|]
  where
    word = T.pack synonym
