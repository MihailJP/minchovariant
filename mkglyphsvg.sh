#!/usr/bin/bash

TRIES=5
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
	d8 --single-threaded ./makeglyph.js -- u$1 "$KAGE" $2 $3 | \
	magick convert - -background white -flatten -alpha off bmp:- | \
	potrace -s - -o build/$1.svg

	# Verify
	if grep "height=\"200." build/$1.svg > /dev/null; then
		if grep "<path" build/$1.svg > /dev/null; then
			exit 0
		elif grep "^u0020 " build/$1.kage > /dev/null; then
			exit 0
		else
			echo "*** Empty glyph detected ***" 1>&2
		fi
	else
		echo "*** Height is not 200 ***" 1>&2
		grep "height=\"" build/$1.svg 1>&2
	fi

	# If fail, retry
	if [ x$iter = x$TRIES ]; then
		echo "*** Enough tries, aborting ***" 1>&2
	else
		echo "*** Retrying ***" 1>&2
		sleep $((3 + RANDOM % 7))
	fi
done

# Enough tries
cleanup_and_abend $1
