# Proxy Python

## build

[![Build Status](https://drone.whamcat.com/api/badges/LacquerLabs/pythonproxy/status.svg)](https://drone.whamcat.com/LacquerLabs/pythonproxy)

docker build -t pythonproxy .

## run

docker run -p3141:3141 --name onions --rm -it lacquerlabs/pythonproxy

docker-compose up -d


## add a base to mirror


docker run --name scallion --rm -it lacquerlabs/pythonproxy add gemfury https://pypi.fury.io/secret/url/

docker-compose run pythonproxy add gemfury https://pypi.fury.io/secret/url/


## NOTES

for pip:
export PIP_INDEX_URL=http://localhost:3141/root/mirror/+simple/


export PIPENV_VENV_IN_PROJECT=1
export PIPENV_PYPI_MIRROR=http://localhost:3141/root/mirror

### Time Tests


```
# time make rebuild
Sending build context to Docker daemon  50.18kB
Step 1/32 : FROM python:3.6-slim
 ---> 51fbad121fdb
<--snip-->
 ---> c67012355f9e
Successfully built c67012355f9e
Successfully tagged lacquerlabs/pythonproxy:latest

real	5m11.662s
user	0m0.189s
sys	0m0.154s
```

empty cache
```
# time make rebuildwithmirror
Sending build context to Docker daemon  50.18kB
Step 1/32 : FROM python:3.6-slim
 ---> 51fbad121fdb
 <--snip-->
Successfully built f7c298e51169
Successfully tagged lacquerlabs/pythonproxy:latest

real	3m43.375s
user	0m0.183s
sys	0m0.127s
```

populated cache
```
# time make rebuildwithmirror
Sending build context to Docker daemon  50.18kB
Step 1/32 : FROM python:3.6-slim
 ---> 51fbad121fdb
<--snip-->
Successfully built e7fa1dabe82c
Successfully tagged lacquerlabs/pythonproxy:latest

real	2m51.366s
user	0m0.188s
sys	0m0.127s
```
