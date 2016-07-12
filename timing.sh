#!/bin/bash

# grep search term must be manually set
search_term="mail"

function run_loop {
    run_idx=0
    for i in "${request_list[@]}"
    do
        printf "Running: ${i}\n"
        # execute run_test.sh and pass command line arguments to it
        # commands with & at the end are given a separate subprocess to run in
        ./run_test.sh "${i}" "${search_term}" "${log_list[$run_idx]}" &
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
    # iterate through $path_list, each element in array is i
    for i in "${path_list[@]}"
    do
        if [ "${choice}" == "y" -o "${choice}" == "Y" ]
        then
            # request_list array passed individually to ./run_test.sh
            request_list[$idx]="curl -i --header \"X-Forwarded-For: ${ip}\" \"${i}\" > ${i}.log"
        else
            request_list[$idx]="curl -i \"${i}\" > ${i}.log"
        fi
        
        # list of log paths needed for grep in ./run_test.sh
        log_list[$idx]="${i}.log"
        idx=$((idx+1))
    done
    
    echo "${result_list[@]}" 
    run_loop
}

function get_sites_from_file {
    printf "Enter a file path to read urls from: "
    read path

    array_idx=0
    
    # reads line by line, stores result into $line
    while read -r line
    do
        path_list[$array_idx]=$line
        printf "Index: ${array_idx}, line: ${line}\n"
        array_idx=$((array_idx+1))
    # $path is read from, passed as file input through <
    done < "$path"
    
    # print path_list array
    echo "${path_list[@]}"
}

get_sites_from_file
main
