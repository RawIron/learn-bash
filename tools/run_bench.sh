#!/usr/bin/env bash


function run_index_bench() {
    # runs the benchmark and reports the result in the format
    # (threads,measurement,unit)
    # "8,127233,ms"
    local thread_count="$1"
    local log_file="$2"
    local result_pattern="Duration"
    local bench_cmd="./run_java.sh my_app.index.benchmark.IndexBenchmarkMain"

    ${bench_cmd} ${thread_count} >$log_file 2>&1
    #echo "Measured Duration is with $thread_count threads 213,222" >$log_file
    if [[ $? -eq 0 ]]; then
        echo $(grep "$result_pattern" $log_file | sed 's/,//g' | awk '{printf "%s,%s,%s", $5,$7,"ms"}')
    else
        echo ",,,"
    fi
}

function run_parse_bench() {
    # runs the benchmark and reports the result in the format
    # (threads,measurement,unit)
    # "4,466,msg/s"
    local thread_count="$1"
    local log_file="$2"
    local result_pattern="Processing Rate"
    local bench_cmd="./run_java.sh my_app.parser.benchmark.ParserBenchmarkMain -s"

    ${bench_cmd} -t ${thread_count} >$log_file 2>&1
    #echo "Processing Rate: 223" >$log_file
    if [[ $? -eq 0 ]]; then
        echo $(grep "$result_pattern" $log_file | awk '{printf "%s,%s", $3,"msg/s"}' | sed "s/^/${thread_count},/")
    else
        echo ",,,"
    fi
}


function run_dd_write_bench() {
    local test_file="$1"
    local blocks="$2"
    local log_prefix="$3"
    local result_pattern='bytes .* copied'

    log_file="${log_prefix}_ddwrite_1${iteration}.txt"
    dd if=/dev/zero of="$test_file" bs=10M count=$blocks oflag=direct >$log_file 2>&1
    echo $(grep "$result_pattern" $log_file | sed 's/,//g' | awk '{printf "%s,%s,%s", 1,$8,$9}')
}

function run_dd_read_bench() {
    local test_file="$1"
    local blocks="$2"
    local log_prefix="$3"
    local result_pattern='bytes .* copied'

    log_file="${log_prefix}_ddread_1${iteration}.txt"
    dd if="$test_file" of=/dev/null bs=10M count=$blocks iflag=direct >$log_file 2>&1
    echo $(grep "$result_pattern" $log_file | sed 's/,//g' | awk '{printf "%s,%s,%s", 1,$8,$9}')
}

function clean_dd() {
    local test_file="$1"
    rm -f "$test_file"
}


function run_threads_bench() {
    local bench_name="$1"
    local bench_cmd="$2"
    local thread_counts="$3"
    local iteration="$4"
    local log_prefix="$5"
    local log_file=""

    for thread_count in $thread_counts; do
        log_file="${log_prefix}_${bench_name}_${thread_count}${iteration}.txt"
        result=$(${bench_cmd} "$thread_count" "$log_file")
        echo "$(timestamp),${service_host},${bench_name},$result"
    done
}

function timestamp() {
    date +"%Y-%m-%d %T"
}


service_host=$(hostname)
service_id=${service_host%-*}

iterations="a b c d e f g"
core_sequence="1 2 4 8 16 24 32 40 48 56"

for iteration in $iterations; do
    run_threads_bench "index" "run_index_bench" "$core_sequence" "$iteration" "$service_id"
done

for iteration in $iterations; do
    run_threads_bench "parse" "run_parse_bench" "$core_sequence" "$iteration" "$service_id"
done


temp_dir=/data
temp_file=${temp_dir}/dd_bench_$$.tmp
blocks=20

for iteration in $iterations; do
    clean_dd "$temp_file"
    result=$(run_dd_write_bench "$temp_file" "$blocks" "$service_id")
    echo "$(timestamp),${service_host},dd_write,$result"
done

for iteration in $iterations; do
    result=$(run_dd_read_bench "$temp_file" "$blocks" "$service_id")
    echo "$(timestamp),${service_host},dd_read,$result"
done
clean_dd "$temp_file"

