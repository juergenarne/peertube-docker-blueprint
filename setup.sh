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

echo "Peertube ready for configuaration"
echo "To edit your production config file: "
echo "vi config/production.yaml"
echo "Use "
openssl rand -hex 32
echo "as a peertube secret key"
echo "After adjusting your 'production.yaml' file according to your needs: "
echo "npm run build"
echo "nohup npm run start -- --port 9000 > logs/peertube-server.log 2>&1 &"
