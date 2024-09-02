#!/usr/bin/bash

TRIES=5
WEIGHT=$3
cd ..

function cleanup_and_abend () {
	rm -f build/$1.svg
	exit 1
}

trap "cleanup_and_abend $1" SIGHUP
trap "cleanup_and_abend $1" SIGINT
trap "cleanup_and_abend $1" SIGQUIT
trap "cleanup_and_abend $1" SIGTERM

KAGE=$(<build/$1.kage)
for iter in $(seq 1 $TRIES); do
	# Rasterize then trace
	../js ./makeglyph.js -- u$1 "$KAGE" $2 $WEIGHT > build/$1_raw.svg
	../js ./makeglyph.js -- u$1 "$KAGE" $2 $WEIGHT | \
	sed -e "s/viewBox=\"[^\"]*\"/viewBox=\"-100 -100 400 400\"/" \
		-e "s/width=\"[^\"]*\"/width=\"400\"/" \
		-e "s/height=\"[^\"]*\"/height=\"400\"/" | \
	magick convert - -background white -flatten -alpha off bmp:- | \
	potrace -s - | \
	sed -e "s/viewBox=\"[^\"]*\"/viewBox=\"0 0 200 200\"/" \
		-e "s/width=\"[^\"]*\"/width=\"200\"/" \
		-e "s/height=\"[^\"]*\"/height=\"200\"/" \
		-e "s/translate([^)]*)/translate(-100,300)/" > build/$1.svg
	exit

	# Verify
	if grep "height=\"200." build/$1.svg > /dev/null; then
		if grep "<path" build/$1.svg > /dev/null; then
			exit 0
		elif grep "^u0020 " build/$1.kage > /dev/null; then
			exit 0
		elif [ $(($WEIGHT % 100)) = 1 ]; then
			echo "*** $1: empty glyph detected (too thin?) ***" 1>&2
			WEIGHT=$((WEIGHT + 2))
			echo "*** $1: use weight $WEIGHT ***" 1>&2
		else
			echo "*** $1: empty glyph detected ***" 1>&2
		fi
	else
		echo "*** $1: height is not 200 ***" 1>&2
		grep "height=\"" build/$1.svg 1>&2
	fi

	# If fail, retry
	if [ x$iter = x$TRIES ]; then
		echo "*** $1: enough tries, aborting ***" 1>&2
	else
		echo "*** $1: retrying ***" 1>&2
		sleep $((3 + RANDOM % 7))
	fi
done

# Enough tries
cleanup_and_abend $1
