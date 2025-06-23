# Peertube Docker Blueprint

Install your own instance of Peertube on your server

git clone <https://github.com/juergenarne/peertube-docker-blueprint.git> peertube
cd peertube
docker compose up -d --build
chmod 0775 install.sh
./install.sh

configre by editing

```bash
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
````

---

old stuff

---

Lösung B: In default.yaml echten Hostnamen/IP angeben

Da PeerTube auf dem Host läuft, brauchst du die IP des Docker-Containers, z. B.:

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' git-postgres-1

Beispielausgabe: 172.18.0.2

Dann in deiner config/default.yaml:

database:
  hostname: '172.18.0.2'  # oder was immer das inspect ergibt
  port: 5432
  ...

⚠️ Aber: Diese IP kann sich beim Neustart ändern → nicht dauerhaft stabil.

Klar! Hier ist ein vollständiges Setup, um **PeerTube, PostgreSQL und Redis** gemeinsam in Docker laufen zu lassen, sauber konfiguriert mit:

* `docker-compose.yml`
* `.env` für konfigurierbare Secrets
* `Dockerfile` für PeerTube

---

## 📁 1. `.env` (Umgebungsvariablen)

```dotenv
PEERTUBE_DB_USER=peertube
PEERTUBE_DB_PASSWORD=secretpassword
PEERTUBE_DB_NAME=peertube_db
PEERTUBE_REDIS_HOST=redis
PEERTUBE_POSTGRES_HOST=postgres
PEERTUBE_SMTP_DISABLED=true
```

---

## 📄 2. `docker-compose.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16
    restart: always
    environment:
      POSTGRES_USER: ${PEERTUBE_DB_USER}
      POSTGRES_PASSWORD: ${PEERTUBE_DB_PASSWORD}
      POSTGRES_DB: ${PEERTUBE_DB_NAME}
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - peertube-net

  redis:
    image: redis:7-alpine
    restart: always
    networks:
      - peertube-net

  peertube:
    build:
      context: .
      dockerfile: Dockerfile
    depends_on:
      - postgres
      - redis
    ports:
      - "9000:9000"
    environment:
      PEERTUBE_DB_HOSTNAME: ${PEERTUBE_POSTGRES_HOST}
      PEERTUBE_DB_USERNAME: ${PEERTUBE_DB_USER}
      PEERTUBE_DB_PASSWORD: ${PEERTUBE_DB_PASSWORD}
      PEERTUBE_DB_NAME: ${PEERTUBE_DB_NAME}
      PEERTUBE_REDIS_HOSTNAME: ${PEERTUBE_REDIS_HOST}
    volumes:
      - ./config:/app/config
      - ./storage:/app/storage
      - ./logs:/app/logs
    networks:
      - peertube-net

volumes:
  pgdata:

networks:
  peertube-net:
```

---

## 🐳 3. `Dockerfile` (PeerTube)

```dockerfile
FROM node:18-bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy source code
COPY . .

# Install Node dependencies
RUN npm ci

# Build frontend and backend
RUN npm run build

# Expose PeerTube port
EXPOSE 9000

# Start PeerTube
CMD [ "npm", "run", "start" ]
```

---

## 📁 4. `config/default.yaml` (optional Beispiel für PeerTube-Konfig)

Diese Datei kannst du bei `./config/default.yaml` speichern (wird über Volume gemountet):

```yaml
database:
  hostname: '${PEERTUBE_DB_HOSTNAME}'
  port: 5432
  username: '${PEERTUBE_DB_USERNAME}'
  password: '${PEERTUBE_DB_PASSWORD}'
  name: '${PEERTUBE_DB_NAME}'
  ssl: false

redis:
  hostname: '${PEERTUBE_REDIS_HOSTNAME}'
  port: 6379

webserver:
  https: false
  hostname: 'localhost'
  port: 9000

smtp:
  enabled: false
```

---

## 🚀 Starten

```bash
docker compose up --build
```

---

## 🔧 Hinweise

* Wenn du HTTPS, SMTP oder E-Mail willst, musst du `config/default.yaml` entsprechend erweitern.
* PeerTube nutzt viel Storage für Videos – bedenke das bei `./storage`.

---

Möchtest du, dass ich dir ein GitHub-Repo daraus baue (oder ZIP-Ordner)?
