HZ Mincho OpenType font
=======================
This is a free/libre OpenType CID-keyed Japanese font
derived from [GlyphWiki](http://en.glyphwiki.org/wiki/GlyphWiki:MainPage)'s
CJK data, with weight variations.

Latin, Greek and Cyrillic glyphs are not derived from GlyphWiki but from
[Computer Modern Unicode](http://canopus.iacp.dvo.ru/~panov/cm-unicode/)
because GlyphWiki's [Kage engine](http://fonts.jp/kage/index.en.html) is
intended for Chinese characters and not good at LGC.

Some symbols, including CIDs 16314, 16323, 16324 and 16325,
came from [Symbola](http://users.teilar.gr/~g1951d/) font.

Sans-serif Katakana and Figures, namely CIDs 20473 to 20496 and
20513 to 20522 are from
[M+ 2m](http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/) font.

Build-time dependencies
-----------------------
These softwares are required in order to build the font.
Of course no special softwares required after once the font is built.

KAGE engine is referred as a Git submodule. Do not forget
`git submodule init && git submodule update` before you build.

* [Fontforge][1] with Python and native script feature enabled
* [Adobe Font Development Kit for OpenType][2]
* JavaScript
* [Perl][3]
* [Ruby][4]
* [SQLite3][5]
* [Inkscape][6]
* [ImageMagick][7]
* [Potrace][8]

[1]: http://fontforge.github.io/
[2]: http://www.adobe.com/devnet/opentype/afdko.html
[3]: http://www.perl.org/
[4]: https://www.ruby-lang.org/
[5]: http://www.sqlite.org/
[6]: https://inkscape.org/ja/
[7]: http://www.imagemagick.org/
[8]: http://potrace.sourceforge.net/

Authors
-------
* Merged by MihailJP <mihailjp@gmail.com>.
* GlyphWiki contributors
  * Includes MihailJP
* Andrei V. Panov (Computer Modern Unicode)
  * Some additional glyphs are composed by MihailJP
* George Doulos (Symbola)
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

### Symbola font, in lieu of a licence ###
_See http://users.teilar.gr/~g1951d/._

Symbola font is free for any use.

> Fonts in this site are offered free for any use; they may be installed,
> embedded, opened, edited, modified, regenerated, posted, packaged and
> redistributed. George Douros

### License of M+ font ###
_See http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/index.html#license._

M+ font is free for any use.

> These fonts are free software.
> 
> Unlimited permission is granted to use, copy, and distribute them,
> with or without modification, either commercially or noncommercially.
> 
> **THESE FONTS ARE PROVIDED "AS IS" WITHOUT WARRANTY.**

Version History
---------------

### Version 1.101, June 1, 2015
* Fix style names (issue on Windows)

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
