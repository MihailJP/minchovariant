TARGETS=lgc1.otf lgc3.otf lgc5.otf lgc7.otf lgc9.otf \
	lgc1f.otf lgc3f.otf lgc5f.otf lgc7f.otf lgc9f.otf \
	lgc1t.otf lgc3t.otf lgc5t.otf lgc7t.otf lgc9t.otf \
	lgc1q.otf lgc3q.otf lgc5q.otf lgc7q.otf lgc9q.otf
SRCDIRS=Medium.sfdir/font.props Bold.sfdir/font.props
FIXEDDIRS=Fixed-Medium.sfdir/font.props Fixed-Bold.sfdir/font.props
THIRDWIDTH=Third-Medium.sfd Third-Bold.sfd
QUARTERWIDTH=Quarter-Medium.sfd Quarter-Bold.sfd

.PHONY: all clean
all: $(TARGETS)

Third-Medium.sfd: Fixed-Medium.sfdir/font.props
	fontforge ./narrow.py Fixed-Medium.sfdir $@ 0.666667
Third-Bold.sfd: Fixed-Bold.sfdir/font.props
	fontforge ./narrow.py Fixed-Bold.sfdir $@ 0.666667
Quarter-Medium.sfd: Fixed-Medium.sfdir/font.props
	fontforge ./narrow.py Fixed-Medium.sfdir $@ 0.5
Quarter-Bold.sfd: Fixed-Bold.sfdir/font.props
	fontforge ./narrow.py Fixed-Bold.sfdir $@ 0.5

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
lgc1f.otf: $(FIXEDDIRS)
	fontforge ./interpol.py $@ -0.5 Fixed-Medium.sfdir Fixed-Bold.sfdir
lgc3f.otf: $(FIXEDDIRS)
	fontforge ./interpol.py $@ -0.3 Fixed-Medium.sfdir Fixed-Bold.sfdir
lgc5f.otf: $(FIXEDDIRS)
	fontforge ./interpol.py $@ 0 Fixed-Medium.sfdir Fixed-Bold.sfdir
lgc7f.otf: $(FIXEDDIRS)
	fontforge ./interpol.py $@ 0.4 Fixed-Medium.sfdir Fixed-Bold.sfdir
lgc9f.otf: $(FIXEDDIRS)
	fontforge ./interpol.py $@ 0.8 Fixed-Medium.sfdir Fixed-Bold.sfdir
lgc1t.otf: $(THIRDWIDTH)
	fontforge ./interpol.py $@ -0.5 Third-Medium.sfd Third-Bold.sfd
lgc3t.otf: $(THIRDWIDTH)
	fontforge ./interpol.py $@ -0.3 Third-Medium.sfd Third-Bold.sfd
lgc5t.otf: $(THIRDWIDTH)
	fontforge ./interpol.py $@ 0 Third-Medium.sfd Third-Bold.sfd
lgc7t.otf: $(THIRDWIDTH)
	fontforge ./interpol.py $@ 0.4 Third-Medium.sfd Third-Bold.sfd
lgc9t.otf: $(THIRDWIDTH)
	fontforge ./interpol.py $@ 0.8 Third-Medium.sfd Third-Bold.sfd
lgc1q.otf: $(QUARTERWIDTH)
	fontforge ./interpol.py $@ -0.5 Quarter-Medium.sfd Quarter-Bold.sfd
lgc3q.otf: $(QUARTERWIDTH)
	fontforge ./interpol.py $@ -0.3 Quarter-Medium.sfd Quarter-Bold.sfd
lgc5q.otf: $(QUARTERWIDTH)
	fontforge ./interpol.py $@ 0 Quarter-Medium.sfd Quarter-Bold.sfd
lgc7q.otf: $(QUARTERWIDTH)
	fontforge ./interpol.py $@ 0.4 Quarter-Medium.sfd Quarter-Bold.sfd
lgc9q.otf: $(QUARTERWIDTH)
	fontforge ./interpol.py $@ 0.8 Quarter-Medium.sfd Quarter-Bold.sfd

clean:
	-rm $(TARGETS)
