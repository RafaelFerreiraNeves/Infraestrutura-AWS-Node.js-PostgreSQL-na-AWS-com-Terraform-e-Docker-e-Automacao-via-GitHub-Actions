#  Node.js + PostgreSQL (RDS) + Docker + Terraform

Este projeto demonstra a construção de uma aplicação backend em Node.js conectada a um banco PostgreSQL no RDS, com infraestrutura provisionada na AWS utilizando Terraform e execução em container Docker.

---

##  Arquitetura

```text
Internet
   ↓
EC2 (Docker)
   ↓
Node.js API
   ↓
RDS (PostgreSQL)
```

---

##  Objetivo do Projeto

Demonstrar na prática:

* Criação de infraestrutura na AWS com Terraform
* Containerização de aplicação com Docker
* Integração entre aplicação Node.js e banco PostgreSQL (RDS)
* Automação de deploy com GitHub Actions
* Boas práticas de separação entre aplicação e infraestrutura

---

##  Tecnologias Utilizadas

* Node.js
* PostgreSQL (AWS RDS)
* Docker
* Terraform
* AWS (EC2, RDS, VPC, Security Groups)
* GitHub Actions (CI/CD)

---

##  Estrutura do Projeto

```bash
.
├── app/
│   ├── app.js
│   ├── package.json
│   └── Dockerfile
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       ├── ec2/
│       └── rds/
```

---

##  Integração com o Banco (RDS)

A aplicação se conecta ao banco utilizando variáveis de ambiente:

```env
DB_HOST=<endpoint RDS>
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=<senha>
DB_NAME=appdb
```

Importante:

* O `DB_HOST` não inclui a porta
* A porta é definida separadamente (`DB_PORT`)

---

##  Docker

A aplicação é executada dentro de um container Docker:

```bash
docker build -t node-app .
docker run -d -p 3000:3000 \
  -e DB_HOST=... \
  -e DB_PORT=5432 \
  -e DB_USER=postgres \
  -e DB_PASSWORD=... \
  -e DB_NAME=appdb \
  node-app
```

---

##  Infraestrutura com Terraform

A infraestrutura é provisionada automaticamente:

* VPC
* Subnets públicas e privadas
* Security Groups
* EC2
* RDS (PostgreSQL)

### Outputs importantes:

```hcl
output "db_host" {
  value = module.rds.db_host
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}
```

---

##  Como Executar

### 1. Configurar AWS

```bash
aws configure
```

---

### 2. Inicializar Terraform

```bash
terraform init
```

---

### 3. Criar infraestrutura

```bash
terraform apply
```

---

### 4. Acessar aplicação

```bash
http://<EC2_PUBLIC_IP>:3000
```

---

##  Teste da Aplicação

Ao acessar a aplicação, deve retornar:

```text
App funcionando com RDS
```

---

##  Segurança

* RDS não é público
* Acesso ao banco permitido apenas via Security Group da EC2
* Porta 5432 restrita internamente
* EC2 expõe apenas portas necessárias (ex: 3000, 22)

---

##  Conceitos Aplicados

* Infraestrutura como Código (IaC)
* Modularização com Terraform
* Containerização com Docker
* Integração entre serviços AWS
* Uso de variáveis de ambiente
* Boas práticas de rede (VPC + Security Groups)

---

##  Problemas Resolvidos

Durante o desenvolvimento, foi identificado e corrigido:

* Erro de conexão com RDS causado por uso incorreto de `DB_HOST` com porta embutida (`:5432`)
* Ajuste para separação correta entre host e porta, evitando erro de DNS (`ENOTFOUND`)

---

##  Melhorias Futuras

* Implementar API REST completa (CRUD)
* Adicionar Load Balancer
* Auto Scaling Group
* Integração com ECR
* Monitoramento com CloudWatch
* Uso de filas (SQS)

---

##  Autor

Rafael Ferreira Neves

---

##  Conclusão

Este projeto demonstra a construção de uma aplicação backend real utilizando Node.js, conectada a um banco PostgreSQL no RDS, com infraestrutura totalmente provisionada via Terraform e execução em ambiente containerizado com Docker.

---
