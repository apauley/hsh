{-# LANGUAGE OverloadedStrings #-}

module HSHLib where

import Turtle
import Prelude hiding (FilePath)
import qualified Data.Text as T
import qualified Control.Foldl as Fold

psg :: Text -> Shell Text
psg g = do
  let ps = inproc "ps" ["-ef"] empty
  let dontmatch = invert $ has (text $ format ("psg "%s) g)
  let pattern = has $ text g
  grep dontmatch $ grep pattern ps

assertMD5 :: FilePath -> Text -> IO FilePath
assertMD5 file expectedMD5 = do
  let cmd = format ("md5sum "%fp%"| awk '{print $1}'") file
  let shellMD5 = inshell cmd empty
  maybeMD5 <- fold shellMD5 Fold.head
  let md5 = case maybeMD5 of
        Just m  -> m
        Nothing -> "Oops, no MD5!"
  if (md5 == expectedMD5)
    then realpath file
    else die $ format ("I got an MD5 of "%s%", but I expected "%s) md5 expectedMD5

extractZipFile :: FilePath -> IO ()
extractZipFile zipfile = procs "unzip" [format fp zipfile] empty

rmtreeIfExists :: FilePath -> IO ()
rmtreeIfExists dir = do
  exists <- testdir dir
  if exists
    then rmtree dir
    else return ()
