{-# LANGUAGE OverloadedStrings #-}

module HSHAnsiColourLib where
import Turtle

type ColourCode = Text

colourText :: ColourCode -> Text -> Text
colourText colour t = format ("\x1b["%s%"m"%s%"\x1b[0m") colour t

blueFG = colourText codeBlueFG
greenFG = colourText codeGreenFG

redBG = colourText codeRegBG

blueOnRed = blueFG . redBG

-- http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

codeBlueFG = "0;34"
codeGreenFG = "0;32"
codePurpleFG = "0;35"
codeLightPurpleFG = "1;35"
codeRegBG = "0;41"
