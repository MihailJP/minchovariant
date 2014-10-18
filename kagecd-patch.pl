my $urokoOcc = 0;
my $urokoL = 0;
my $cr = '';
while (<>) {
	$cr = "\r" if (/\r$/);
	if (/\/\/UROKO/) {
		++$urokoOcc;
		$urokoL = 0;
		print;
	} elsif (($urokoOcc == 1 or $urokoOcc == 2) and $urokoL == 1) {
		print;
		print "          var urokoScale = (kage.kMinWidthU / kage.kMinWidthY - 1.0) / 4.0 + 1.0;$cr";
	} elsif ($urokoOcc == 1 and $urokoL == 4) {
		print "          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale, y2);$cr";
	} elsif ($urokoOcc == 1 and $urokoL == 5) {
		print "          poly.push(x2 - kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - kage.kAdjustUrokoY[opt2] * urokoScale);$cr";
	} elsif ($urokoOcc == 2 and $urokoL == 4) {
		print "          poly.push(x2 - Math.cos(rad) * kage.kAdjustUrokoX[opt2] * urokoScale, y2 - Math.sin(rad) * kage.kAdjustUrokoX[opt2] * urokoScale);$cr";
	} elsif ($urokoOcc == 2 and $urokoL == 5) {
		print "          poly.push(x2 - Math.cos(rad) * kage.kAdjustUrokoX[opt2] * urokoScale / 2 + Math.sin(rad) * kage.kAdjustUrokoX[opt2] * urokoScale / 2, y2 - Math.sin(rad) * kage.kAdjustUrokoY[opt2] * urokoScale - Math.cos(rad) * kage.kAdjustUrokoY[opt2] * urokoScale);$cr";
	} else {
		print;
	}
	++$urokoL;
}
