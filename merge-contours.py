#!/usr/bin/env fontforge

import fontforge
from sys import argv, stderr

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" infile outfile\n")
	quit(1)

def separate(contour):
	layer = fontforge.layer()
	for i in range(0, len(contour) - 1):
		for j in range(len(contour) - 1, i, -1):
			if contour[i] == contour[j] and contour[i].on_curve and contour[j].on_curve:
				c1 = fontforge.contour()
				c2 = fontforge.contour()
				c1 += contour[0:i]
				c1 += contour[j:len(contour)]
				c2 += contour[i:j]
				c1.closed = c2.closed = True
				try:
					if c1.isClockwise() == 0:
						c1.reverseDirection()
				except AttributeError:
					pass
				try:
					if c2.isClockwise() == 0:
						c2.reverseDirection()
				except AttributeError:
					pass
				layer += c1
				return layer + separate(c2)
	layer += contour
	return layer

def separateSelfIntersect(layer):
	l = fontforge.layer()
	for contour in layer:
		if contour.selfIntersects():
			l += separate(contour)
		elif contour.isClockwise() == 0:
			l += contour.reverseDirection()
		else:
			l += contour
	return l

import fontforge
font = fontforge.open(argv[1])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		layer = separateSelfIntersect(glyph.layers[1])
		if not layer.isEmpty():
			newLayer = fontforge.layer()
			newLayer += layer[0]
			try:
				for i in range(1, len(layer)):
					newLayer += layer[i]
					newLayer.removeOverlap()
			except Exception, ex:
				print glyph.glyphname, ex
				if ex.args[0] != "Empty contour":
					raise
			glyph.layers[1] = newLayer
font.generate(argv[2])
