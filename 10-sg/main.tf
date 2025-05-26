#First creating security group with modules
#Second attaching dependent ports to security group using aws Security group rule

module "db" {
source ="../../5.12.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for DB MySQL Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for DB Security group
common_tags = var.common_tags
sg_name = "db"
}
module "backend" {
source ="../../5.12.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for Backend Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Backend Security group
common_tags = var.common_tags
sg_name = "backend"
}

#We need to add two more for app_alb and vpcn
module "app_alb" {
source ="../../5.12.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for App ALB Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for APP ALB Security group
common_tags = var.common_tags
sg_name = "app_alb"
}

module "frontend" {
source ="../../5.12.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for Frontend Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Frontend Security group
common_tags = var.common_tags
sg_name = "frontend"
}

#We need to add two more for app_alb and vpcn
module "web_alb" {
source ="../../5.12.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for Web ALB Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for WEB APP Security group
common_tags = var.common_tags
sg_name = "web_alb"
}

# module "bastion" {
# source ="../../5.12.terraform-aws-securitygroup"
# project_name = var.project_name
# environment =  var.environment
# sg_description = "SG for Bastion Instances"
# vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Bastion Security group
# common_tags = var.common_tags
# sg_name = "bastion"
# }

module "vpn" {
source ="../../5.12.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for VPN Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for VPN Security group
common_tags = var.common_tags
ingress_rules   = var.vpn_sg_rules
sg_name = "vpn"
}


#DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
    type = "ingress"
    from_port = 3306
    to_port =  3306
    protocol = "tcp"
    source_security_group_id = module.backend.sg_id # source is where you are getting traffic from.
    security_group_id = module.db.sg_id  
}
#DB is accepting connections from bastion
# resource "aws_security_group_rule" "db_bastion" {
#     type = "ingress"
#     from_port = 3306
#     to_port =  3306
#     protocol = "tcp"
#     source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
#     security_group_id = module.db.sg_id
# }
#DB is accepting connections from vpn
resource "aws_security_group_rule" "db_vpn" {
    type = "ingress"
    from_port = 3306
    to_port =  3306
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from.
    security_group_id = module.db.sg_id
}

#Backend is accepting connections from frontend
resource "aws_security_group_rule" "backend_app_alb" {
    type = "ingress"
    from_port = 8080
    to_port =  8080
    protocol = "tcp"
    source_security_group_id = module.app_alb.sg_id # source is where you are getting traffic from.
    security_group_id = module.backend.sg_id
}
#Backend is accepting connections from bastion
# resource "aws_security_group_rule" "backend_bastion" {
#     type = "ingress"
#     from_port = 22
#     to_port =  22
#     protocol = "tcp"
#     source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
#     security_group_id = module.backend.sg_id
# }
#Backend is accepting connections from VPN
resource "aws_security_group_rule" "backend_vpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from.
    security_group_id = module.backend.sg_id
}
#Backend is accepting connections from VPN
resource "aws_security_group_rule" "backend_vpn_http" {
    type = "ingress"
    from_port = 8080
    to_port =  8080
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from.
    security_group_id = module.backend.sg_id
}

#app_alb is accepting connections from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
    type = "ingress"
    from_port = 80
    to_port =  80
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from.
    security_group_id = module.app_alb.sg_id
}
#app_alb is accepting connections from bastion
# resource "aws_security_group_rule" "app_alb_bastion" {
#     type = "ingress"
#     from_port = 80
#     to_port =  80
#     protocol = "tcp"
#      source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
#     security_group_id = module.app_alb.sg_id
# }
#app_alb is accepting connections from frontend
resource "aws_security_group_rule" "app_alb_frontend" {
    type = "ingress"
    from_port = 80
    to_port =  80
    protocol = "tcp"
     source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from.
    security_group_id = module.app_alb.sg_id
}


#Frontend is accepting connections from public
resource "aws_security_group_rule" "frontend_public" {
    type = "ingress"
    from_port = 80
    to_port =  80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend.sg_id
}
#Frontend is accepting connections from bastion
# resource "aws_security_group_rule" "frontend_bastion" {
#     type = "ingress"
#     from_port = 22
#     to_port =  22
#     protocol = "tcp"
#      source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
#     security_group_id = module.frontend.sg_id
# }
#Frontend is accepting connections from vpn
resource "aws_security_group_rule" "frontend_vpn" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
     source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from.
    security_group_id = module.frontend.sg_id
}
#Frontend is accepting connections from web_alb
resource "aws_security_group_rule" "frontend_web_alb" {
    type = "ingress"
    from_port = 80
    to_port =  80
    protocol = "tcp"
     source_security_group_id = module.web_alb.sg_id # source is where you are getting traffic from.
    security_group_id = module.frontend.sg_id
}

#web_alb is accepting connections from public
resource "aws_security_group_rule" "web_alb_public" {
    type = "ingress"
    from_port = 80
    to_port =  80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.web_alb.sg_id
}

#web_alb is accepting connections from public
resource "aws_security_group_rule" "web_alb_public_https" {
    type = "ingress"
    from_port = 443
    to_port =   443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.web_alb.sg_id
}

#bastion is accepting connections from public
# resource "aws_security_group_rule" "bastion_public" {
#     type = "ingress"
#     from_port = 22
#     to_port =  22
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     security_group_id = module.bastion.sg_id
# }

#added as part of Jenkins CICD
resource "aws_security_group_rule" "backend_default_vpc" {
  type              = "ingress"
  from_port         = 0   #22
  to_port           = 65535  #22
  protocol          = "-1"  #"tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.backend.sg_id
}

#added as part of Jenkins CICD
resource "aws_security_group_rule" "frontend_default_vpc" {
  type              = "ingress"
  from_port         = 0  #22
  to_port           = 65535 #22
  protocol          = "-1"   #"tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.frontend.sg_id
}