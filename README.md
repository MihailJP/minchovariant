HZ Mincho OpenType font
=======================
This is a free/libre OpenType CID-keyed Japanese font
derived from [GlyphWiki](http://en.glyphwiki.org/wiki/GlyphWiki:MainPage)'s
CJK data, with weight variations.

Latin, Greek and Cyrillic glyphs are not derived from GlyphWiki but from
[Computer Modern Unicode](http://canopus.iacp.dvo.ru/~panov/cm-unicode/)
because GlyphWiki's [Kage engine](http://fonts.jp/kage/index.en.html) is
intended for Chinese characters and not good at LGC.

Some symbols are from
[M+](http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/) fonts and
[GL Antique](http://gutenberg.osdn.jp/ja/) font.

Build-time dependencies
-----------------------
These softwares are required in order to build the font.
Of course no special softwares required after once the font is built.

KAGE engine is referred as a Git submodule. Do not forget
`git submodule init && git submodule update` before you build.

* [Fontforge][1] with Python and native script feature enabled
* [Adobe Font Development Kit for OpenType][2]
  * Make sure AFDKO executables are in `PATH`
* JavaScript
  * [V8](https://v8.dev/) engine required for Windows or Linux
* [Perl](http://www.perl.org/)
* [Python](https://www.python.org/) 3
* [Ruby](https://www.ruby-lang.org/)
  * gems [sorted_set](https://rubygems.org/gems/sorted_set/)
    and [sqlite3](https://rubygems.org/gems/sqlite3/)
* [SQLite3](http://www.sqlite.org/)
* [ImageMagick](http://www.imagemagick.org/)
  * [Inkscape](https://inkscape.org/) may be needed to read/write SVG
* [Potrace](http://potrace.sourceforge.net/)

[1]: http://fontforge.github.io/
[2]: http://www.adobe.com/devnet/opentype/afdko.html

Prerequisite memory amount
--------------------------
This is a Japanese font, which consists of more than twenty thousand glyphs.
It is known that this require 4GB of memory in order to build (on Linux:
concretely speaking, this is while running Fontforge). Avoid `make -j` in
order not to experience thrashing.

Also, it may take **days** to build the fonts.

Authors
-------
* Merged by MihailJP <mihailjp@gmail.com>.
* GlyphWiki contributors
  * Includes MihailJP
* Andrei V. Panov (Computer Modern Unicode)
  * Some additional glyphs are composed by MihailJP
* Coji Morishita (M+ 2m)

License
-------
This font is composed of some individual fonts available under
their open source licenses.

HZMincho font may be used in any way, including, but not limited to, copying,
modifying, distributing, or selling copies, as long as you follow the terms
of Computer Modern Unicode's X11 license with font embedding exception.
This permission is regardless of commerciality.

### GlyphWiki's license ##
_See [GlyphWiki:License](http://en.glyphwiki.org/wiki/GlyphWiki:License)._

All glyphs at GlyphWiki are free to any use and comes with no warranty.

> The glyphs registered at the GlyphWiki, as well as the articles, can be
> freely used by anyone. Reuse of this data, such as reproduction or
> modification of the glyps, is permitted. The are no specific restrictions
> with regards to displaying the author's name. Reuse of GlyphWiki data as
> the basis for a new font, or direct usage of fonts and glyphs copied from
> GlyphWiki in published work is allowed. GlyphWiki does not hold copyright
> on any citations used throughout GlyphWiki articles. Please consult their
> respective licences when reusing such content.

### License of Computer Modern Unicode ###
_See http://canopus.iacp.dvo.ru/~panov/cm-unicode/license.html._

The versions of Computer Modern Unicode font prior to 0.7.0 are distributed
under the terms of X11 License with exception similar to GPL's
font exception clause.

> Andrey V. Panov (C) 2005
> 
> All rights reserved.
> 
> Permission is hereby granted, free of charge, to any person obtaining a
> copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, and/or sell copies of the Software, and to permit persons to
> whom the Software is furnished to do so, provided that the above
> copyright notice(s) and this permission notice appear in all copies of
> the Software and that both the above copyright notice(s) and this
> permission notice appear in supporting documentation.
> 
> **THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
> OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
> THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
> INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
> OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
> OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
> OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
> PERFORMANCE OF THIS SOFTWARE.**
> 
> Except as contained in this notice, the name of a copyright holder shall
> not be used in advertising or otherwise to promote the sale, use or
> other dealings in this Software without prior written authorization of
> the copyright holder.
> 
> As a special exception, if you create a document which uses these fonts,
> and embed these fonts or unaltered portions of these fonts into the
> document, these fonts does not by itself cause the resulting document to
> be covered by the X11 License. This exception does not however
> invalidate any other reasons why the document might be covered by the
> X11 License. If you modify these fonts, you may extend this exception to
> your version of the fonts, but you are not obligated to do so. If you do
> not wish to do so, delete this exception statement from your version.

### License of M+ fonts ###
_See http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/index.html#license._

M+ font is free for any use.

> These fonts are free software.
> 
> Unlimited permission is granted to use, copy, and distribute them,
> with or without modification, either commercially or noncommercially.
> 
> **THESE FONTS ARE PROVIDED "AS IS" WITHOUT WARRANTY.**

### License of GL-Antique ###
_See http://gutenberg.osdn.jp/ja/license.html._

Same as M+ fonts.

Version History
---------------

### Version 1.404, September 13, 2023
* Modify Socho glyphs
* Import makeglyph.js from the old Kage repository
* Remove urlencode
* Bugfix

### Version 1.403, September 10, 2023
* Fix connecting diagonal lines of HZ Latin

### Version 1.402, August 31, 2023
* Modify Gothic glyphs

### Version 1.401, August 27, 2023
* Modify Gothic strokes

### Version 1.400, August 26, 2023
* Update development environment
* Update Kage engine
* Update glyph data
* Add 'Pr6N' to font name
* Set `sFamilyClass`

### Version 1.304, June 24, 2019
* Update meta-makefile for intermediate files
* Add target `mostlyclean`
* Modify glyphs for mathematic operators and some punctuations
* Fix HZMincho.sql (glyph Nos. 15880, 15905)
* Update Kage.rb (0:97:... to 0:99:...)
* Intermediate parts file
* Unexpected newline while running makesvg.py
* Cleanup pua-addenda.txt and pua-extension.txt
* Cleanup VWidth
* Cleanup subfonts

### Version 1.303, June 13, 2019
* Fix pitch of fullwidth space in Gothic font
* Omit generating Kage-glyphs for Kumimoji subfont (which is LGC only)
* Fix width of halfwidth kana
* Remove subfont `Dingbats` whose all remaining glyphs are moved to `Symbols`
* Split subfont `EnclosedAlnum` from `Enclosed`
* Correct width of sans-serif bold glyphs which was of narrower pitch than medium-weight
* Update glyphs for mathematical operators

### Version 1.302, June 5, 2019
* Add symbol glyphs
* Glyphs for block elements
* Move block element glyphs to Symbols subfont
* Replace CIDs 7917 and 20958

### Version 1.301, May 28, 2019
* Replace LGC and symbol glyphs

### Version 1.300, May 22, 2019
* Adobe Japan1-7 font
* Updated font engine
* Fix wrong font name for HZ Gothic fonts
* Fix some stroke thinning issues
* No longer depends on Inkscape for build
* Intermediate rasterization is now now equal-magnified (200px) rather than 1024px.
* Reduce build time by omitting rendering of unneeded Kage glyphs.

### Version 1.200, May 30, 2016
* First release for HZ Gothic fonts
* Updated font engine
* Remove Mac font name
* Semi-voiced mark adjustment
* Fix kumimoji thinning issue
* Fix width issue at some pre-composed and enclosed glyphs in Mincho font
* Improved LGC of Socho font

### Version 1.101, June 1, 2015
* Fix subfamily and full name (issue on Windows)

### Version 1.100, May 6, 2015
* First release for HZ Socho fonts
* Fix vertical typesetting features

### Version 1.011, May 5, 2015
* Correct advance width of some glyphs
* Add fullwidth LGC glyphs
* Verbose ChangeLog

### Version 1.010, May 3, 2015
* Switch distribution package type to tar.xz
* Add ChangeLog which was automatically generated
* Re-allocate already fullwidth glyph
* Update Kage engine
* Correct rotation of glyphs in subfont KanaVertP
* Correct GID assignation of subfont KanaVertP
* Widen halfwidth glyphs in subfonts KanaP and KanaVertP
* Use advance width data from GlyphWiki and internal database
* Use LGC font for proportional glyph of Celsius
* Use LGC font for proportional italic glyph of hbar
* Use Symbol font for plastic recycle symbols
* Modify halfwidth Kana glyphs

### Version 1.009, January 6, 2015
* Modify left-to-right roofed down-stroke

### Version 1.008, December 24, 2014
* Beta release
* New overlap removal routine (rasterize then re-vectorize)
* Make extra-bold font bolder

### Version 1.007, November 22, 2014
* Beta release
* Refined symbol glyphs

### Version 1.006, November 9, 2014
* Beta release
* Refined Kana glyphs

### Version 1.005, October 29, 2014
* Make strokes filled
* Workaround for build

### Version 1.004, October 26, 2014
* Beta release
* Smoothed contours
* Adjusted design
* Workaround for build on Linux

### Version 1.003, October 18, 2014
* KAGE data update
* Have narrowed line gaps.

### Version 1.002, February 7, 2014
* KAGE data update
* Search glyph parts from all versions during build
* Have unified font family name
* Use newlines into font metadata

### Version 1.001, February 2, 2014
* Have fixed vertical glyph issue
* Have fixed subfamily name for extra-bold weight
* Have added metadata

### Version 1.000, January 28, 2014
* First release
