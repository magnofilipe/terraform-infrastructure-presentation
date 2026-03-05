output "instance_id" {
  description = "ID da instância EC2 criada"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.web.public_dns
}

output "instance_type" {
  description = "Tipo da instância EC2 (útil para confirmar mudanças na Fase 4)"
  value       = aws_instance.web.instance_type
}

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID da sub-rede pública"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.web.id
}

output "website_url" {
  description = "URL para acessar o servidor web (HTTP)"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ami_id" {
  description = "ID da AMI utilizada (Amazon Linux 2023)"
  value       = data.aws_ami.amazon_linux.id
}
