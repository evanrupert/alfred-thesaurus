{-# LANGUAGE OverloadedStrings #-}

module Database
  ( saveWordData
  , clearDatabase
  , querySynonyms
  ) where

import           Database.SQLite.Simple
import           Types

querySynonyms :: Connection -> String -> IO QueryResult
querySynonyms conn word = do
  synonyms <- queryNamed conn "SELECT s.* FROM synonyms s INNER JOIN words w ON w.id = s.wordId WHERE word = :word" [":word" := word]
  return (QueryResult word synonyms)

saveWordData :: Connection -> WordData -> IO ()
saveWordData conn (WordData word synonyms) = do
  execute conn "INSERT INTO words (id, word, partofspeech, defseq) VALUES (?, ?, ?, ?)" word
  mapM_ (saveSynonym conn) synonyms

saveSynonym :: Connection -> Synonym -> IO ()
saveSynonym conn = execute conn "INSERT INTO synonyms (wordId, synonym) VALUES (?, ?)"

clearDatabase :: Connection -> IO ()
clearDatabase conn = do
  execute_ conn "DELETE FROM words"
  execute_ conn "DELETE FROM synonyms"
