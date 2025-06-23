!#/bin/bash
cd src
npm run build
mkdir logs
#nohup NODE_ENV=production npm run start -- --port 9000 > logs/peertube-server.log 2>&1 &
