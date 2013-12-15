TARGETS=lgc1.otf lgc3.otf lgc5.otf lgc7.otf lgc9.otf \
	lgc1i.otf lgc3i.otf lgc5i.otf lgc7i.otf lgc9i.otf
SRCDIRS=Medium.sfdir/font.props Bold.sfdir/font.props
ITALICDIRS=Medium-Italic.sfdir/font.props Bold-Italic.sfdir/font.props

.PHONY: all clean
all: $(TARGETS)

lgc1.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ -0.5 Medium.sfdir Bold.sfdir
lgc3.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ -0.3 Medium.sfdir Bold.sfdir
lgc5.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ 0 Medium.sfdir Bold.sfdir
lgc7.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ 0.4 Medium.sfdir Bold.sfdir
lgc9.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ 0.8 Medium.sfdir Bold.sfdir
lgc1i.otf: $(ITALICDIRS)
	fontforge ./interpol.py $@ -0.5 Medium-Italic.sfdir Bold-Italic.sfdir
lgc3i.otf: $(ITALICDIRS)
	fontforge ./interpol.py $@ -0.3 Medium-Italic.sfdir Bold-Italic.sfdir
lgc5i.otf: $(ITALICDIRS)
	fontforge ./interpol.py $@ 0 Medium-Italic.sfdir Bold-Italic.sfdir
lgc7i.otf: $(ITALICDIRS)
	fontforge ./interpol.py $@ 0.4 Medium-Italic.sfdir Bold-Italic.sfdir
lgc9i.otf: $(ITALICDIRS)
	fontforge ./interpol.py $@ 0.8 Medium-Italic.sfdir Bold-Italic.sfdir

clean:
	-rm $(TARGETS)
