#!/usr/bin/env fontforge

import fontforge
from sys import argv, stderr

fontforge.setPrefs('CoverageFormatsAllowed', 1)

if len(argv) != 3:
	stderr.write("Usage: {0} InFont OutFont\n".format(argv[0]))
	exit(1)
(InFont, OutFont) = argv[1:]

font = fontforge.open(InFont)

font.cidfontname = "LGC"
font["space"].unicode = 0x0020

font.generate(OutFont)
