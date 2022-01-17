#////////////////////////////////
#   Auto Scaling Group
#////////////////////////////////
resource "aws_launch_configuration" "this" {
  name            = "${var.web_app}-web"
  image_id        = var.web_image_id
  instance_type   = var.web_instance_type
  security_groups = var.templates_security_groups
  key_name        = var.web_key_name
  user_data       = <<-EOF

#!/bin/bash
yum update -y
yum install -y polkit
yum install -y httpd
systemctl start httpd
systemctl enable httpd
yum install -y git
cd /var/www/html
git clone https://github.com/babakDoraniArab/testHtmlTemplate.git
mv testHtmlTemplate/* ./
rm -R testHtmlTemplate

     EOF
}

resource "aws_autoscaling_group" "this" {
  name                 = "${var.web_app}-web"
  max_size             = var.web_max_size
  min_size             = var.web_min_size
  desired_capacity     = var.web_desired_capacity
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnets
}

#////////////////////////////////
#   LoadBalancer
#////////////////////////////////
resource "aws_lb" "this" {
  name               = "${var.web_app}-web"
  internal           = false
  load_balancer_type = "application"

  security_groups = var.lb_security_groups
  subnets         = var.subnets

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_lb_target_group" "this" {
  name     = "${var.web_app}-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id
  tags = {
    "Terraform" : "true"
  }
}

#////////////////////////////////
#   Auto Scaling Attachment
#////////////////////////////////
# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  alb_target_group_arn   = aws_lb_target_group.this.arn
}


#////////////////////////////////
#   AWS LoadBalancing Listener
#////////////////////////////////
# Create a new ALB Target Group attachment

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}