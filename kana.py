#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr

if len(argv) < 5:
	stderr.write("Usage: "+argv[0]+" weight source-kana reserved outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

srcFont1 = fontforge.open(argv[2])

# Not implemented yet

srcFont1.save(argv[4])
