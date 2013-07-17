/^Move(400, -400)/d
/^Move(0, 50)/d
/^RemoveOverlap()/d
/^Simplify()/d
/^SetWidth(1000)/i Scale(20)
/^Scale(500)/a CanonicalContours()\
CanonicalStart()\
FindIntersections()
s/"Generate(\(.*\)\.ttf.*)/"Save(\1.sfd\\")/
/^foreach(sort(keys %buhin)){/,/^}/c open GLYPHLIST, "../glyphs.txt" or die "Cannot read the glyph list";\
while (<GLYPHLIST>) {\
	chomp; my $name = $_;\
	(my $target = $name) =~ s/^[uU]0*//g; # delete zero for the beginning\
	$target{$target} = $name;\
}\
close GLYPHLIST;
/^  while(\$buffer =~ m\/\\\$99/c \ \ while($buffer =~ m/\\\$99:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^\\\$:]*)(?::[^\\\$]*)?/gc){