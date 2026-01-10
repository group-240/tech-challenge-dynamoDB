# ⚡ Tech Challenge - DynamoDB

Repositório responsável pelas tabelas DynamoDB na AWS para o serviço de pagamentos.

## 📐 Arquitetura

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                  AWS Cloud                                           │
│                                                                                      │
│   ┌───────────────────────────────────────────────────────────────────────────────┐ │
│   │                            DynamoDB                                            │ │
│   │                                                                                │ │
│   │   ┌─────────────────────────────────────────────────────────────────────────┐ │ │
│   │   │                  tech-challenge-orders                                   │ │ │
│   │   │                                                                          │ │ │
│   │   │  ┌─────────────────────────────────────────────────────────────────┐    │ │ │
│   │   │  │  Primary Key                                                     │    │ │ │
│   │   │  │  ├── Partition Key: id (Number)                                 │    │ │ │
│   │   │  │                                                                  │    │ │ │
│   │   │  │  Global Secondary Index                                          │    │ │ │
│   │   │  │  └── status-index                                               │    │ │ │
│   │   │  │      └── Partition Key: status (String)                         │    │ │ │
│   │   │  │                                                                  │    │ │ │
│   │   │  │  Billing: PAY_PER_REQUEST (On-Demand)                           │    │ │ │
│   │   │  │  Point-in-Time Recovery: Enabled                                │    │ │ │
│   │   │  └──────────────────────────────────────────────────────────────────┘    │ │ │
│   │   │                                                                          │ │ │
│   │   └─────────────────────────────────────────────────────────────────────────┘ │ │
│   │                                                                                │ │
│   │   ┌─────────────────────────────────────────────────────────────────────────┐ │ │
│   │   │                  tech-challenge-payments                                 │ │ │
│   │   │                                                                          │ │ │
│   │   │  ┌─────────────────────────────────────────────────────────────────┐    │ │ │
│   │   │  │  Primary Key                                                     │    │ │ │
│   │   │  │  ├── Partition Key: id (String)                                 │    │ │ │
│   │   │  │                                                                  │    │ │ │
│   │   │  │  Billing: PAY_PER_REQUEST (On-Demand)                           │    │ │ │
│   │   │  │  Point-in-Time Recovery: Enabled                                │    │ │ │
│   │   │  │                                                                  │    │ │ │
│   │   │  │  Stores:                                                         │    │ │ │
│   │   │  │  - Payment responses from MercadoPago                           │    │ │ │
│   │   │  │  - QR Codes (Base64)                                            │    │ │ │
│   │   │  │  - Payment status                                               │    │ │ │
│   │   │  └──────────────────────────────────────────────────────────────────┘    │ │ │
│   │   │                                                                          │ │ │
│   │   └─────────────────────────────────────────────────────────────────────────┘ │ │
│   │                                                                                │ │
│   └────────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        │
                                        ▼
                              ┌─────────────────┐
                              │ Payments Service│
                              │                 │
                              │ Reads/Writes    │
                              │ payment data    │
                              └─────────────────┘
```

## 🔗 Comunicação

```
┌────────────────────────────────────────────────────────────────────────────┐
│                    CONEXÃO EKS → DynamoDB                                   │
└────────────────────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────────────────────────────────┐
  │                        EKS Node                                   │
  │                                                                   │
  │   ┌────────────────────────────────────────────────────────────┐ │
  │   │                   Payments Service Pod                      │ │
  │   │                                                             │ │
  │   │   ┌────────────────────────────────────────────────────┐   │ │
  │   │   │              DynamoDB Client (AWS SDK)              │   │ │
  │   │   │                                                     │   │ │
  │   │   │   Table: tech-challenge-payments                    │   │ │
  │   │   │   Operations:                                       │   │ │
  │   │   │   ├── PutItem (salvar pagamento)                   │   │ │
  │   │   │   ├── GetItem (buscar por ID)                      │   │ │
  │   │   │   └── UpdateItem (atualizar status)                │   │ │
  │   │   │                                                     │   │ │
  │   │   └─────────────────────────┬───────────────────────────┘   │ │
  │   │                             │                               │ │
  │   └─────────────────────────────┼───────────────────────────────┘ │
  │                                 │                                 │
  └─────────────────────────────────┼─────────────────────────────────┘
                                    │
                         AWS SDK via HTTPS
                          (IAM Role: LabRole)
                                    │
                                    ▼
                          ┌─────────────────┐
                          │    DynamoDB     │
                          │                 │
                          │  Region:        │
                          │  us-east-1      │
                          │                 │
                          │  Endpoint:      │
                          │  dynamodb.us-   │
                          │  east-1.        │
                          │  amazonaws.com  │
                          └─────────────────┘
```

## 📦 O que este repositório cria

| Recurso | Descrição |
|---------|-----------|
| `aws_dynamodb_table.orders` | Tabela para dados de pedidos (orders) |
| `aws_dynamodb_table.payments` | Tabela para dados de pagamentos |

## 📊 Schema das Tabelas

### tech-challenge-orders

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` (PK) | Number | ID do pedido |
| `status` (GSI) | String | Status do pedido |
| `cpf` | String | CPF do cliente |
| `items` | List | Itens do pedido |
| `totalAmount` | Number | Valor total |
| `createdAt` | String | Data de criação |

### tech-challenge-payments

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` (PK) | String | ID do pagamento (MercadoPago) |
| `status` | String | pending, approved, rejected |
| `amount` | Number | Valor do pagamento |
| `qrCode` | String | Código PIX |
| `qrCodeBase64` | String | Imagem do QR Code |
| `createdAt` | String | Data de criação |
| `approvedAt` | String | Data de aprovação |

## 📋 Outputs Exportados

| Output | Descrição | Usado Por |
|--------|-----------|-----------|
| `aws_region` | Região AWS | Payments Service |
| `dynamodb_table_name` | Nome da tabela orders | Payments Service |
| `dynamodb_payments_table_name` | Nome da tabela payments | Payments Service |
| `dynamodb_table_arn` | ARN da tabela orders | IAM Policies |
| `dynamodb_payments_table_arn` | ARN da tabela payments | IAM Policies |

## 📦 Dependências

Este repositório não depende de outros repositórios, apenas do bucket S3 para armazenar o state.

## 🔐 Secrets Necessários (GitHub)

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (obrigatório para AWS Academy Learner Lab)

## 🚀 Como usar

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## 📝 Notas

> **AWS Academy Learner Lab**: Não é possível criar IAM policies customizadas. O acesso ao DynamoDB é feito através do LabRole existente.
