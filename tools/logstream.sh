# each micro-service writes events to log files
# write stream processors (data pipeline)
#  distinct exception name
#  total number of requests
#  latency histograms
#
# a common pattern
#  filter log files
#  filter on datetime
#  filter on event
#  custom filter
#  extract metrics
#  build histogram, percentiles


GREP=zgrep

logdir="."

# one log file per day
# base name of log file is
fbase="microservice-name.log"
fsep="."
fday=3

# filter log files by dates with regex
date_regex="2019-04-2[4-8]"
date_regex="2019-05-2[4-8]"
date_regex="2019-06-1[6-9]"
date_regex="2019-0[456]-??"

logfiles="$(ls ${logdir} | zgrep ${fbase}.${date_regex}* | cut -d. -f3)"

for fname in $logfiles; do
  day=$(echo $fname | cut -d. -f3)
  echo $fname $day
done

# create the stream partitions

cat $fname

# filter time
date_regex="2019-06-1[6-9]"
time_regex="0[0-6]:??:??"
| zgrep "$day_regex $time_regex"

# filter event
| zgrep "INFO  MicroServiceName ID Event"

# custom filter
| zgrep "d7017931-0d3d-4f7a-885f-728892da8897"

# aggregate count
| wc -l

# project field and get value
# key1=value1,key2=value2
| cut -d, -f10 | cut -d= -f2

# print the result
| awk '{printf "%s %s %s %s", $fname, $day, $hour, $0}'

# split on spaces
| tr ' ' '\n'

# print a histogram
| awk '
BEGIN {
    bin_width=250.0;
}
{
    bin=int(($1-0.0001)/bin_width);
    if( bin in hist) {
        hist[bin]+=1
    } else {
        hist[bin]=1
    }
}
END {
    for (h in hist)
        printf "%2.2f  ->  %i \n", h*bin_width, hist[h]
}
'
