#!/bin/bash

su www-data

docker compose up -d --build

git clone https://github.com/Chocobozzz/PeerTube.git peertube
cd peertube

git checkout master
git pull

nvm install --lts
nvm use --lts

npm i
npm i -g npm 
npm i -g yarn
npm i

yarn install --pure-lockfile
npm run build

nohup npm run start -- --port 9000 > /var/www/peertube/peertube-server.log 2>&1 &

echo "Peertube is up and running"
