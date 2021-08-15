# simplilearn-phpinfo
## CLONE GITHUB REPOSITORY
```
GITHUB_BRANCH=2021-08
GITHUB_PROJECT=simplilearn-phpinfo
GITHUB_RELEASE=single-line
GITHUB_USERNAME=academiaonline

cd ${HOME}/
git clone https://github.com/${GITHUB_USERNAME}/${GITHUB_PROJECT}
cd ${GITHUB_PROJECT}/
git pull
git checkout ${GITHUB_BRANCH}
git pull
```
## BUILD AND PUSH DOCKER IMAGE
```
docker image build --file Dockerfile-${GITHUB_RELEASE} --tag ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} ./
docker image push  ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE}
```
## CREATE DOCKER CONTAINERS AND VOLUMES
```
ARTIFACT=index.php
CPUS=0.050
ENTRYPOINT=/usr/bin/php
GITHUB_SRC=src
MEMORY=12Mi
NODEPORT=80
TARGETPORT=8080
USER=1000620000:1000620000
WORKDIR=/app

CMD="-f index.php -S 0.0.0.0:${TARGETPORT}"
docker container run --cpus ${CPUS} --detach --entrypoint ${ENTRYPOINT} --memory ${MEMORY} --name ${GITHUB_PROJECT}_${GITHUB_RELEASE} --publish ${NODEPORT}:${TARGETPORT} --read-only --rm --user ${USER} --volume ${PWD}/${GITHUB_SRC}/${ARTIFACT}:${WORKDIR}/${ARTIFACT}:ro --workdir ${WORKDIR}/ ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} ${CMD}

docker container logs ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container top ${GITHUB_PROJECT}_${GITHUB_RELEASE} 
docker container stats --no-stream ${GITHUB_PROJECT}_${GITHUB_RELEASE}
```
## DEPLOY WITH DOCKER SWARM
```
docker stack deploy --compose-file docker-compose.yaml ${GITHUB_PROJECT}_${GITHUB_RELEASE}
```
## DEPLOY WITH KUBERNETES/OPENSHIFT
```
oc new-project ${GITHUB_PROJECT}_${GITHUB_RELEASE}
kubectl create namespace ${GITHUB_PROJECT}_${GITHUB_RELEASE}
kubectl create secret generic simplilearn-phpinfo-secret --from-file src/index.php --namespace ${GITHUB_PROJECT}_${GITHUB_RELEASE}
kubectl apply --filename etc/kubernetes/manifests/ --namespace ${GITHUB_PROJECT}_${GITHUB_RELEASE}
```
