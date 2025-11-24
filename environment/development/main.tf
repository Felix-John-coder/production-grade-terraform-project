locals {
  private       = { for k, v in module.vpc.private_subnet : k => v }
  public_baston = { for k, v in module.vpc.baston_subnet : k => v }
  #public        = { for k, v in module.vpc.public_subnet : k => v }
}

module "vpc" {
  source      = "../../modules/vpc"
  cidr_block  = "10.0.0.0/16"
  environment = "devops"
}

/*module "ec2" {
  source            = "../../modules/ec2"
  image             = "ami-0c7d68785ec07306c"
  imagetype         = "t3.micro"
  key_name          = "actionkey"
  vpc_idec2         = module.vpc.vpc_id
  for_each          = local.private
  subnet_idec2      = each.value
  environment       = "dev"
  profile           = module.IAM.ec2_profile
  alb_the_sg_needed = module.ALB.the_sg_alb
  alb_inbound = [for b in module.baston_ec2: b.sg_bast ]
}*/
module "baston_ec2" {
  source      = "../../modules/baston_host"
  baston_vpc  = module.vpc.vpc_id
  for_each    = local.public_baston
  bast_subnet = each.value
  environment = "dev"

}
module "ASG" {
  source                    = "../../modules/ASG"
  name                      = "my_auto_scaler"
  instance_type             = ["t3.micro", "t3.small"]
  image_id                  = "ami-0f50f13aefb6c0a5d"
  key_name                  = "actionkey"
  asg_target_arn            = module.ALB.tg_arn
  ASG_instance_profile_name = module.IAM.ec2_profile
  max                       = 4
  min                       = 2
  desire                    = 2
  vpc                       = module.vpc.vpc_id
  alb_enter                 = module.ALB.the_sg_alb
  baston_login              = [for s in module.baston_ec2 : s.sg_bast]
  the_subnet                = values(module.vpc.private_subnet)
  environment               = "dev"
}
# distribute traffic
module "ALB" {
  source                = "../../modules/ALB"
  name                  = "my-ALB-aws"
  bucket_name           = module.S3.buck_name
  alb_path_health_check = "/index.html"
  alb_sg_vpc            = module.vpc.vpc_id
  alb_subnet            = values(local.private)
  alb_vpc               = module.vpc.vpc_id
  environment           = "dev"

}
#the iam
module "IAM" {
  source          = "../../modules/IAM"
  role_name       = "ec2_access"
  the_role_policy = jsonencode(local.ec2_role)
  policy_name     = "ec2_policy_access"
  the_policy      = jsonencode(local.ec2_policy)
  environment     = "dev"
}

module "S3" {
  source      = "../../modules/S3"
  bucket_name = "aws-terraform-bucket-felix"
  environment = "dev"
}