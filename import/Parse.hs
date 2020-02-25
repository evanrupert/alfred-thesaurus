module Parse
  ( parseWordLine
  , parseDefinitionLines
  , buildWordData
  ) where

import           Types
import           Prelude hiding (id)

--parseDefinitions :: String -> [String] -> [WordData]
--parseDefinitions word definitionLines =
--  where
--    parsedLines = parseDefinitionLines definitionLines
--    buildWord idx def = buildWordData idx

buildWordData :: Int -> Int -> String -> (PartOfSpeech, [String]) -> WordData
buildWordData seq id word (part, rawSynonyms) = WordData def syns
  where
    def = Definition { id = id, rawWord = word, partOfSpeech = part, defSeq = seq }
    syns = map (Synonym id) rawSynonyms

parseWordLine :: String -> (String, Int)
parseWordLine line = (w, read defCount :: Int)
  where
    [w, defCount] = splitOn (== '|') line

parseDefinitionLines :: [String] -> [(PartOfSpeech, [String])]
parseDefinitionLines = map parseLine

parseLine :: String -> (PartOfSpeech, [String])
parseLine line = (read part :: PartOfSpeech, synonyms)
  where
    (part:synonyms) = splitOn (=='|') line

splitOn :: (Char -> Bool) -> String -> [String]
splitOn predicate string =
  case dropWhile predicate string of
    "" -> []
    s -> w : splitOn predicate s''
      where (w, s'') = break predicate s
