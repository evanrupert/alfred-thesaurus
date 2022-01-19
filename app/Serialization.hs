{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Serialization
  ( serializeResult
  ) where

import qualified Data.Text         as T
import           NeatInterpolation
import           Types

serializeResult :: QueryResult -> T.Text
serializeResult (QueryResult word synonyms) =
  [text|
{
  "items": [
    $serializedSynonyms
  ]
}|]
  where
    serializedSynonyms = T.intercalate "," . map (serializeSynonym word) $ synonyms

serializeSynonym :: String -> Synonym -> T.Text
serializeSynonym word (Synonym _ synonym) =
  [text|
{
  "uid": "$syn",
  "title":"$syn",
  "autocomplete": "$syn",
  "subtitle": "Synonym of $w",
  "icon": {
    "path": "/Users/evan/Programs/thesaurus/flat-book-icon.png"
  }
}|]
  where
    w = T.pack word
    syn = T.pack synonym
