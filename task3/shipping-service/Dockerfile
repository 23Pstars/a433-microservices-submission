FROM node:14
WORKDIR /src
COPY . .
RUN npm install
ENV PORT=3001
EXPOSE $PORT
CMD ["node", "index.js"]
