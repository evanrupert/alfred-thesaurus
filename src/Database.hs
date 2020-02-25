{-# LANGUAGE OverloadedStrings #-}
module Database
    ( saveWordData
    , clearDatabase
    ) where

import Types
import Database.SQLite.Simple

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
