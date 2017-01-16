### Generating Warc files:

This script (./warc.sh) is a one-liner that configures wget to create a compressed warc web archive.
use it like so:
```./warc.sh [filename] [url-to-warc]```

As an example:
```./warc.sh DAFD2E80-965F-4989-8A77-843DE716D899  http://www.eia.gov/electricity/data/eia412/```

will create a file called DAFD2E80-965F-4989-8A77-843DE716D899.warc.gz

It's so basic that you can skipt this script altogether if you like, and just type:
wget --warc-file [filename] [url-to-warc]

Happy Webarchiveing!