#!/usr/bin/dumb-init /bin/bash
# ----------------------------------------------------------------------------
# entrypoint for container
# ----------------------------------------------------------------------------
set -e

HOST_IP=`/bin/grep $HOSTNAME /etc/hosts | /usr/bin/cut -f1`
export HOST_IP=${HOST_IP}
echo
echo "container started with ip: ${HOST_IP}..."
echo
for script in /container-init.d/*; do
	case "$script" in
		*.sh)     echo "... running $script"; . "$script" ;;
		*)        echo "... ignoring $script" ;;
	esac
	echo
done

if [ "$1" == "default" ]; then
	echo "starting devpi server...."
	devpi-server --host 0.0.0.0 --port ${APP_PORT} --serverdir ${DEVPISERVER_SERVERDIR}
elif [ "$1" == "add" ]; then
	echo "Adding mirror..."
	/add_mirror.sh $2 $3
elif [ "$1" == "shell" ]; then
	echo "starting /bin/bash..."
	/bin/bash
else
	echo "Running something else ($@)"
	exec "$@"
fi