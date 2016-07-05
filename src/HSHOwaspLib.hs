{-# LANGUAGE OverloadedStrings #-}

module HSHOwaspLib where

import Turtle
import Prelude hiding (FilePath)
import HSHLib (assertMD5, extractZipFile, rmIfExists)
import qualified Data.Text as T
import qualified Control.Foldl as Fold

checkerZip = "dependency-check-1.4.0-release.zip"
checkerMD5 = "0c06c24fda0db873665f5a8be6681c00"

downloadUrl = format ("http://dl.bintray.com/jeremy-long/owasp/"%fp) checkerZip

reportFiles = ["dependency-check-report.html", "dependency-check-report.xml", "dependency-check-vulnerability.html"]

owaspCheck :: FilePath -> IO ()
owaspCheck path = do
  zip <- localZip
  extractZipFile zip
  deleteReports
  scandir <- realpath path
  runDependencyCheck scandir

runDependencyCheck :: FilePath -> IO ()
runDependencyCheck scandir = do
  let files = format (fp%"/**/*") scandir
  let cmd = "./dependency-check/bin/dependency-check.sh"
  let args = ["--format", "ALL", "--project", "HSH", "--scan", files]
  echo $ T.intercalate " " $ cmd : args
  procs cmd args empty

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

deleteReports = do
  let [r1,r2,r3] = reportFiles
  rmIfExists r1; rmIfExists r2; rmIfExists r3
