/^Move(400, -400)/d
/^Move(0, 50)/d
/^SetWidth(1000)/i Scale(20)
/^foreach(sort(keys %buhin)){/,/^}/c open GLYPHLIST, "../jisx0208-level-1.txt" or die "Cannot read the glyph list";\
while (<GLYPHLIST>) {\
	chomp; my $name = $_;\
	(my $target = $name) =~ s/^[uU]0*//g; # delete zero for the beginning\
	$target{$target} = $name;\
}\
close GLYPHLIST;
