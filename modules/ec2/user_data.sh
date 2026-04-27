#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

echo "START USER DATA"


# =========================
# INSTALL DOCKER
# =========================
yum install -y docker || amazon-linux-extras install docker -y

if ! command -v docker >/dev/null 2>&1; then
  echo "DOCKER NÃO INSTALOU" > /home/ec2-user/ERRO_DOCKER.txt
  exit 1
fi

systemctl daemon-reexec
systemctl enable docker
systemctl start docker

sleep 10

# =========================
# DEBUG VARIÁVEIS
# =========================
echo "DB_HOST=${db_host}" > /home/ec2-user/db_debug.txt
echo "DB_USER=${db_user}" >> /home/ec2-user/db_debug.txt
echo "DB_NAME=${db_name}" >> /home/ec2-user/db_debug.txt

# =========================
# APP NODE (CORRETO)
# =========================
cd /home/ec2-user

cat <<EOF > app.js
const http = require('http');
const { Client } = require('pg');

const client = new Client({
  host: "${db_host}",   // ✅ CORRETO
  user: "${db_user}",
  password: "${db_password}",
  database: "${db_name}",
  port: 5432,           // ✅ CORRETO
  ssl: { rejectUnauthorized: false }
});

client.connect()
  .then(() => console.log('DB CONNECTED'))
  .catch(err => console.error('DB ERROR:', err));

http.createServer((req, res) => {
  res.end('Node + RDS funcionando');
}).listen(3000);
EOF

# =========================
# DOCKERFILE
# =========================
cat <<EOF > Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY app.js .
RUN npm install pg
CMD ["node", "app.js"]
EOF

# =========================
# BUILD
# =========================
docker build -t node-app .

# remove antigo
docker rm -f node-app || true

# =========================
# RUN (VARIÁVEIS)
# =========================
docker run -d -p 3000:3000 \
  --name node-app \
  -e DB_HOST="${db_host}" \
  -e DB_USER="${db_user}" \
  -e DB_PASSWORD="${db_password}" \
  -e DB_NAME="${db_name}" \
  node-app

echo "END USER DATA"