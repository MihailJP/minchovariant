def fontVersion
	"1.300"
end

def fontCopyrightOf(fontname)
	kage     = "Created by KAGE system. (http://fonts.jp/)"
	symbol   = "Some symbol glyphs are from George Doulos' Symbola font."
	aj16Sans = "AJ1-6 sans-serif glyphs from M+ fonts."
	merge    = "Merged by MihailJP, May 2019."
	if fontname =~ /Mincho|Gothic/i then
		"#{kage}\n" \
		"Alphabet glyphs by Andrey V. Panov (C) 2005 All rights reserved.\n" \
		"#{symbol}\n#{aj16Sans}\n#{merge}"
	elsif fontname =~ /Socho/i then
		"#{kage}\n" \
		"Latin alphabet glyphs Copyright (c) 2010 Barry Schwartz.\n" \
		"Greek, Cyrillic and " \
		"#{symbol[0].upcase}#{symbol[1..-1]}\n#{aj16Sans}\n#{merge}"
	else
		"#{kage}"
	end
end

def fontLicenseOf(fontname)
	if fontname =~ /Mincho|Gothic/i then
		"X11 License with exception: "
		"As a special exception, if you create a document which uses these fonts, " \
		"and embed these fonts or unaltered portions of these fonts into the " \
		"document, these fonts does not by itself cause the resulting document to " \
		"be covered by the X11 License. This exception does not however " \
		"invalidate any other reasons why the document might be covered by the " \
		"X11 License. If you modify these fonts, you may extend this exception to " \
		"your version of the fonts, but you are not obligated to do so. If you do " \
		"not wish to do so, delete this exception statement from your version."
	elsif fontname =~ /Socho/i then
		"This font is distributed under the terms of MIT License."
	else
		"The glyphs registered at the GlyphWiki, as well as the articles, can be " \
		"freely used by anyone. Reuse of this data, such as reproduction or " \
		"modification of the glyps, is permitted. The are no specific restrictions " \
		"with regards to displaying the author's name. Reuse of GlyphWiki data as " \
		"the basis for a new font, or direct usage of fonts and glyphs copied from " \
		"GlyphWiki in published work is allowed. GlyphWiki does not hold copyright " \
		"on any citations used throughout GlyphWiki articles. Please consult their " \
		"respective licences when reusing such content."
	end
end
