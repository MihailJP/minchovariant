#!/usr/bin/bash

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
for iter in $(seq 1 5); do
	# Rasterize then trace
	d8 --single-threaded ./makeglyph.js -- u$1 $KAGE $2 $3 | \
	magick convert - -background white -flatten -alpha off bmp:- | \
	potrace -s - -o build/$1.svg

	# Verify
	if grep "<path" build/$1.svg > /dev/null; then
		exit 0
	elif grep "^u0020 " build/$1.kage > /dev/null; then
		exit 0
	fi

	# If fail, retry
	sleep $((3 + RANDOM % 7))
done

# Enough tries
cleanup_and_abend $1
