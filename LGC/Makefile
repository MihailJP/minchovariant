TARGETS=lgc1.otf lgc3.otf lgc5.otf lgc7.otf lgc9.otf \
	lgc1f.otf lgc3f.otf lgc5f.otf lgc7f.otf lgc9f.otf \
	lgc1r.otf lgc3r.otf lgc5r.otf lgc7r.otf lgc9r.otf \
	lgc1rf.otf lgc3rf.otf lgc5rf.otf lgc7rf.otf lgc9rf.otf
SRCDIRS=Medium.sfdir/font.props Bold.sfdir/font.props
FIXEDDIRS=Fixed-Medium.sfdir/font.props Fixed-Bold.sfdir/font.props
ROTATED=Rotated-Medium.sfd Rotated-Bold.sfd
ROTATEDFIXED=Rotated-Fixed-Medium.sfd Rotated-Fixed-Bold.sfd

.PHONY: all clean
all: $(TARGETS)

Rotated-Medium.sfd: Medium.sfdir/font.props
	fontforge ./rotate.py Medium.sfdir $@
Rotated-Bold.sfd: Bold.sfdir/font.props
	fontforge ./rotate.py Bold.sfdir $@
Rotated-Fixed-Medium.sfd: Fixed-Medium.sfdir/font.props
	fontforge ./rotate.py Fixed-Medium.sfdir $@
Rotated-Fixed-Bold.sfd: Fixed-Bold.sfdir/font.props
	fontforge ./rotate.py Fixed-Bold.sfdir $@

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
lgc1r.otf: $(ROTATED)
	fontforge ./interpol.py $@ -0.5 Rotated-Medium.sfd Rotated-Bold.sfd
lgc3r.otf: $(ROTATED)
	fontforge ./interpol.py $@ -0.3 Rotated-Medium.sfd Rotated-Bold.sfd
lgc5r.otf: $(ROTATED)
	fontforge ./interpol.py $@ 0 Rotated-Medium.sfd Rotated-Bold.sfd
lgc7r.otf: $(ROTATED)
	fontforge ./interpol.py $@ 0.4 Rotated-Medium.sfd Rotated-Bold.sfd
lgc9r.otf: $(ROTATED)
	fontforge ./interpol.py $@ 0.8 Rotated-Medium.sfd Rotated-Bold.sfd
lgc1rf.otf: $(ROTATEDFIXED)
	fontforge ./interpol.py $@ -0.5 Rotated-Fixed-Medium.sfd Rotated-Fixed-Bold.sfd
lgc3rf.otf: $(ROTATEDFIXED)
	fontforge ./interpol.py $@ -0.3 Rotated-Fixed-Medium.sfd Rotated-Fixed-Bold.sfd
lgc5rf.otf: $(ROTATEDFIXED)
	fontforge ./interpol.py $@ 0 Rotated-Fixed-Medium.sfd Rotated-Fixed-Bold.sfd
lgc7rf.otf: $(ROTATEDFIXED)
	fontforge ./interpol.py $@ 0.4 Rotated-Fixed-Medium.sfd Rotated-Fixed-Bold.sfd
lgc9rf.otf: $(ROTATEDFIXED)
	fontforge ./interpol.py $@ 0.8 Rotated-Fixed-Medium.sfd Rotated-Fixed-Bold.sfd

clean:
	-rm $(TARGETS)
