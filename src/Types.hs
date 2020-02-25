{-# LANGUAGE OverloadedStrings #-}
module Types
    ( ThesWord (ThesWord)
    , ThesSynonym (ThesSynonym)
    , PartOfSpeech (Noun, Adjective, Verb, Adverb)
    ) where


import qualified Data.Text as T
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToField


data PartOfSpeech
    = Noun
    | Adjective
    | Verb
    | Adverb
    deriving (Show)


data ThesWord = ThesWord { word :: String
                         , partOfSpeech :: PartOfSpeech
                         } deriving (Show)


instance ToRow ThesWord where
    toRow w = toRow (word w, partOfSpeech w)


instance ToField PartOfSpeech where
    toField = SQLText . T.pack . show


data ThesSynonym = ThesSynonym { thesWord :: String
                               , synonym :: String
                               }
