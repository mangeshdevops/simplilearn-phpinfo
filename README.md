# simplilearn-phpinfo
## CLONE GITHUB REPOSITORY
```
export ENV_FILE=common.env
export GITHUB_BRANCH=2021-08
export GITHUB_PROJECT=simplilearn-phpinfo
export GITHUB_RELEASE=single-line
export GITHUB_USERNAME=academiaonline
export NODEPORT=80

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
docker container run --cpus 0.050 --detach --entrypoint /usr/bin/php --memory 10M --name ${GITHUB_PROJECT}_${GITHUB_RELEASE} --publish ${NODEPORT}:8080 --read-only --rm --user nobody --volume ${PWD}/${GITHUB_SRC}/:${WORKDIR}/:ro --workdir ${WORKDIR}/ ${GITHUB_USERNAME}/${GITHUB_PROJECT}:${GITHUB_RELEASE} -f index.php -S 0.0.0.0:8080

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
