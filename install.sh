#!/bin/bash

git clone https://github.com/Chocobozzz/PeerTube.git src
cd src

git checkout master
git pull

cd config

cp production.yaml.example production.yaml
mv default.yaml default.yaml.example
ln -s production.yaml default.yaml

cd -

echo "Peertube ready for configuaration"
echo "To edit your production config file: "
echo "vi src/config/production.yaml"
echo "Use "
openssl rand -hex 32
echo "as a peertube secret key"
