# get base image from node:14
FROM node:14

# define the working dir
WORKDIR /app

# copy all files in current directory to container
COPY . .

# define some parameters through system environment
ENV NODE_ENV=production DB_HOST=item-db

# install node dependencies as well as build the app
RUN npm install --production --unsafe-perm && npm run build

# open 8080 port in container
EXPOSE 8080

# finally start the app
CMD [ "npm", "start" ]
