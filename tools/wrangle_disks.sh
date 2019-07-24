#!/bin/bash
#
# aggregates a list of filesystems (disks)


function sum_disks() {
    # input
    # transformer12:/,54G,14%;/data,1.0T,53%;:32:32768
    # output
    # transformer12:2:1054:53%:32:32768

    header="hostname:disks_total:disk_space_total_gb:disk_max_util:cpu_cores:memory_mb"
    echo $header
    awk '
    BEGIN { FS=":" }
    {
        disks_total = split($2,disks,";");
        disk_space_total = 0
        disk_max_util = 0
        for (ix in disks) {
            disk_info_len = split(disks[ix],disk_info,",")
            if (disk_info_len != 3) {
                disks_total -= 1
                continue
            }

            disk_space = substr(disk_info[2], 1, length(disk_info[2])-1)
            space_unit = substr(disk_info[2], length(disk_info[2]), 1)
            if (space_unit == "T") {
                disk_space_total += disk_space * 1000
            }
            else if (space_unit == "G") {
                disk_space_total += disk_space
            }

            disk_util = substr(disk_info[3], 1, length(disk_info[3])-1) 
            if (disk_max_util < disk_util) {
                disk_max_util = disk_util
            }
        }
        printf "%s:%s:%s:%s:%s:%s\n", $1, disks_total, disk_space_total, disk_max_util, $3, $4
    }
    '
}


system_summary_csv="$1"

# remove the header line
ignore_pattern="/hostname:filesystem,fs_size,fs_utilized;:cpu_cores:memory_mb/d"

cat $system_summary_csv \
     | sed "$ignore_pattern" \
     | sum_disks

