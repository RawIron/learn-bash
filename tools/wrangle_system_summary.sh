#!/bin/bash
#
# parse the output of fabric target "pull_os_resources"
# output is CSV formatted

: <<'INPUT_EXAMPLE'
Config loaded
Loaded transformer
[transformer12-prod-shard4-eu.zephyrus.io] Executing task 'pull_os_resources'
FS:      /: 20G 19%
FS: /data1: 339G 6%
FS: /data2: 441G 8%
FS: /data3: 141G 3%
CPU Cores:  24
Memory:     65536 MB
[transformer14-prod-shard4-eu.zephyrus.io] Executing task 'pull_os_resources'
FS:      /: 20G 18%
FS: /data1: 339G 4%
CPU Cores:  24
Memory:     65536 MB

Done.
Disconnecting from transformer14... done.
Disconnecting from transformer12... done.
INPUT_EXAMPLE


system_summary_file="$1"
IN_FS=":"
OUT_FS=":"

# Filter hostname and hardware facts

header="hostname:filesystem,fs_size,fs_utilized;:cpu_cores:memory_mb"
hostname_pattern='\[[a-z0-9]*-prod-[a-z0-9]*-[a-z]*.zephyrus.io\]'
storage_pattern='FS:'
cpu_pattern='CPU Cores:'
memory_pattern='Memory'

function process_lines() {
    # Join lines with delimiter ":"
    # Remove "Executing task ..."
    # Remove header names
    echo $header
    while read -r line; do
        if [[ "$line" == ${hostname_pattern}* ]]; then
            echo ${line} \
            | awk 'BEGIN {FS=" "} {printf "%s:", $1}'
        elif [[ "$line" == ${storage_pattern}* ]]; then
            echo ${line} \
            | awk 'BEGIN {FS=":"} {split($3,a," "); printf "%s,%s,%s;", $2,a[1],a[2]}'
        elif [[ "$line" == ${cpu_pattern}* ]]; then
            echo ${line} \
            | awk 'BEGIN {FS=":"} {printf ":%s:", $2}'
        elif [[ "$line" == ${memory_pattern}* ]]; then
            echo $line \
            | awk 'BEGIN {FS=":"} {split($2,a," "); printf "%s\n", a[1]}'
        fi
    done
}

ignore_pattern="/joiner9-prod-shard2-eu.zephyrus.io/d"
data_pattern="/$hostname_pattern/p; /$storage_pattern/p; /$cpu_pattern/p; /$memory_pattern/p"

cat $system_summary_file \
     | sed -n "$data_pattern" \
     | sed "$ignore_pattern" \
     | process_lines \
     | tr -d '[] ' \

