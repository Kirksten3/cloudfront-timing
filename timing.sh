#!/bin/bash
search_term=""

function run_loop {
    run_idx=0
    for i in "${request_list[@]}"
    do
        printf "Running: ${i}\n"
        #./run_test.sh "${i}" "${search_term}" "${log_list[$run_idx]}"
        run_idx=$((run_idx+1))
    done
    
    wait
}

function main {

    printf "Do you want to use a different geolocation? (y/n): "
    read choice

    if [ "${choice}" == "y" -o "${choice}" == "Y" ]
    then
        printf "Enter a different IP address to use: "
        read ip
    fi
        
    idx=0
    for i in "${path_list[@]}"
    do
        if [ "${choice}" == "y" -o "${choice}" == "Y" ]
        then
            request_list[$idx]="curl -i --header \"X-Forwarded-For: ${ip}\" \"${i}\" > ${i}.log &"
        else
            request_list[$idx]="curl -i \"${i}\" > ${i}.log &"
        fi
        log_list[$idx]="${i}.log"

        #printf "\n${request_list[$idx]}\n\n"
        idx=$((idx+1))
    done
    echo "${result_list[@]}" 
    run_loop
}

function get_sites_from_file {
    if [ "$1" == "" ]
    then
        printf "Enter a file path to read urls from: "
        read path
    else
        path=$1
    fi

    array_idx=0
    while read -r line
    do
        path_list[$array_idx]=$line
        printf "Index: ${array_idx}, line: ${line}\n"
        array_idx=$((array_idx+1))
    done < "$path"
    
    echo "${path_list[@]}"
}

get_sites_from_file
main
