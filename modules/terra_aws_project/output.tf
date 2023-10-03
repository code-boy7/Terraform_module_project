output "vpc_id" {
    value = aws_vpc.vpcproject.id
  
}

output "subnet_id" {

    value = aws_subnet.sub[*].id
  
}

output "igw_id" {

    value =  aws_internet_gateway.my_igw.id
  
}

output "publicip" {
  
  value = aws_instance.servers[*].public_ip
}