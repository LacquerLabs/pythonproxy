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
Successfully built 71a2e5b1e6fb
Successfully tagged lacquerlabs/pythonproxy:latest

real	1m4.499s
user	0m0.200s
sys	0m0.333s
$
```

empty cache - first run
```
$ time make rebuildwithmirror
Sending build context to Docker daemon  75.78kB
Step 1/33 : FROM python:3.6-slim
 ---> 51fbad121fdb
<--snip-->
Successfully built 1e2d90c20142
Successfully tagged lacquerlabs/pythonproxy:latest

real	1m52.230s
user	0m0.155s
sys	0m0.109s
```

populated cache
```
$ time make rebuildwithmirror
Sending build context to Docker daemon  75.78kB
Step 1/33 : FROM python:3.6-slim
 ---> 51fbad121fdb
<--snip-->
Successfully built 26a091fbc136
Successfully tagged lacquerlabs/pythonproxy:latest

real	1m0.671s
user	0m0.150s
sys	0m0.105s
```
