# Terraform: Infraestrutura como Código

Este repositório inclui uma demonstração prática do uso do Terraform para provisionamento declarativo de infraestrutura na AWS, além de informações acerca dos integrantes que realizaram este trabalho e slides da apresentação.

## 👨‍🔧 Integrantes

- **[Ananda Vilar Vidal](https://github.com/4nandaw)**
- **[Filipe Magno Alves Paiva](https://github.com/magnofilipe)**
- **[Guilherme Alberto Dutra Camelo](https://github.com/GuilhermeAlz)**
- **[José Jardel Alves de Medeiros](https://github.com/jjardelalves)**
- **[Lázaro Queiroz do Nascimento](https://github.com/LazaroQueiroz)**
- **[Caio Victor de França Araujo](https://github.com/CaioVFA)**

## 💬 Slides da apresentação
Acesse-os clicando **[aqui](https://www.figma.com/deck/E20Vu8bbkyrLMbRQH7o0VH)**!

## 💻 Código!

### O que é provisionado

- VPC com sub-rede pública
- Internet Gateway e tabela de rotas
- Security Group (SSH + HTTP)
- Instância EC2 com servidor Apache

### Estrutura

```
.
├── main.tf             # Recursos de infraestrutura
├── variables.tf        # Declaração das variáveis
├── terraform.tfvars    # Valores das variáveis
├── outputs.tf          # Saídas após o deploy
└── versions.tf         # Versões do Terraform e providers
```

### Pré-requisitos

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

### Demonstração de mudança

Para demonstrar atualização de infraestrutura existente, edite `terraform.tfvars` e altere o `instance_type`, depois rode `plan` e `apply` novamente. O Terraform detecta o delta e atualiza apenas o necessário, sem recriar recursos do zero.

