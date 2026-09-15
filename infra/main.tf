module "ecs" {
  source = "./modules/ecs"
  # alb_listener         = module.alb.alb_listener
  subnet_A_ID          = module.vpc.subnet_A_ID
  subnet_B_ID          = module.vpc.subnet_B_ID
  ecs_sg_ID            = module.vpc.ecs_sg_ID
  ecs_target_group_arn = module.alb.ecs_target_group_arn
  depends_on           = [module.alb]
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source = "./modules/ecr"
}

module "acm" {
  source       = "./modules/acm"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "alb" {
  source       = "./modules/alb"
  alb_sg_id    = module.vpc.alb_sg_id
  subnet_A_ID  = module.vpc.subnet_A_ID
  subnet_B_ID  = module.vpc.subnet_B_ID
  ecs_vpc_ID   = module.vpc.ecs_vpc_ID
  acm_cert_arn = module.acm.acm_cert_arn
}

module "github_oidc" {
  source       = "./modules/github_oidc"
  ecs_repo_arn = module.ecr.ecs_repo_arn
}