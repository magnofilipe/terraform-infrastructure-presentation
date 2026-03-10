# Terraform: Infraestrutura como Código

Demo prática de Terraform provisionando infraestrutura na AWS.

## O que é provisionado

- VPC com sub-rede pública
- Internet Gateway e tabela de rotas
- Security Group (SSH + HTTP)
- Instância EC2 com servidor Apache

## Estrutura

```
.
├── main.tf             # Recursos de infraestrutura
├── variables.tf        # Declaração das variáveis
├── terraform.tfvars    # Valores das variáveis
├── outputs.tf          # Saídas após o deploy
└── versions.tf         # Versões do Terraform e providers
```

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado com credenciais válidas

```bash
aws configure
```

## Como usar

```bash
# 1. Inicializar o projeto
terraform init

# 2. Visualizar o plano de execução
terraform plan

# 3. Criar a infraestrutura
terraform apply

# 4. Obter o endereço do servidor
terraform output website_url

# 5. Destruir tudo ao finalizar
terraform destroy
```

## Demonstração de mudança

Para demonstrar atualização de infraestrutura existente, edite `terraform.tfvars` e altere o `instance_type`, depois rode `plan` e `apply` novamente. O Terraform detecta o delta e atualiza apenas o necessário, sem recriar recursos do zero.

