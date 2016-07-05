{-# LANGUAGE OverloadedStrings #-}

module HSHOwaspLib where

import Turtle
import Prelude hiding (FilePath)
import HSHLib (assertMD5, extractZipFile, rmtreeIfExists)
import qualified Data.Text as T
import qualified Control.Foldl as Fold

checkerZip = "dependency-check-1.4.0-release.zip"
checkerMD5 = "0c06c24fda0db873665f5a8be6681c00"

downloadUrl = format ("http://dl.bintray.com/jeremy-long/owasp/"%fp) checkerZip

owaspCheck :: FilePath -> IO ()
owaspCheck path = do
  zip <- localZip
  extractZipFile zip
  runDependencyCheck path

runDependencyCheck :: FilePath -> IO ()
runDependencyCheck scandir = do
  let files = format (fp%"**/*") scandir
  let cmd = "./dependency-check/bin/dependency-check.sh"
  let args = ["--format", "ALL", "--project", "HSH", "--scan", files]
  echo $ T.intercalate " " $ cmd : args
  (exitCode, output) <- procStrict cmd args empty
  echo output
  let errorCount = T.count "ERROR" output
  case exitCode of
    ExitSuccess -> do
      if (errorCount > 0)
        then die $ format (d%" error(s) detected in dependency check output") errorCount
        else return ()
    ExitFailure n -> die $ format ("Dependency check exited with code: "%d) n

localZip :: IO FilePath
localZip = do
  downloaded <- testfile checkerZip
  if downloaded
    then assertMD5 checkerZip checkerMD5
    else downloadDependencyCheck

downloadDependencyCheck :: IO FilePath
downloadDependencyCheck = do
  procs "wget" [downloadUrl] empty
  assertMD5 checkerZip checkerMD5
