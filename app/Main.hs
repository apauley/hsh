{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle
import Prelude hiding (FilePath)
import HSHLib

main :: IO ()
main = do
  echo "Hello HSH"
  someFunc
