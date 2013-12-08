TARGETS=lgc1.otf lgc3.otf lgc5.otf lgc7.otf lgc9.otf
SRCDIRS=Medium.sfdir/font.props Bold.sfdir/font.props

.PHONY: all clean
all: $(TARGETS)

lgc1.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ -0.5
lgc3.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ -0.3
lgc5.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ 0
lgc7.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ 0.4
lgc9.otf: $(SRCDIRS)
	fontforge ./interpol.py $@ 0.8

clean:
	-rm $(TARGETS)
