resource "aws_vpc" "vpcproject" {
  
   cidr_block = var.cidr
    
}

resource "aws_subnet" "sub" {
  count = var.sub_count  
  vpc_id     = aws_vpc.vpcproject.id
  cidr_block = element(var.subcidr, count.index)
  availability_zone = element(var.az, count.index)
}

resource "aws_security_group" "sg_project" {
    name = "sg_project"
    description = "My sg"
    vpc_id = aws_vpc.vpcproject.id 
 
   ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpcproject.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

 }

resource "aws_internet_gateway" "my_igw" {

    vpc_id = aws_vpc.vpcproject.id
 
}

resource "aws_route_table_association" "default" {
    subnet_id = element(aws_subnet.sub[*].id,0)
    route_table_id = aws_vpc.vpcproject.default_route_table_id
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.vpcproject.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}


resource "aws_instance" "servers" {
    ami = var.ami_id
    count = var.instance_counts
    instance_type = var.instance_types
    key_name = var.keys
    subnet_id = element(aws_subnet.sub[*].id,0)
    vpc_security_group_ids = [aws_security_group.sg_project.id]
    associate_public_ip_address = true 
    
}


resource "aws_security_group_rule" "inbound_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Allow incoming SSH traffic from a specific IP range
  security_group_id = aws_security_group.sg_project.id
}
