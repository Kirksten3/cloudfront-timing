#!/bin/bash
log="request.log"
search_term=""

function main {
    printf "Enter an url to visit: "
    read url

    printf "Do you want to use a different geolocation? (y/n): "
    read choice

    if [ "${choice}" == "y" -o "${choice}" == "Y" ]
    then
        printf "Enter a different IP address to use: "
        read ip
        request="curl -i --header \"X-Forwarded-For: ${ip}\" \"${url}\" > ${log}"
        printf "\n${request}\n\n"
    else
        request="curl -i \"${url}\" > ${log}"
        printf "\n${request}\n\n"
    fi
    
    count=0
    while true
    do
        result=`eval $request`
        
        grep_cmd=$(grep "${search_term}" ${log})

        if [ "$grep_cmd" != "" ]
        then
            break;
        fi

        count=$((count++))
        sleep 15s
    done

    printf "\nTook $((($count+1) * 15)) seconds to deploy.\n"
}

main
