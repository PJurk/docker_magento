docker-machine rm default
docker-machine create -d virtualbox -virtualbox-memory 4096 --virtualbox-disk-size "100000" default
docker-machine start default