#!/bin/bash
# TODO: Error checking for vars
NAME=$1
URL=$2
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} use http://host.docker.internal:${APP_PORT}
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} login root --password=''
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index root/mirror --delete -y
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/${NAME} type=mirror mirror_url="${URL}" volatile=False mirror_whitelist="*"
BASES=`devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -l | xargs | sed -e 's/ /,/g'`
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/mirror bases=root/gemfury,root/pypi volatile=True mirror_whitelist="*"
