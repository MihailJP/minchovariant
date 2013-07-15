#!/usr/bin/perl

while (<>) {
	my $currLine = $_;
	my $rplFlag = ((my $rplLine = $currLine) =~ s/^ ([uU][0-9a-fA-F]{4,}\S*) *\| \S+ *\| (\S+) *$/$1\t$2/);
	my $glyphName = $1;
	if ($rplFlag) {
		if ($glyphName eq "u6c38") {
			print $rplLine;
		}
	} else {
		$rplFlag = (($rplLine = $currLine) =~ s/^ (\S+) *\| \S+ *\| (\S+) *$/$1\t$2/);
		print $rplLine if ($rplFlag);
	}
}
