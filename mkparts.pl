#!/usr/bin/perl

while (<>) {
	chomp;
	my $currLine = $_;
	$rplFlag = (($rplLine = $currLine) =~ s/^ (\S+) *\| \S+ *\| (\S+) *$/$1\t$2/);
	$rplLine =~ s/\@\d+//g;
	my @rplLine = split(/\t/, $rplLine);
	my @rplRecord = split(/\$/, $rplLine[1]);
	my @rplRecordNew;
	foreach (@rplRecord) {
		my @rplField = split(/:/, $_);
		push (@rplRecordNew, join(':', ($rplField[0] == 99) ? @rplField[0..7] : @rplField));
	}
	$rplLine[1] = join('$', @rplRecordNew);
	$rplLine = join("\t", @rplLine);
	print $rplLine, "\n" if ($rplFlag);
}
