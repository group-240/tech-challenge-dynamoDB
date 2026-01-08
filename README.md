# Tech Challenge - DynamoDB

Repositório responsável pelas tabelas DynamoDB na AWS.

## O que este repositório cria

- **Tabela tech-challenge-orders** - Armazena dados de pedidos
- **Tabela tech-challenge-payments** - Armazena dados de pagamentos
- **IAM Policy** - Política de acesso às tabelas

## Dependências

| Dependência | Descrição |
|-------------|-----------|
| tech-challenge-infra | Bootstrap executado (S3 state) |
| Terraform >= 1.10.0 | Ferramenta de IaC |

## Secrets Necessários (GitHub)

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Outputs

Este repositório exporta outputs usados por outros repositórios:
- DynamoDB Table Names
- DynamoDB Table ARNs
- IAM Policy ARN
