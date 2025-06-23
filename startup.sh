!#/bin/bash
cd src
npm run build
mkdir logs

export NODE_ENV=production
nohup npm run start -- --port 9000 > logs/peertube-server.log 2>&1 &

#nohup NODE_ENV=production npm run start -- --port 9000 > logs/peertube-server.log 2>&1 &
