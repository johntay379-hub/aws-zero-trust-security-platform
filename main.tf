data "aws_caller_identity" "current" {}

module "iam" {
  source  = "./modules/iam"
  project = var.project
}

module "s3" {
  source     = "./modules/s3"
  project    = var.project
  region     = var.region
  account_id = data.aws_caller_identity.current.account_id
}

module "cloudtrail" {
  source      = "./modules/cloudtrail"
  project     = var.project
  bucket_name = module.s3.bucket_name
  account_id  = data.aws_caller_identity.current.account_id

  depends_on = [module.s3]
}

module "vpc" {
  source                = "./modules/vpc"
  project               = var.project
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  region                = var.region
}

module "alb" {
  source            = "./modules/alb"
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.vpc.alb_sg_id
}

module "asg" {
  source               = "./modules/asg"
  project              = var.project
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  target_group_arn     = module.alb.target_group_arn
  iam_instance_profile = module.iam.instance_profile_name
  instance_type        = var.instance_type
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  region               = var.region
  ec2_sg_id            = module.vpc.ec2_sg_id
}

module "cloudwatch" {
  source         = "./modules/cloudwatch"
  project        = var.project
  asg_name       = module.asg.asg_name
  alert_email    = var.alert_email
  region         = var.region
  scale_up_arn   = module.asg.scale_up_arn
  scale_down_arn = module.asg.scale_down_arn
  alb_arn_suffix = module.alb.alb_arn
}

module "config" {
  source      = "./modules/config"
  project     = var.project
  bucket_name = module.s3.bucket_name
  account_id  = data.aws_caller_identity.current.account_id
  region      = var.region
}
