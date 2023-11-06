# build item-app
docker build -t item-app:v1 .

# verify newly created image
docker images | grep "item-app"

# rename image
docker tag item-app:v1 23pstars/item-app:v1

# push to docker hub
docker push 23pstars/item-app:v1
