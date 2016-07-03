{-# LANGUAGE OverloadedStrings #-}

module HSHLib where

import Turtle
import Prelude hiding (FilePath)
import qualified Data.Text as T

psg :: Text -> Shell Text
psg g = do
  let ps = inproc "ps" ["-ef"] empty
  let dontmatch = invert $ has (text $ format ("psg "%s) g)
  let pattern = has $ text g
  grep dontmatch $ grep pattern ps
