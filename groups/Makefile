DOWNLOADABLES=_HALFWIDTH _NONSPACING _NONSPACING_FULL _NONSPACING_HALF
TARGETS=cidalias.txt HALFWIDTH.txt NONSPACING.txt \
NONSPACING_FULL.txt NONSPACING_HALF.txt

.PHONY: all fetch clean distclean
all: $(TARGETS)
fetch: $(DOWNLOADABLES)

GNAMEFILTER=grep -h 'class="thumb"' $^ | ruby -p -e '$$_.gsub!(/<.+?>/,"")'

.DELETE_ON_ERROR: $(DOWNLOADABLES) $(TARGETS)

../cidalias.txt:
	cd ..; $(MAKE) cidalias.txt

cidalias.txt: ../cidalias.txt
	cat $^ | cut -f 1 > $@

_HALFWIDTH:
	wget --no-check-certificate -O $@ https://glyphwiki.org/wiki/Group:HalfwidthGlyphs
HALFWIDTH.txt: _HALFWIDTH ../halfwidth.sed
	$(GNAMEFILTER) | sed -f ../halfwidth.sed > $@

_NONSPACING_FULL:
	wget --no-check-certificate -O $@ https://glyphwiki.org/wiki/Group:NonSpacingGlyphs
NONSPACING_FULL.txt: _NONSPACING_FULL
	$(GNAMEFILTER) > $@

_NONSPACING_HALF:
	wget --no-check-certificate -O $@ https://glyphwiki.org/wiki/Group:NonSpacingGlyphs-Halfwidth
NONSPACING_HALF.txt: _NONSPACING_HALF
	$(GNAMEFILTER) > $@

_NONSPACING:
	wget --no-check-certificate -O $@ https://glyphwiki.org/wiki/Group:NonSpacingGlyphs-Fullwidth
NONSPACING.txt: _NONSPACING_FULL _NONSPACING_HALF _NONSPACING
	$(GNAMEFILTER) > $@

clean:
	rm -f $(TARGETS)
distclean: clean
	rm -f $(DOWNLOADABLES)
