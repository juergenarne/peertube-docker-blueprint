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

4. Make sure you have latest version of node 20 installed and active

```bash
nvm install 20
nvm use 20
````

5. Clone the latest code from github and make some changes

```bash
chmod 0775 install.sh # optional
./install.sh
````

6. Find out the internal ips of your contrainers for the configuration:

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ptb-postgres
````

7. Configre by editing the `config/default.yaml` file.

8. After finishing the configuration make sure you run the latest node.js composnents

```bash
nvm install 20 # optional
nvm use 20 # optional
npm install chai@4.3.7
npm i -g yarn
npm i -g npm 
npm i
yarn install --pure-lockfile
````

9. Build the application

```bash
npm run build
````

10. Start the application

```bash
mkdir logs
nohup npm run start > logs/peertube.log 2>&1 &
````

To be able to call your application over the web you need to use an nginx proxy to redirect your url to `127.0.0.1:9000` or whatever port you have set in the config file.

11. To stop the application for reconfiguration or ppdate you can do

```bash
kill $(pgrep -f 'node dist/server') 
````

... and start over from nr. 9 ...

## Branches

- master // the master branch always contains the latest version of the application
- unofficial // the unofficial branch contains the approach to make the unofficial repo version of peertube run on any random ubuntu serv er with docker and nvm installed.

## Disclaimer

Please keep in mind that this repo is only provding the code for the requested Docker enviornment. The official source code for Peertube is cloned from the official (unofficial) PeerTube repo `https://github.com/Chocobozzz/PeerTube.git`.

## ✅ Warum das jetzt dauerhaft funktioniert

Du hast in deiner Service-Datei:

```ini
[Install]
WantedBy=multi-user.target
```

und du hast sie aktiviert mit:

```bash
sudo systemctl enable peertube
```

Das bedeutet:

* `systemd` merkt sich deinen Dienst im Boot-Prozess
* sobald das System Netzwerk und Docker gestartet hat, startet automatisch:
  → dein Redis-Container
  → dein PostgreSQL-Container
  → dein PeerTube-Service

💡 Wenn du also neu bootest (`sudo reboot`), dann läuft PeerTube nach ca. 30 Sekunden wieder automatisch auf Port 9000 – und dein nginx-Proxy kümmert sich wie gewohnt um SSL.

---

## 🧭 Optional: kleine Checks & Pflege

### 🔹 Prüfen, ob es aktiviert ist:

```bash
systemctl is-enabled peertube
```

→ sollte `enabled` zurückgeben.

### 🔹 Nach dem Reboot checken:

```bash
sudo systemctl status peertube
```

Wenn da steht:

```
Active: active (running)
```

→ alles top ✅

### 🔹 Logs anschauen:

```bash
journalctl -u peertube -f
```

---

## 🧰 Bonus-Tipp (empfohlen)

Du kannst sicherstellen, dass PeerTube **erst startet, wenn Docker & die Container laufen**, indem du in deiner Unit-Datei oben ergänzt:

```ini
After=network-online.target docker.service
Wants=network-online.target
```

Das hast du wahrscheinlich schon drin, aber das garantiert, dass PeerTube nicht zu früh startet (bevor Redis/Postgres verfügbar sind).

---

Kurz gesagt:
🟢 **Ja, PeerTube startet jetzt bei jedem Reboot automatisch.**
Und du hast es absolut richtig eingerichtet — inklusive `nvm`, `systemd` und Docker-Integration.

Willst du, dass ich dir zum Abschluss noch eine kurze „Checkliste für den Dauerbetrieb“ zusammenstelle (Backup, Updates, Logs etc.) — also was du jetzt regelmäßig prüfen solltest, damit PeerTube stabil bleibt?


See also: <https://docs.joinpeertube.org/install/unofficial>

Enjoy!
