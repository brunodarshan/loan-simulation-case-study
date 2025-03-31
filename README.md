# ✨ Desafio Técnico – Simulação de Empréstimo

Esta aplicação em Ruby on Rails realiza simulações de empréstimo com base em dados fornecidos via CSV, processando cada linha de forma assíncrona e utilizando serviços simulados da AWS (S3 + SQS via LocalStack).

---

## 🧱 Stack utilizada

- Ruby 3.2  
- Rails 8.0  
- Docker + Docker Compose  
- PostgreSQL  
- AWS SDK (S3 + SQS via [LocalStack](https://github.com/localstack/localstack))

---

## 🚀 Como rodar o projeto

### 1. Clone o repositório

```bash
git clone <repo>
cd <repo>
```

### 2. Suba o ambiente com Docker

```bash
docker-compose up --build
```

---

## 🗂️ Funcionalidades implementadas

### ✅ Simulação de empréstimo (`SimulateLoanUseCase`)
Calcula parcelas, total e juros com base em:
- Valor do empréstimo
- Idade (via data de nascimento)
- Prazo em meses

### ✅ Upload e processamento assíncrono de CSV
- Endpoint: `POST /simulate_on_queue`
- Recebe arquivo `.csv` com múltiplas simulações
- Faz upload do arquivo para o S3 (LocalStack)
- Cria um processo com `process_id`
- Retorna o identificador para consulta futura

---

## 📄 Formato do CSV

```csv
10000,1990-01-01,12
15000,1985-05-20,24
```

---

## 📬 Exemplos de requisição

### 📌 Upload de CSV

```bash
curl -X POST http://localhost:3000/simulate_on_queue \
  -H "Content-Type: multipart/form-data" \
  -F "file=@simulacoes.csv"
```

Resposta esperada:
```json
{
  "message": "Upload enviado ao S3 e agendado para processamento",
  "process_id": "123abc-uuid"
}
```

### 📌 Consulta de status (via console)

```bash
docker-compose exec web rails console
QueuedProcess.find_by(process_id: <UUID>)
```

---

## 🧪 Testes

Rodar todos os testes:

```bash
docker-compose run --rm web rails test
```

---

## 🔍 Consultar status do processo

Via console:

```bash
docker-compose run --rm web rails console
QueuedProcess.find_by(process_id: "<process_id>")
```

---

## 📦 Extras

- S3 e SQS simulados via LocalStack
- Integração com `aws-sdk-s3`
- Upload controlado por `S3Uploader`
- Job assíncrono pronto para implementação (`ProcessCsvJob`)

---

## 📊 Arquitetura da Solução

A estrutura da aplicação foi desenhada pensando em escalabilidade e separação de responsabilidades, conforme ilustrado abaixo:

![Arquitetura da aplicação](./docs/arquitetura.png)

**Camadas:**

- **Interface (API REST):**
  - Recebe as requisições de simulação (individual ou via upload de CSV)

- **Services / UseCases:**
  - `simulate_loan`: encapsula a lógica de simulação
  - `upload_csv`: lida com o recebimento do arquivo, upload no bucket e criação do processo

- **Jobs: PARCIALMENTE IMPLEMENTADA** 
  - `load_simulation_consumer`: responsável por ler o CSV do bucket, processar as simulações e enviar para a fila (SQS)

- **Infraestrutura:**
  - Banco de dados PostgreSQL
  - Bucket S3 simulado via LocalStack

---

## ✅ Considerações finais

O projeto foi desenvolvido com foco em:
- Clareza e separação de responsabilidades
- Facilidade de testes e extensão
- Estrutura de código realista para produção

---

## 📝 Licença

Este projeto está licenciado sob os termos da [MIT License](LICENSE).
