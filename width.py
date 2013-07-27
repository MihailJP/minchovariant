#!/usr/bin/env fontforge

import fontforge
from sys import argv, stderr

def getfield(glyph, key):
	import re
	nwl = re.compile('\r?\n')
	field = re.compile(r'^\s*([\w\-]+)\s*:\s*(.+?)\s*$')
	rawlist = nwl.split(glyph.comment)
	fields = {}
	for line in rawlist:
		(name, value) = field.match(line).group(1, 2)
		fields[name] = value
	return fields[key]

def hwList():
	import fileinput
	import os
	import re
	currdir = os.getcwd()
	try:
		os.chdir(os.path.dirname(__file__))
	except OSError:
		pass
	hwl = set()
	nwl = re.compile('\r?\n')
	for line in fileinput.input("groups/HALFWIDTH.txt"):
		hwl.add(nwl.sub('', line))
	os.chdir(currdir)
	return frozenset(hwl)

font = fontforge.open(argv[1])
hwl = hwList()
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		kagename = getfield(glyph, "Kage")
		if kagename in hwl:
			glyph.width /= 2
font.generate(argv[2])
