# $1, $2, $3 all are command line arguments
request=$1
search_term=$2
url=$3
# each file needs separate log file, use index for it
SEARCH_LOGFILE="${4}.log"
DEPLOY_LOGFILE="deploy_results.log"

printf "${url} started checking deploy at $(date +"%T")\n" >> ${DEPLOY_LOGFILE}
count=0
while true
do
    # executes the request
    result=`eval $request`
       
    # executes the grep command 
    # stores result of grep in $grep_cmd
    grep_cmd=$(grep "${search_term}" ${SEARCH_LOGFILE})

    # if grep returns result from search then break
    if [ "$grep_cmd" != "" ]
    then
        break;
    fi

    count=$((count++))
    sleep 15s
done

# clean up
`rm "${SEARCH_LOGFILE}"`

printf "${url} ended checking deploy at $(date +"%T")\n" >> ${DEPLOY_LOGFILE}
printf "${url} took $((($count+1) * 15)) seconds to deploy.\n" >> ${DEPLOY_LOGFILE}
