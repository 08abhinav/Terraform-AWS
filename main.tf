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

resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "webserver1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.keyPair
  iam_instance_profile = aws_iam_instance_profile.profile.name

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
  iam_instance_profile = aws_iam_instance_profile.profile.name

  vpc_security_group_ids = [ module.network.security_group_id ]

  subnet_id = module.network.subnet2_id
  user_data_base64 = base64encode(file("./data/userdata2.sh"))

  tags = {
    Name = "webserver2"
  }
}

resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [ module.network.security_group_id ]
  subnets         = [
    module.network.subnet1_id, 
    module.network.subnet2_id
  ]

  tags = {
    Name = "web"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_ownership,
    aws_s3_bucket_public_access_block.s3_access,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}


output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}

output "instance1_public_ip" {
  value = aws_instance.webserver1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.webserver2.public_ip
}