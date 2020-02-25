{-# LANGUAGE OverloadedStrings #-}
module Import where


import Types
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow


main :: IO ()
main = do
    conn <- open "thesaurus.db"
    execute conn "INSERT INTO words (word, partofspeech) VALUES (?, ?)"
        (ThesWord "cat" Noun)

    close conn
