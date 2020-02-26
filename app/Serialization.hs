{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Serialization
  ( serializeResult
  ) where

import qualified Data.Text         as T
import           NeatInterpolation
import           Types

serializeResult :: [Synonym] -> T.Text
serializeResult synonyms =
  [text|
{
  "items": [
    $serializedSynonyms
  ]
}|]
  where
    serializedSynonyms = T.intercalate "," . map serializeSynonym $ synonyms

serializeSynonym :: Synonym -> T.Text
serializeSynonym (Synonym _ synonym) =
  [text|
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
