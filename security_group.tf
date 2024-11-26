/* ==========Security Group for EC2 Instances (ALB--> EC2)============*/
module "EC2-security-group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "EC2-security-group"
  description = "Security group for web-server with HTTP and SSH ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  /*===Inbound Rules===*/
  ingress_with_cidr_blocks = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = module.ALB-security-group.security_group_id

      description = "Allow traffic only from the ALB security group"
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }


  ]

  /*===Outbound Rules===*/
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name = "EC2-SG"
  }
}

/* ==========Security Group for Application Load Balancer (Internet --> ALB)============*/

module "ALB-security-group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ALB-security-group"
  description = "Security group for web-server with HTTP and SSH ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  /*===Inbound Rules===*/
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP outbound traffic"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS outbound traffic"
    },

    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  /*===Outbound Rules===*/
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name = "ALB-SG"
  }

}


output "ec2_security_group_id" {
  value = module.EC2-security-group.security_group_id
}