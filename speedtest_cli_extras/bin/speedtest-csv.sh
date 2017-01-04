#!/usr/bin/env bash
#speedtest-csv
### Usage:
###  speedtest-csv [options]
###
### Options:
###  --debug           Output extra debug information
###  --header          Display field names (only)
###  --help            This help
###  --last            Use most recent stats, if available
###                    (avoids calling `speedtest-cli`)
###  --quote <str>     Quote fields using <str> (default: none)
###  --sep <str>       Separate fields using <str> (default ';')
###  --share           Generate and provide a URL to the speedtest.net
###                    share results image (default)
###  --no-share        Disable --share
###  --header-units    Specify units in header rather than with values
###  --no-header-units Disable --header-units (default)
###  --standardize     Standardize units and number formats
###  --no-standardize  Disable --standardize (default)
###  --version         Display version
###
### Any other options are passed to speedtest-cli as is.
###
### Example:
###  speedtest-csv --sep '\t' --standardize
###  speedtest-csv --sep '\t' --header-units
###  speedtest-csv --sep '\t' --header
###
### Copyright: 2014-2016 Henrik Bengtsson
### License: GPL (>= 2.1) [https://www.gnu.org/licenses/gpl.html]

# Character for separating values
# (commas are not safe, because some servers return speeds with commas)
sep=";"

# Temporary file holding speedtest-cli output
user=$USER
if test -z $user; then
  user=$USERNAME
fi
log=/tmp/$user/speedtest-csv.log

# Local functions
function str_extract() {
 pattern=$1
 # Extract
 res=`grep "$pattern" $log | sed "s/$pattern//g"`
 # Drop trailing ...
 res=`echo $res | sed 's/[.][.][.]//g'`
 # Trim
 res=`echo $res | sed 's/^ *//g' | sed 's/ *$//g'`
 echo $res
}

# Display header?
if test "$1" = "--header"; then
  start="start"
  stop="stop"
  from="from"
  from_ip="from_ip"
  server="server"
  server_dist="server_dist"
  server_ping="server_ping"
  download="download"
  upload="upload"
  share_url="share_url"
else
  mkdir -p `dirname $log`

  start=`date +"%Y-%m-%d %H:%M:%S"`

  if test -n "$SPEEDTEST_CSV_SKIP" && test -f "$log"; then
    # Reuse existing results (useful for debugging)
    1>&2 echo "** Reusing existing results: $log"
  else
    # Query Speedtest
    /usr/local/bin/speedtest-cli --share > $log
  fi

  stop=`date +"%Y-%m-%d %H:%M:%S"`

  # Parse
  from=`str_extract "Testing from "`
  from_ip=`echo $from | sed 's/.*(//g' | sed 's/).*//g'`
  from=`echo $from | sed 's/ (.*//g'`

  server=`str_extract "Hosted by "`
  server_ping=`echo $server | sed 's/.*: //g'`
  server=`echo $server | sed 's/: .*//g'`
  server_dist=`echo $server | sed 's/.*\\[//g' | sed 's/\\].*//g'`
  server=`echo $server | sed 's/ \\[.*//g'`

  download=`str_extract "Download: "`
  upload=`str_extract "Upload: "`
  share_url=`str_extract "Share results: "`
fi

# Standardize units?
if test "$1" = "--standardize"; then
  download=`echo $download | sed 's/Mbits/Mbit/'`
  upload=`echo $upload | sed 's/Mbits/Mbit/'`
fi

# Send to IFTTT
secret_key="SECRET_KEY"
value1=`echo $server_ping | cut -d" " -f1`
value2=`echo $download | cut -d" " -f1`
value3=`echo $upload | cut -d" " -f1`
json="{\"value1\":\"${value1}\",\"value2\":\"${value2}\",\"value3\":\"${value3}\"}"
curl -X POST -H "Content-Type: application/json" -d "${json}" https://maker.ifttt.com/trigger/speedtest/with/key/cJ-suGaqKnru9izr3qfo3A

echo "Json = ${json}"

# will I need to include the key within {} brackets or should I elimiate it.
