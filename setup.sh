#!/bin/bash

docker compose up -d --build

git clone https://github.com/Chocobozzz/PeerTube.git src
cd src

git checkout master
git pull

nvm install --lts
nvm use --lts

npm i
npm i -g npm 
npm i -g yarn
npm i

yarn install --pure-lockfile

cd config
cp production.yaml.example production.yaml
cd -
# npm run build

# nohup npm run start -- --port 9000 > /var/www/peertube/peertube-server.log 2>&1 &

echo "Peertube ready for configuaration"  
echo "After adjusting your `production.yaml` according to your needs: "
echo ">npm run build"
echo "nohup npm run start -- --port 9000 > logs/peertube-server.log 2>&1 &"
