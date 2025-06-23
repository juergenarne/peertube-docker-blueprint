#!/bin/bash

docker compose up -d --build

git clone https://github.com/Chocobozzz/PeerTube.git src
cd src

git checkout master
git pull

cp config/production.yaml.example config/production.yaml
mv config/default.yaml config/default.yaml.example
ln -s config/production.yaml config/default.yaml

echo "Peertube ready for configuaration"
echo "To edit your production config file: "
echo "vi config/production.yaml"
echo "Use "
openssl rand -hex 32
echo "as a peertube secret key"
