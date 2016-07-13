{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle
import Prelude hiding (FilePath)
import HSHLib
import HSHOwaspLib

main :: IO ()
main = do
  x <- options "Haskell Shell Helpers" parser
  case x of
    PSGrep g                                -> stdout $ psg g
    OwaspDependencyCheck (project, scandir) -> owaspCheck project scandir []

data Command = PSGrep Text | OwaspDependencyCheck (Text, FilePath) deriving (Show)

parser :: Parser Command
parser = fmap PSGrep (subcommand "psg" "Grep for text from a process listing."
                      (argText "text" "Some text to grep for"))
     <|> fmap OwaspDependencyCheck (subcommand "owasp-dependency-check"
                                    "Run the OWASP dependency checker pointing at a directory.\nhttps://www.owasp.org/index.php/OWASP_Dependency_Check"
                      ((,) <$> (argText "project" "The project name to be displayed in the report")
                           <*> (argPath "dir" "A directory with files to check")))
