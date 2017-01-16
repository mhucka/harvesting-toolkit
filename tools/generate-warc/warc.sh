#!/bin/sh

# This script is a one-liner that configures wget to create a compressed warc archive.
# use it like so:
# ./warc.sh [filename] [url-to-warc]
#
# so as an example:
# ./warc.sh DAFD2E80-965F-4989-8A77-843DE716D899  http://www.eia.gov/electricity/data/eia412/
#
# It's so basic that you can skipt this script altogether if you like, and just type:
# wget --warc-file [filename] [url-to-warc]
wget --warc-file $1 $2