# Peertube Docker Setup

Install your own instance of Peertube on your server using Docker PostgreSQL Redis and Node.js

```bash
cd /some/docker/sub/dir
````

1. Clone this repo from github.com (free)

```bash
git clone https://github.com/juergenarne/peertube-docker-blueprint.git .
`````

2. Modify your .env file

```bash
vi .env
````

set the variables for

APP_KEY
APP_NAME
POSTGRES_USER
POSTGRES_PASSWORD
POSTGRES_DB
REDIS_PORT

to a safe and conveniant value

To generate a safe password use:

./password.sh

3. Start the enviornment

```bash
docker compose up -d --build
````

4. Clone the latest code from github and make some changes

```bash
chmod 0775 install.sh # optional
./install.sh
````

5. Find out the internal ips of your contrainers for the configuration:

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ptb-postgres
````

6. Configre by editing the `config/default.yaml` file.

7. After finishing the configuration make sure you run the latest node.js composnents

```bash
nvm install --lts
nvm use --lts

npm i
npm i -g npm 
npm i -g yarn
npm i

yarn install --pure-lockfile
````

8. Build the application

```bash
npm run build
````

9. Start the application

```bash
mkdir logs
nohup npm run start > logs/peertube.log 2>&1 &
````

To be able to call your application over the web you need to use an nginx proxy to redirect your url to `127.0.0.1:9000` or whatever port you have set in the config file.

10. To stop the application for reconfiguration or ppdate you can do

```bash
kill $(pgrep -f 'node dist/server') 
````

... and start over from nr. 9 ...

11. To create a user

```bash
NODE_ENV=production npm run create-user
````

## Branches

- master // the master branch always contains the latest version of the application
- unofficial // the unofficial branch contains the approach to make the unofficial repo version of peertube run on any random ubuntu serv er with docker and nvm installed.
- develop // always the latest shit but not always stable, so take care...
- recommended // Coming soon. We will take it from here: [Production Guide](https://docs.joinpeertube.org/install/any-os)

## Disclaimer

Please keep in mind that this repo is only provding the code for the requested Docker enviornment. The official source code for Peertube is cloned from the official (unofficial) PeerTube repo `https://github.com/Chocobozzz/PeerTube.git`.

See also: <https://docs.joinpeertube.org/install/unofficial>

Enjoy!
