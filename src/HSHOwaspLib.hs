{-# LANGUAGE OverloadedStrings #-}

module HSHOwaspLib where

import Turtle
import Prelude hiding (FilePath)

owaspCheck :: FilePath -> IO ()
owaspCheck path = echo $ format ("Considering running OWASP depency checker in '"%fp%"': Not implemented yet.") path
