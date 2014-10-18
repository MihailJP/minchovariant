#!/usr/bin/env fontforge

import fontforge, psMat
from sys import argv, stderr
from math import atan2, degrees, hypot

if len(argv) < 3:
	stderr.write("Usage: "+argv[0]+" infile outfile\n")
	quit(1)

fontforge.setPrefs('CoverageFormatsAllowed', 1)

font = fontforge.open(argv[1])
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		newLayer = fontforge.layer()
		for contour in glyph.layers[1]:
			newContour = contour.dup()
			angles = []
			obtusityLimit = None
			if len(contour) == 5:
				obtusityLimit = 135
			else:
				obtusityLimit = 150
			for i in range(0, len(contour)):
				angle = {}
				angle['anglePrev'] = degrees(atan2(contour[i-1].y - contour[i].y,
				                                   contour[i-1].x - contour[i].x))
				angle['distPrev'] = hypot(contour[i-1].x - contour[i].x,
				                          contour[i-1].y - contour[i].y)
				angle['angleNext'] = degrees(atan2(contour[(i+1) % len(contour)].y - contour[i].y,
				                                   contour[(i+1) % len(contour)].x - contour[i].x))
				angle['distNext'] = hypot(contour[(i+1) % len(contour)].x - contour[i].x,
				                          contour[(i+1) % len(contour)].y - contour[i].y)
				angle['vertex'] = (angle['anglePrev'] + angle['angleNext']) / 2
				angle['tangential'] = (angle['vertex'] + (90 if angle['anglePrev'] > angle['angleNext'] else 270)) % 360 - 180
				angle['angle'] = (angle['angleNext'] - angle['anglePrev'] + 180) % 360 - 180
				angles += [angle]
			spiros = []
			for i in range(0, len(contour)):
				point = contour[i]
				if abs(angles[i]['angle']) > obtusityLimit:
					spiros += [(point.x, point.y, fontforge.spiroG4, 0)]
				else:
					spiros += [(point.x, point.y, fontforge.spiroCorner, 0)]
			newContour.spiros = tuple(spiros)
			newLayer += newContour
		glyph.layers[1] = newLayer
		glyph.simplify()
font.save(argv[2])
font.close()

