const http = require('http');
const { Client } = require('pg');

const client = new Client({
  host: process.env.DB_HOST,      // vindo do Docker/Terraform
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
  ssl: { rejectUnauthorized: false }
});

// conecta no banco
client.connect()
  .then(() => console.log('✅ DB CONNECTED'))
  .catch(err => console.error('❌ DB ERROR:', err));

// servidor simples
const server = http.createServer(async (req, res) => {
  if (req.url === '/db') {
    try {
      const result = await client.query('SELECT NOW()');
      res.end(`DB OK: ${result.rows[0].now}`);
    } catch (err) {
      res.end(`DB FAIL: ${err.message}`);
    }
  } else {
    res.end('Node + RDS funcionando');
  }
});

server.listen(3000, () => {
  console.log('🚀 Server rodando na porta 3000');
});