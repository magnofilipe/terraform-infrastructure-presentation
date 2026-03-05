# 🎬 Roteiro de Demonstração — Terraform na Prática
> **Duração estimada:** 20–25 minutos  
> **Apresentadores:** 3 pessoas — P1, P2 e P3  
> **Premissa:** A contextualização teórica já foi feita. Este roteiro é 100% prático.

---

## 🗺️ Divisão de Cenas

```
P1 ──── Cenas 1 e 2: Estrutura dos arquivos + Init        (~7 min)
P2 ──── Cenas 3, 4 e 5: Plan + Apply + Outputs + State   (~9 min)
P3 ──── Cenas 6 e 7: Mudança in-place + Destroy           (~7 min)
```

---

---

# 👤 PESSOA 1 — Estrutura do Projeto + Init
> **Foco:** Mostrar como o código está organizado e inicializar o Terraform

---

## 🗂️ Cena 1 — Passeio pelos arquivos (~4 min)

> *[Abrir o explorador de arquivos com a estrutura do projeto visível]*

**Fala:**
> "Aqui está toda a infraestrutura que vamos subir em alguns minutos — cinco arquivos `.tf`, cada um com uma responsabilidade clara."

**Abra e comente cada arquivo:**

### `versions.tf`
> *[Mostrar o arquivo]*

> "Aqui fixamos as versões. O `required_version` garante que todos no time usem a mesma versão do Terraform. O `~> 5.0` no provider AWS aceita qualquer `5.x`, mas nunca `6.0` — sem risco de breaking change por atualização automática."

### `variables.tf`
> *[Mostrar o arquivo, destacar uma variável com `validation`]*

> "As variáveis são os **parâmetros** da infraestrutura — como argumentos de uma função. Reparem na `validation` da `aws_region`: se alguém passar um valor fora do padrão, o Terraform rejeita **antes** de tocar na nuvem. A `instance_type` é o que vamos alterar na Fase de Mudança."

### `terraform.tfvars`
> *[Mostrar o arquivo]*

> "Este é o arquivo que passa os valores concretos. Para criar um ambiente de produção com instâncias maiores, bastaria um `prod.tfvars` diferente — o `main.tf` não mudaria uma linha."

### `main.tf`
> *[Mostrar o arquivo, rolar devagar]*

> "O coração do projeto. Sete recursos: VPC, Internet Gateway, Sub-rede, Tabela de Rotas, Associação de Rota, Security Group e a instância EC2.
>
> Reparem que cada recurso **referencia** o anterior — `aws_internet_gateway` usa `aws_vpc.main.id`, a EC2 usa a subnet e o security group. Essas referências são as **dependências implícitas** — o Terraform lê o código, monta um grafo e descobre a ordem de criação sozinho. A gente não precisa dizer nada."

### `outputs.tf`
> *[Mostrar o arquivo]*

> "Após o `apply`, esses valores são exibidos no terminal — IP público, URL, IDs. Em pipelines de CI/CD, você captura esses valores e passa para o próximo step automaticamente."

---

## 🖥️ Cena 2 — `terraform init` (~3 min)

> *[Abrir o terminal no diretório do projeto]*

```bash
terraform init
```

> *[Executar e mostrar o output em tempo real]*

**Enquanto executa:**
> "Está baixando o plugin do provider AWS — é o `npm install` da infra. Este binário traduz os blocos HCL em chamadas da API da AWS."

**Após terminar, mostrar os artefatos:**
```bash
ls -la .terraform/
cat .terraform.lock.hcl
```

> "O `.terraform/` contém o binário do provider. O `.terraform.lock.hcl` é o lockfile — garante que todos no time baixem exatamente a mesma versão. Por isso ele vai para o Git, mas o `.terraform/` não — está no `.gitignore`."

> *[Passar para P2]*

---

---

# 👤 PESSOA 2 — Plan, Apply, Outputs e State
> **Foco:** O ciclo central do Terraform — prever, executar e entender o state

---

## 🖥️ Cena 3 — `terraform plan` (~4 min)

```bash
terraform plan
```

> *[Executar e deixar o output aparecer]*

**Enquanto aparece:**
> "Ele está consultando a AWS e comparando com o nosso código. Nenhum recurso foi criado ainda."

**Após terminar, destaque três pontos:**

**1. Os símbolos:**
> "O `+` verde significa criação. Se houvesse recursos existentes sendo modificados, veríamos `~` amarelo para update e `-` vermelho para destruição. Cada símbolo tem um peso diferente — ver um `-` em produção deve acender um alerta."

**2. O resumo final:**
> "Última linha: `Plan: 7 to add, 0 to change, 0 to destroy.` Você sabe o impacto exato antes de executar. **Este comando é o que evita desastres.** Em times, ninguém roda `apply` sem revisar o `plan` antes."

**3. Os `known after apply`:**
> *[Rolar o output e apontar os valores]*
> "Alguns valores aparecem como `known after apply` — o ID da VPC só vai existir depois que a AWS criar. O Terraform já planeja em torno disso."

---

## 🖥️ Cena 4 — `terraform apply` (~3 min)

```bash
terraform apply
```

> *[Mostrar a confirmação interativa]*

> "Ele exibe o plano de novo e pede `yes`. Barreira de segurança intencional. Em pipelines usamos `-auto-approve`, mas manualmente isso evita execuções acidentais."

> *[Digitar `yes`]*

**Enquanto cria:**
> "Reparem que alguns recursos são criados em paralelo — VPC e outros independentes sobem ao mesmo tempo. A EC2 só começa quando a subnet e o security group estão prontos. O grafo de dependências em tempo real."

**Quando terminar:**
> "Aqui estão os outputs — IP público, URL, IDs. Tudo que precisamos."

```bash
terraform output -raw website_url
```

> *[Abrir a URL no navegador]*
> "Infraestrutura no ar. Do zero ao servidor web rodando com três comandos."

---

## 📂 Cena 5 — O State File (~2 min)

```bash
terraform state list
```

> "Sete entradas — exatamente os sete recursos que criamos. O Terraform rastreia cada um."

```bash
terraform show
```

> "Este é o `terraform.tfstate` — a **memória** do Terraform. Um JSON com todos os atributos reais retornados pela AWS: IDs, IPs, ARNs. Sem ele, o Terraform não tem como saber o que existe na nuvem."

> *[Abrir o arquivo `terraform.tfstate` rapidamente no editor]*

> "Em times, esse arquivo **nunca** fica na máquina local. Vai para um bucket S3 com lock via DynamoDB — se duas pessoas rodarem `apply` ao mesmo tempo, uma espera a outra. O bloco comentado no `versions.tf` mostra exatamente como configurar esse backend."

> *[Passar para P3]*

---

---

# 👤 PESSOA 3 — Mudança In-Place + Destroy
> **Foco:** Demonstrar que o Terraform gerencia mudanças de forma inteligente

---

## 🖥️ Cena 6 — Mudança: `plan` + `apply` (~5 min)

**Fala:**
> "A pergunta que sempre surge: e quando eu preciso mudar algo que já existe? Vai destruir e recriar tudo?
>
> Vamos ver. Duas mudanças ao vivo."

**Mudança 1 — tipo da instância:**
> *[Editar `terraform.tfvars`]*

```hcl
instance_type = "t3.micro"  # era t2.micro
```

**Mudança 2 — nova tag:**
> *[Editar `main.tf`, descomentar a linha `# Version = "2.0"`]*

```hcl
Version = "2.0"
```

```bash
terraform plan
```

> "Resultado: `Plan: 0 to add, 1 to change, 0 to destroy.` Um recurso afetado, o `~` amarelo — **update in-place**. Não vai recriar o servidor."

> *[Mostrar o before/after no output]*

> "Aqui está o diff: `instance_type: t2.micro → t3.micro` e a tag `Version` sendo adicionada. O Terraform calcula o delta entre o estado atual e o desejado — aplica apenas o que mudou. Isso é **reconciliação de estado**."

```bash
terraform apply
```

```bash
terraform output instance_type
```

> "Atualizado. Sem recriar nada desnecessariamente."

---

## 🖥️ Cena 7 — `terraform destroy` (~2 min)

**Fala:**
> "Para fechar: o destroy. Ambiente de teste terminou, queremos remover tudo sem deixar custo residual."

```bash
terraform destroy
```

> "Ele lista tudo que será removido. Reparem na **ordem inversa** da criação — EC2 primeiro, depois Security Group, Subnet, Internet Gateway, VPC. Ele desfaz o grafo de dependências de trás para frente."

> *[Digitar `yes`]*

> "Sete recursos, removidos de forma ordenada. E se precisar recriar? `terraform apply` — idêntico ao que estava antes."

---

## 🎯 Encerramento (~1 min)

**Fala:**
> "O que demonstramos na prática:
>
> — `init` → prepara o ambiente, baixa o provider  
> — `plan` → previsão exata do impacto antes de executar  
> — `apply` → execução controlada com outputs prontos para uso  
> — **State** → memória da infra, compartilhada com lock em times  
> — **Mudança** → o Terraform detecta o delta e atualiza só o necessário  
> — `destroy` → remoção ordenada e completa em um comando
>
> O código está no repositório. Qualquer pessoa do time roda `terraform apply` e tem exatamente a mesma infraestrutura."

---

## ⏱️ Resumo de Tempo

| Pessoa | Cenas | Conteúdo | Tempo |
|---|---|---|---|
| **P1** | 1 e 2 | Passeio pelos arquivos + `terraform init` | ~7 min |
| **P2** | 3, 4 e 5 | `terraform plan` + `terraform apply` + State | ~9 min |
| **P3** | 6 e 7 | Mudança in-place + `terraform destroy` + Encerramento | ~7 min |
| | | **Total** | **~23 min** |

---

## 🚨 Checklist Pré-Apresentação

- [ ] `aws sts get-caller-identity` retorna OK
- [ ] `terraform --version` retorna versão >= 1.0
- [ ] `terraform init` já rodado (`.terraform/` existe)
- [ ] `terraform state list` retorna **vazio** (nenhum recurso criado ainda)
- [ ] `terraform.tfvars` com `instance_type = "t2.micro"` (antes da Cena 6)
- [ ] Linha `Version = "2.0"` **comentada** no `main.tf` (antes da Cena 6)
- [ ] Terminal com fonte grande e tema de alto contraste
- [ ] Navegador aberto e pronto para acessar a URL do servidor
