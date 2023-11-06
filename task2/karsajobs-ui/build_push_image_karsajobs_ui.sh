DOCKER_HUB_USER="23pstars"
DOCKER_HUB_IMAGE_PATH="$DOCKER_HUB_USER/karsajobs-ui:latest"

# build the image
docker build . -t $DOCKER_HUB_IMAGE_PATH

# check the pass
if [ -z "$DOCKER_HUB_PASS" ]; then
  read -p "Enter Docker Hub Password ($DOCKER_HUB_USER) : " DOCKER_HUB_PASS
fi

# login to docker hub
echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin

# push to docker hub
docker push $DOCKER_HUB_IMAGE_PATH
