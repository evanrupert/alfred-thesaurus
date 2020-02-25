{-# LANGUAGE DisambiguateRecordFields #-}
{-# LANGUAGE OverloadedStrings        #-}

module Types
    ( WordData(WordData)
    , Definition(..)
    , PartOfSpeech(Noun, Adjective, Verb, Adverb)
    , Synonym(Synonym)
    ) where

import qualified Data.List                      as L
import qualified Data.Text                      as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow
import           Database.SQLite.Simple.ToField
import           Prelude                        hiding (id)

data WordData =
    WordData
        { definition :: Definition
        , synonyms   :: [Synonym]
        }

instance Show WordData where
    show (WordData word synonyms) =
      idDisplay ++ ") " ++ wordDisplay ++ " (" ++ partDisplay ++ ") [ " ++ synonymsDisplay ++ " ]"
      where
        idDisplay = show . id $ word
        wordDisplay = quote . rawWord $ word
        partDisplay = show . partOfSpeech $ word
        synonymsDisplay = L.intercalate ", " . map (quote . synonym) $ synonyms

quote :: String -> String
quote s = "'" ++ s ++ "'"

data Definition =
    Definition
        { id           :: Int
        , rawWord      :: String
        , partOfSpeech :: PartOfSpeech
        , defSeq       :: Int
        }
    deriving (Show)

instance ToRow Definition where
    toRow (Definition id rawWord part defSeq) = toRow (id, rawWord, part, defSeq)

data PartOfSpeech
    = Noun
    | Adjective
    | Verb
    | Adverb
    deriving (Show)

instance ToField PartOfSpeech where
    toField = SQLText . T.pack . show

instance Read PartOfSpeech where
    readsPrec _ input =
        case input of
            "(noun)" -> [(Noun, "")]
            "(adj)" -> [(Adjective, "")]
            "(verb)" -> [(Verb, "")]
            "(adv)" -> [(Adverb, "")]
            s -> error $ "Could not read (" ++ s ++ ") into PartOfSpeech"

data Synonym =
    Synonym
        { wordRef :: Int
        , synonym :: String
        }
    deriving (Show)

instance ToRow Synonym where
    toRow (Synonym wordRef synonym) = toRow (wordRef, synonym)
