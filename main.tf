data "aws_ami" "ubuntu"{
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "network" {
  source = "./network"
}

module "alb"{
  source="./alb"
}

module "s3"{
  source="./s3bucket"
}

module "iam"{
  source="./iam"
}

resource "aws_instance" "webserver1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.keyPair
  iam_instance_profile = module.iam.aws_profile

  vpc_security_group_ids = [
    module.network.security_group_id
  ]

  subnet_id = module.network.subnet1_id
  user_data_base64 = base64encode(file("./data/userdata.sh"))

  tags = {
    Name = "webserver1"
  }
}

resource "aws_instance" "webserver2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.keyPair
  iam_instance_profile = module.iam.aws_profile

  vpc_security_group_ids = [ module.network.security_group_id ]

  subnet_id = module.network.subnet2_id
  user_data_base64 = base64encode(file("./data/userdata2.sh"))

  tags = {
    Name = "webserver2"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = module.alb.alb_target_group.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = module.alb.alb_target_group.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = module.alb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = module.alb.alb_target_group.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = module.alb.lb.dns_name
}

output "instance1_public_ip" {
  value = aws_instance.webserver1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.webserver2.public_ip
}