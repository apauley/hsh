{-# LANGUAGE OverloadedStrings #-}

module HSHLib
    ( someFunc
    ) where

import Turtle
import Prelude hiding (FilePath)

someFunc :: IO ()
someFunc = echo "someFunc"
