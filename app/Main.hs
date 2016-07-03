{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle
import Prelude hiding (FilePath)
import HSHLib

main :: IO ()
main = do
  PSGrep g <- options "Haskell Shell Helpers" parser
  echo g

data Command = PSGrep Text  deriving (Show)

parser :: Parser Command
parser = fmap PSGrep (subcommand "psg" "Grep for text from a process listing"
                      (argText "text" "Some text to grep for"))

