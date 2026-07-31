data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_vpc" "webrtc_vpc" {

  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "webrtc-vpc"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.webrtc_vpc.id
}

resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.webrtc_vpc.id

  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.webrtc_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "webrtc_sg" {

  name = "webrtc-sg"

  vpc_id = aws_vpc.webrtc_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 40000
    to_port = 41000
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "webrtc_key" {

  key_name = "webrtc-stream-key"

  public_key = file("${path.root}/../webrtc-stream-key.pub")
}

resource "aws_instance" "webrtc_server" {

  ami = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_subnet.id

  key_name = aws_key_pair.webrtc_key.key_name

  vpc_security_group_ids = [
    aws_security_group.webrtc_sg.id
  ]

#   iam_instance_profile = "webrtc-instance-profile"

  user_data = file("${path.module}/user_data.sh")

  root_block_device {

    volume_size = 10

    volume_type = "gp3"

    encrypted = true
  }

  tags = {
    Name = "webrtc-server"
  }
}

resource "aws_eip" "webrtc_ip" {

  domain = "vpc"

  instance = aws_instance.webrtc_server.id
}