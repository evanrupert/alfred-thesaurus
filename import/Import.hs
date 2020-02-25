{-# LANGUAGE OverloadedStrings #-}

module Import where

import           Control.Monad
import           Database
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow
import           Parse
import           System.IO
import           Types
import System.Environment

main :: IO ()
main = do
  conn <- open "thesaurus.db"
  clearDatabase conn
  fileHandle <- openDataFile
  discardFileHeading fileHandle
  consumeFileIntoDatabase conn fileHandle
  hClose fileHandle
  close conn

openDataFile :: IO Handle
openDataFile = do
  args <- getArgs
  openFile (head args) ReadMode

discardFileHeading :: Handle -> IO ()
discardFileHeading = void . hGetLine

consumeFileIntoDatabase :: Connection -> Handle -> IO ()
consumeFileIntoDatabase = consumeFileIntoDatabaseInner 0

consumeFileIntoDatabaseInner :: Int -> Connection -> Handle -> IO ()
consumeFileIntoDatabaseInner nextId conn fileHandle = do
  nextId <- consumeWordIntoDatabase conn fileHandle nextId
  eof <- hIsEOF fileHandle
  unless eof $ consumeFileIntoDatabaseInner nextId conn fileHandle

consumeWordIntoDatabase :: Connection -> Handle -> Int -> IO Int
consumeWordIntoDatabase conn fileHandle nextId = do
  (word, synonymLines) <- readWordData fileHandle
  putStrLn $ "Inserting " ++ word ++ " into database"
  let parsedDefinitions = parseDefinitionLines synonymLines
  let wordDataRecords = map (\(idx, def) -> buildWordData idx (nextId + idx) word def) $ zip [0 ..] parsedDefinitions
  mapM_ (saveWordData conn) wordDataRecords
  return (nextId + length wordDataRecords)

readWordData :: Handle -> IO (String, [String])
readWordData fileHandle = do
  wordLine <- hGetLine fileHandle
  let (w, defCount) = parseWordLine wordLine
  synonymLines <- replicateM defCount (hGetLine fileHandle)
  return (w, synonymLines)
