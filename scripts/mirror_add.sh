#!/bin/bash
# TODO: Error checking for vars
NAME=$1
URL=$2
echo "Adding mirror root/$NAME with $2..."
echo "Waiting for devpi server on ${CLIENT_HOST}:${CLIENT_PORT}..."
${APP_HOME}/scripts/wait-for-it.sh ${CLIENT_HOST}:${CLIENT_PORT} -t 10
RESULT=$?
if [ $RESULT == 0 ] ; then
    echo "Serveris responsive, setup client..."
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} use http://${CLIENT_HOST}:${CLIENT_PORT}
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} login root --password=''
    echo "Deleting existing mirror and mirror group..."
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index root/mirror --delete -y > /dev/null 2>&1
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index root/${NAME} --delete -y > /dev/null 2>&1
    echo "Setup the mirror..."
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/${NAME} type=mirror mirror_url="${URL}" volatile=False mirror_whitelist="*"
    echo "Setup the root/mirror bases..."
    BASES=`devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -l | xargs | sed -e 's/ /,/g'`
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/mirror bases=root/pypi,root/gemfury volatile=True mirror_whitelist="*"
    echo "Config complete..."
else 
    echo "Devpi server did not respond with in 10 seconds..."
fi
exit $RESULT
