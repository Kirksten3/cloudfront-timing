request=$1
search_term=$2
LOGFILE=$3


#printf "Request: ${request}, search_term: ${search_term}, log: ${LOGFILE}\n"

count=0
while true
do
    result=`eval $request`
        
    grep_cmd=$(grep "${search_term}" ${LOGFILE})

    if [ "$grep_cmd" != "" ]
    then
        break;
    fi

    count=$((count++))
    sleep 15s
done

printf "\nTook $((($count+1) * 15)) seconds to deploy.\n" > ${LOGFILE}
