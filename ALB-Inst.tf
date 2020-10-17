provider "aws" {
  access_key = "Access_key_here"
  secret_key = "secret_key_here"
  region     = "us-east-1"
}


# Launch instance in public subnet with public security group 
resource "aws_instance" "ALB_EC2_01" {
  ami               = "ami-0c94855ba95c71c99"
  instance_type     = "t2.micro"
  key_name          = "your_keypair_here"
  availability_zone = "us-east-1a"
  security_groups   = ["WebDMZ"]
  user_data = file("install_apache.sh")

  tags = {
      Name = "Instance_01_ALB"
  }
}

resource "aws_instance" "ALB_EC2_02" {
  ami               = "ami-0c94855ba95c71c99"
  instance_type     = "t2.micro"
  key_name          = "TerraKP"
  availability_zone = "us-east-1b"
  security_groups   = ["WebDMZ"]
  user_data = file("install_apache2.sh")

  tags = {
      Name = "Instance_02_ALB"
  }
}

#Create an ALB resource
resource "aws_lb" "My_ALB" {
  name               = "My-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0f7e77e9d079013e8"]
  subnets            = ["subnet-0660efef704efe191", "subnet-0d2ff47a94316561f"]
  ip_address_type    = "ipv4"

  tags = {
    Name   =   "My_ALB"
  }
}

# ALB Listener
resource "aws_lb_listener" "ALB_listener" {
  load_balancer_arn = aws_lb.My_ALB.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB_TG.arn
  }
}

#ALB Target Group
resource "aws_lb_target_group" "ALB_TG" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-05ed605a861ac0453"
}

#ALB Target group attachement
resource "aws_lb_target_group_attachment" "TG_Attach1" {
  target_group_arn = aws_lb_target_group.ALB_TG.arn
  target_id        = aws_instance.ALB_EC2_01.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "TG_Attach2" {
  target_group_arn = aws_lb_target_group.ALB_TG.arn
  target_id        = aws_instance.ALB_EC2_02.id
  port             = 80
}


#output handling
output "ALB_DNS" {
  value = aws_lb.My_ALB.dns_name
}