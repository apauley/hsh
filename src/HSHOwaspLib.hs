{-# LANGUAGE OverloadedStrings #-}

module HSHOwaspLib where

import Turtle
import Prelude hiding (FilePath)
import HSHLib (assertMD5, extractZipFile, rmtreeIfExists)

checkerZip = "dependency-check-1.4.0-release.zip"
checkerMD5 = "0c06c24fda0db873665f5a8be6681c00"

downloadUrl = format ("http://dl.bintray.com/jeremy-long/owasp/"%fp) checkerZip

owaspCheck :: FilePath -> IO ()
owaspCheck path = do
  zip <- localZip
  putStrLn $ show zip
  rmtreeIfExists "dependency-check"
  extractZipFile zip
  echo "done"

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
