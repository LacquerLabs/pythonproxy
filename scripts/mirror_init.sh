#!/bin/bash
# TODO: Error checking for vars
echo "Initializing into ${DEVPISERVER_SERVERDIR}..."
devpi-init --serverdir ${DEVPISERVER_SERVERDIR}
echo "Starting server on 127.0.0.1 to setup mirror..."
devpi-server --host 127.0.0.1 --port 3141 --serverdir ${DEVPISERVER_SERVERDIR} &
DEVPI_PID=$!
echo "Waiting for local server to start..."
${APP_HOME}/scripts/wait-for-it.sh localhost:3141 -t 10
RESULT=$?
if [ $RESULT == 0 ] ; then
    echo "Server is responsive, setup client..."
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} use http://127.0.0.1:3141
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} login root --password=''
    echo "Deleting existing mirror group..."
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index root/mirror --delete -y > /dev/null 2>&1
    echo "Setup the mirror..."
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/mirror bases=root/pypi volatile=True mirror_whitelist="*"
    echo "Config complete..."
else 
    echo "Server did not respond within 10 seconds..."
fi
echo "Terminating the local server..."
kill -SIGTERM $DEVPI_PID
exit $RESULT