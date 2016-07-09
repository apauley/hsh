{-# LANGUAGE OverloadedStrings #-}

module HSHLib where

import Turtle
import Prelude hiding (FilePath)
import qualified Data.Text as T
import qualified Control.Foldl as Fold
import qualified System.IO as SysIO (hFlush, stdout)
import Data.Maybe

psg :: Text -> Shell Text
psg g = do
  let ps = inproc "ps" ["-ef"] empty
  let dontmatch = invert $ has (text $ format ("psg "%s) g)
  let pattern = has $ text g
  grep dontmatch $ grep pattern ps

assertMD5 :: FilePath -> Text -> IO FilePath
assertMD5 file expectedMD5 = do
  let cmd = format ("md5sum "%fp%"| awk '{print $1}'") file
  maybeMD5 <- maybeFirstLine $ inshell cmd empty
  let md5 = fromMaybe "Oops, no MD5!" maybeMD5
  if (md5 == expectedMD5)
    then realpath file
    else die $ format ("I got an MD5 of "%s%", but I expected "%s) md5 expectedMD5

extractZipFile :: FilePath -> IO ()
extractZipFile zipfile = procs "unzip" ["-u", format fp zipfile] empty

rmIfExists :: FilePath -> IO ()
rmIfExists file = do
  exists <- testfile file
  if exists
    then rm file
    else return ()

rmtreeIfExists :: FilePath -> IO ()
rmtreeIfExists dir = do
  exists <- testdir dir
  if exists
    then rmtree dir
    else return ()

echoFlush :: Text -> IO ()
echoFlush s = do
  echo s
  SysIO.hFlush SysIO.stdout

emptyErrorText :: Either a Text -> Text
emptyErrorText = either (\a -> "") (\b -> b)

maybeFirstLine :: Shell Text -> IO (Maybe Text)
maybeFirstLine shellText = fold shellText Fold.head

terminalColumns :: IO Int
terminalColumns = do
  let cols = inproc "/usr/bin/env" ["tput", "cols"] empty
  maybeCols <- fold cols Fold.head
  return $ read $ T.unpack $ fromMaybe "80" maybeCols
