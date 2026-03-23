module "network"{
    source="../network"
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

output "alb_target_group_id"{
    value=aws_lb_target_group.tg.id
}

output "alb_target_group"{
    value=aws_lb_target_group.tg
}

output "lb"{
    value=aws_lb.myalb
}