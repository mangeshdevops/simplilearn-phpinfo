# simplilearn-phpinfo
## CLONE GITHUB REPOSITORY
```
export ADVERTISE_ADDR=192.168.0.8
export ENV_FILE=common.env
export GITHUB_BRANCH=2021-08
export GITHUB_PROJECT=simplilearn-phpinfo
export GITHUB_RELEASE=single-line
export GITHUB_SRC=src
export GITHUB_USERNAME=academiaonline
export NODEPORT=80
export WORKDIR=/src

cd ${HOME}/
git clone https://github.com/${GITHUB_USERNAME}/${GITHUB_PROJECT}
cd ${GITHUB_PROJECT}/
git pull
git checkout ${GITHUB_BRANCH}
```
## BUILD AND PUSH DOCKER IMAGE
```
source ${ENV_FILE}
docker image build --file Dockerfile-${GITHUB_RELEASE} --tag ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} ./
docker image push  ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE}
```
## CREATE DOCKER CONTAINERS AND VOLUMES
```
source ${ENV_FILE}
docker container run --cpus 0.050 --detach --entrypoint /usr/bin/php --memory 10M --name ${GITHUB_PROJECT}_${GITHUB_RELEASE} --publish ${NODEPORT}:8080 --read-only --rm --user nobody --volume ${PWD}/${GITHUB_SRC}/:${WORKDIR}/:ro --workdir ${WORKDIR}/ ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} -f index.php -S 0.0.0.0:8080

docker container logs ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container top ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container stats --no-stream ${GITHUB_PROJECT}_${GITHUB_RELEASE}
```
## DEPLOY WITH DOCKER SWARM
```
source ${ENV_FILE}
docker swarm init --advertise-addr ${ADVERTISE_ADDR}
docker stack deploy --compose-file docker-compose.yaml ${GITHUB_PROJECT}_${GITHUB_RELEASE}
```
## SAME THING WITHOUT A VOLUME
```
source ${ENV_FILE}
GITHUB_RELEASE=no-volume
NODEPORT=81

docker image build --file Dockerfile-${GITHUB_RELEASE} --tag ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} ./
docker container run --cpus 0.050 --detach --entrypoint /usr/bin/php --memory 10M --name ${GITHUB_PROJECT}_${GITHUB_RELEASE} --publish ${NODEPORT}:8080 --read-only --rm --user nobody --workdir ${WORKDIR}/ ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} -f index.php -S 0.0.0.0:8080

docker container logs ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container top ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container stats --no-stream ${GITHUB_PROJECT}_${GITHUB_RELEASE}

source ${ENV_FILE}
GITHUB_RELEASE=metadata
NODEPORT=82

docker image build --file Dockerfile-${GITHUB_RELEASE} --tag ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} ./
docker container run --cpus 0.050 --detach --memory 10M --name ${GITHUB_PROJECT}_${GITHUB_RELEASE} --publish ${NODEPORT}:8080 --read-only --rm --volume ${PWD}/${GITHUB_SRC}/:${WORKDIR}/:ro ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE}

docker container logs ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container top ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container stats --no-stream ${GITHUB_PROJECT}_${GITHUB_RELEASE}

source ${ENV_FILE}
GITHUB_RELEASE=no-volume-metadata
NODEPORT=83

docker image build --file Dockerfile-${GITHUB_RELEASE} --tag ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} ./
docker container run --cpus 0.050 --detach --memory 10M --name ${GITHUB_PROJECT}_${GITHUB_RELEASE} --publish ${NODEPORT}:8080 --read-only --rm ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE}

docker container logs ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container top ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container stats --no-stream ${GITHUB_PROJECT}_${GITHUB_RELEASE}

```
