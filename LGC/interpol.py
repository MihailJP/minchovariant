#!/usr/local/bin/fontforge

from sys import (argv, stderr)
import fontforge

if len(argv) < 3:
	stderr.write("Usage: %s filename weight-param\n" % argv[0])
	exit(1)

def val(string):
	try:
		return int(string)
	except ValueError:
		return float(string)

srcFont = fontforge.open("Medium.sfdir")
font = srcFont.interpolateFonts(val(argv[2]), "Bold.sfdir")
font.generate(argv[1])
