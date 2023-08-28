#!/usr/bin/env python
# -*- coding: utf-8 -*-

def javascript(scriptName):
	from sys import platform
	if platform == 'Darwin' or platform == 'darwin':
		return '/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc ' + scriptName + ' --'
	else:
		return 'd8 ' + scriptName + ' --'

FONTFORGE = "export LANG=utf-8; env fontforge"
MAKEGLYPH = javascript("./makeglyph.js")
MV = "/bin/mv"
HEADER_FILENAME = "head.txt"
PARTS_FILENAME = "parts.txt"
FOOTER_FILENAME = "foot.txt"
TEMPNAME = "temp"

from sys import version_info
if version_info.major < 3:
	print("Python 2 is no longer supported!")
	exit(1)

from sys import exit, argv as ARGV
from os import system
from os.path import exists, dirname
from subprocess import getoutput
import re
import urllib.parse
from os.path import join as pathjoin
import sqlite3
import codecs

if len(ARGV) != 5:
	print("Usage: makettf.pl WorkingDirectory WorkingName Shotai Weight")
	print("Shotai: mincho or gothic")
	print("Weight: 1 3 5 7")
	exit(1)

dbFileName = pathjoin(dirname(ARGV[0]), "HZMincho.db")
if not exists(dbFileName):
	raise IOError(2, "Database '%s' not found" % (dbFileName,))

KumimojiGlyphs = set()
with sqlite3.connect(dbFileName) as db:
	for cids in db.execute('select horizontal, vertical, horizontalAlt, verticalAlt from cjkKumimoji;'):
		for cid in cids:
			if cid is not None:
				KumimojiGlyphs.add(cid)

def unlink(filename):
	import os, errno
	try:
		os.unlink(filename)
	except OSError:
		pass

def mkdir(dirname):
	import os, errno
	try:
		os.mkdir(dirname)
	except OSError:
		pass

(WORKDIR, WORKNAME, SHOTAI, WEIGHT) = ARGV[1:5]

unlink(WORKDIR+"/"+WORKNAME+".log")
unlink(WORKDIR+"/"+WORKNAME+".scr")
unlink(WORKDIR+"/"+WORKNAME+".ttf")
mkdir(WORKDIR+"/build")

LOG = codecs.open(WORKDIR+"/"+WORKNAME+".log", "a", "utf-8")

buhin = {}
targetDict = {}

##############################################################################

def adjustWeight(weight, code):
	if (int(code, 16) - 0xf0000) not in KumimojiGlyphs:
		return weight
	elif weight == 1:
		return 0
	elif weight == 3:
		return 1
	elif weight == 5 or weight == 105:
		return 3
	elif weight == 7:
		return 5
	elif weight == 107:
		return 105
	elif weight == 9:
		return 7
	elif weight == 109:
		return 107
	elif weight == 201:
		return 200
	elif weight == 203:
		return 201
	elif weight == 205:
		return 203
	elif weight == 207:
		return 205
	else:
		return weight

##############################################################################

def render(target, partsdata, code):
	LOG.write(code+" : "+(" ".join([MAKEGLYPH, target, urllib.parse.quote_plus(partsdata), SHOTAI, str(adjustWeight(int(WEIGHT), code))]))+"\n")
	svgBaseName = WORKDIR+"/build/"+code
	needsUpdate = False
	if not exists(svgBaseName+".kage"):
		needsUpdate = True
	else:
		with codecs.open(svgBaseName+".kage", "r", "utf-8") as FH:
			if FH.read().rstrip('\n') != partsdata.rstrip('\n'):
				needsUpdate = True
	if needsUpdate:
		with codecs.open(svgBaseName+".kage", "w", "utf-8") as FH:
			FH.write(partsdata)

##############################################################################

def addglyph(code, refGlyph, target):
	textbuf = """Print(0u{0})
Select(0u{0})
Clear()
Import("{3}/build/{0}.svg")
Scale(500)
CanonicalContours()
CanonicalStart()
FindIntersections()
SetGlyphComment("Kage: {1}\\nAlias: {2}")
Simplify()
Scale(20)
SetWidth(1000)
RoundToInt()
AutoHint()
""".format(code, refGlyph, target, WORKDIR)
	while True:
		try:
			FH = codecs.open(WORKDIR+"/"+WORKNAME+".scr", "a", "utf-8")
		except IOError:
			continue
		FH.write(textbuf)
		FH.close()
		break

##############################################################################

def makefont():
	textbuf = "Save(\""+WORKDIR+"/"+WORKNAME+".sfd\")\n"
	textbuf += "Quit()\n"
	with codecs.open(WORKDIR+"/"+WORKNAME+".scr", "a", "utf-8") as FH:
		FH.write(textbuf)

##############################################################################

def addsubset(subset, target):
	subset[target] = buhin[target]
	txtbuf = '$'+buhin[target]+'$'
	for match in re.findall(r"(\$99:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^\$:]*)(?::[^\$]*)?)", txtbuf):
		if match[1].strip() not in subset:
			addsubset(subset, match[1].strip())

##############################################################################

# initialize
if exists(WORKDIR+"/"+HEADER_FILENAME):
	with codecs.open(WORKDIR+"/"+HEADER_FILENAME, "r", "utf-8") as FH:
		with codecs.open(WORKDIR+"/"+WORKNAME+".scr", "a", "utf-8") as FH2:
			for line in FH:
				FH2.write(line)

	LOG.write("Prepare header file ... done.\n")
else:
	LOG.write("No header file.\n")
	LOG.close()
	exit(2)

# parse buhin
temp = []
if exists(WORKDIR+"/"+PARTS_FILENAME):
	with codecs.open(WORKDIR+"/"+PARTS_FILENAME, "r", "utf-8") as FH:
		temp = FH.readlines()
	LOG.write("Prepare parts file ... done.\n")
else:
	LOG.write("No parts file.\n")
	LOG.close()
	exit(2)

for tmpdat in temp:
	if re.search(":", tmpdat):
		temp2 = re.split(r" +|\t", tmpdat)
		buhin[temp2[0]] = temp2[1]
LOG.write("Prepare parts data ... done.\n")

# parse target code point
with codecs.open("../glyphs.txt", "r", "utf-8") as GLYPHLIST: # or die "Cannot read the glyph list"
	for line in GLYPHLIST:
		name = line.rstrip()
		target = re.sub(r"^[uU]0*", "", name) # delete zero for the beginning
		targetDict[target] = name
LOG.write("Prepare target code point ... done.\n")

# make glyph for each target
LOG.write("Prepare each glyph.\n")

targets = sorted(list(set(targetDict.keys())))
with codecs.open(WORKDIR+"/build/Makefile", "w", "utf-8") as FH:
	FH.write("TARGETS=\\\n")
	for code in targets:
		FH.write(code + ".svg \\\n")
	FH.write("""
.PHONY: all clean
.DELETE_ON_ERROR: $(TARGETS)

all: $(TARGETS)

.SUFFIXES: .kage .svg
.kage.svg:
	set -o pipefail; \\
	cd ..; \\
	KAGE=$$(<build/$<);\\
	d8 --single-threaded ./makeglyph.js -- u$* "$$KAGE" {0} {1} | \\
	magick convert - -background white -flatten -alpha off bmp:- | \\
	potrace -s - -o build/$@

clean:
	rm -f *.svg *.bmp *.png
""".format(SHOTAI, str(adjustWeight(int(WEIGHT), code))))
for code in targets:
	#LOG.write(code+" : ")
	refGlyph = targetDict[code]
	subset = {}
	addsubset(subset, refGlyph)
	partsdata = ""
	for subsetKey in subset.keys():
		partsdata += subsetKey+" "+subset[subsetKey]+"\n"
	target = urllib.parse.quote_plus(refGlyph)
	render(target, partsdata, code)
	addglyph(code, refGlyph, target)
LOG.write("Prepare each glyph ... done.\n")

# scripts footer
if exists(WORKDIR+"/"+FOOTER_FILENAME):
	with codecs.open(WORKDIR+"/"+FOOTER_FILENAME, "r", "utf-8") as FH:
		with codecs.open(WORKDIR+"/"+WORKNAME+".scr", "a", "utf-8") as FH2:
			for txtbuf in FH:
				FH2.write(txtbuf)
	
	LOG.write("Prepare footer file ... done.\n")
else:
	LOG.write("No footer file.\n")
	LOG.close()
	exit(2)

LOG.close()
makefont()
