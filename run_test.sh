# $1, $2, $3 all are command line arguments
request=$1
search_term=$2
LOGFILE=$3

count=0
while true
do
    # executes the request
    result=`eval $request`
       
    # executes the grep command 
    # stores result of grep in $grep_cmd
    grep_cmd=$(grep "${search_term}" ${LOGFILE})

    # if grep returns result from search then break
    if [ "$grep_cmd" != "" ]
    then
        break;
    fi

    count=$((count++))
    sleep 15s
done

printf "Took $((($count+1) * 15)) seconds to deploy.\n" > ${LOGFILE}
