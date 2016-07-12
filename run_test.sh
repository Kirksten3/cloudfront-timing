# $1, $2, $3 all are command line arguments
request=$1
search_term=$2
url=$3
# each file needs separate log file, use index for it
SEARCH_LOGFILE="${4}.log"
DEPLOY_LOGFILE="deploy_results.log"

# predefined bash constant that increments each second
SECONDS=0

printf "${url} started checking publish status at $(date +"%T")\n" >> ${DEPLOY_LOGFILE}

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

    sleep 10s
done

# clean up
#`rm "${SEARCH_LOGFILE}"`

printf "${url} ended checking publish status at $(date +"%T")\n" >> ${DEPLOY_LOGFILE}
printf "${url} took ${SECONDS} seconds to publish\n" >> ${DEPLOY_LOGFILE}
