#!/usr/bin/env fontforge

import fontforge
font = fontforge.open("work.sfd")
for glyph in font.glyphs():
	if glyph.isWorthOutputting():
		layer = glyph.layers[1]
		if not layer.isEmpty():
			newLayer = fontforge.layer()
			newLayer += layer[0]
			for i in range(1, len(layer)):
				newLayer += layer[i]
				newLayer.removeOverlap()
			glyph.layers[1] = newLayer
font.generate("work.ttf")
