{-# LANGUAGE OverloadedStrings #-}

module HSHOwaspLib where

import Turtle
import Prelude hiding (FilePath)
import HSHLib (assertMD5, extractZipFile, rmIfExists, echoFlush)
import qualified Data.Text as T
import qualified Control.Foldl as Fold
import Data.Foldable (for_)

checkerZip = "dependency-check-1.4.5-release.zip"
checkerMD5 = "ef3129d3e74cacf65788c239aecd5cc3"

downloadUrl = format ("http://dl.bintray.com/jeremy-long/owasp/"%fp) checkerZip

xmlReport = "dependency-check-report.xml"
reportFiles = xmlReport:["dependency-check-report.html", "dependency-check-vulnerability.html"]

owaspCheck :: Text -> FilePath -> [Text] -> IO ()
owaspCheck project path preArgs = do
  zip <- localZip
  extractZipFile zip
  deleteReports
  scandir <- realpath path
  runDependencyCheck project scandir preArgs

runDependencyCheck :: Text -> FilePath -> [Text] -> IO ()
runDependencyCheck project scandir preArgs = do
  let files = format (fp%"/**/*") scandir
  let cmd = "./dependency-check/bin/dependency-check.sh"
  let args = preArgs++["--format", "ALL", "--project", project, "--scan", files]
  echoFlush $ unsafeTextToLine $ T.intercalate " " $ cmd : args
  procs cmd args empty
  analyzeReport

analyzeReport :: IO ()
analyzeReport = do
  let cmd = format ("cat "%fp%"|grep '<severity>.*</severity>'|cut -d'>' -f2|cut -d'<' -f1|sort|uniq") xmlReport
  echoFlush $ unsafeTextToLine cmd
  (exitCode, output) <- shellStrict cmd empty
  echoFlush $ unsafeTextToLine $ format ("Report output:\n"%s) output
  let highCount = T.count "High" output
  if (highCount > 0)
    then die "ERROR: There are high severity vulnerabilities"
    else if (T.null output)
         then die "ERROR: The dependency checker produced an empty report"
    else return ()

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

deleteReports :: IO ()
deleteReports = for_ reportFiles rmIfExists
