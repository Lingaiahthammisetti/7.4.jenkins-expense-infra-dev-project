data "aws_ssm_parameter" "app_alb_sg_id" {
    name ="/${var.project_name}/${var.environment}/app_alb_sg_id" # we will get this value from security group.
}
data "aws_ssm_parameter" "private_subnet_ids" {
    name ="/${var.project_name}/${var.environment}/private_subnet_ids" # We will get this value from VPC
}

data "aws_ami" "ami_info" {  # To get ami_id, we can use this data source.

    most_recent = true
    owners = ["679593333241"]

    filter {
        name = "name"
        values = ["OpenVPN Access Server Community Image-fe8020db-*"]
        }

    filter {
         name ="root-device-type"
         values = ["ebs"]
        }

    filter {
         name ="virtualization-type"
         values = ["hvm"]
  }
}