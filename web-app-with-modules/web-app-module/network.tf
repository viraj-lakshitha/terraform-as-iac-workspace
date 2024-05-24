data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "instance_security_group" {
  name = "${var.app_name}-${var.environment_name}-instance-security-group"
}

resource "aws_security_group_rule" "allow_http_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.instance_security_group.id

  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_lb_listener" "http_load_balancer" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "plain/text"
      message_body = "Page not found;"
      status_code = 404
    }
  }
}

resource "aws_lb_target_group" "instance_lb_group" {
  name = "${var.app_name}-${var.environment_name}-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_listener.http_load_balancer.arn
  target_id = aws_instance.instance_1.id
  port = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_listener.http_load_balancer.arn
  target_id = aws_instance.instance_2.id
  port = 8080
}

resource "aws_lb_listener_rule" "instance_lister_rule" {
  listener_arn = aws_lb_listener.http_load_balancer.arn
  priority = 100

  condition {
    path_pattern {
      values = [ "*" ]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.instance_lb_group.arn
  }
}

resource "aws_security_group" "alb_security_group" {
  name = "${var.app_name}-${var.environment_name}-alb-security-group"
}

resource "aws_security_group_rule" "allow_lb_http_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.alb_security_group.id

  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_lb_http_egress" {
  type = "egress"
  security_group_id = aws_security_group.alb_security_group.id

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "app_load_balancer" {
  name = "${var.app_name}-${var.environment_name}-web-app-lb"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default_subnet.ids
  security_groups = [ aws_security_group.alb_security_group.id ]
}