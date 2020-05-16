# Proxy Python

## build

[![Build Status](https://drone.whamcat.com/api/badges/LacquerLabs/pythonproxy/status.svg)](https://drone.whamcat.com/LacquerLabs/pythonproxy)

docker build -t pythonproxy .

## run

docker run -p3141:3141 --name onions --rm -it lacquerlabs/pythonproxy

## add a base to mirror

docker run --name scallion --rm -it lacquerlabs/pythonproxy add gemfury https://pypi.fury.io/secret/url/

## NOTES

export PIPENV_VENV_IN_PROJECT=1
export PIPENV_PYPI_MIRROR=http://localhost:3141/root/mirror

