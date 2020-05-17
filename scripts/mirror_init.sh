#!/bin/bash
# TODO: Error checking for vars
devpi-init --serverdir ${DEVPISERVER_SERVERDIR}
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} use http://${CLIENT_HOST}:${CLIENT_PORT}
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} login root --password=''
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index root/mirror --delete -y
devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/mirror bases=root/pypi volatile=True mirror_whitelist="*"
