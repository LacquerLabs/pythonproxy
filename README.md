# Proxy Python

## build

[![Build Status](https://drone.whamcat.com/api/badges/LacquerLabs/pythonproxy/status.svg)](https://drone.whamcat.com/LacquerLabs/pythonproxy)
[![](https://images.microbadger.com/badges/version/lacquerlabs/pythonproxy.svg)](https://hub.docker.com/repository/docker/lacquerlabs/pythonproxy)
[![](https://images.microbadger.com/badges/image/lacquerlabs/pythonproxy.svg)](https://hub.docker.com/repository/docker/lacquerlabs/pythonproxy)


docker build -t pythonproxy .

## run

docker run -p3141:3141 --name onions --rm -it lacquerlabs/pythonproxy

## add a base to mirror

docker run --name scallion --rm -it lacquerlabs/pythonproxy add gemfury https://pypi.fury.io/secret/url/

## NOTES

for pip:
export PIP_INDEX_URL=http://localhost:3141/root/mirror/+simple/


export PIPENV_VENV_IN_PROJECT=1
export PIPENV_PYPI_MIRROR=http://localhost:3141/root/mirror

