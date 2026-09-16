terraform {
  backend "s3" {
    bucket       = "threatmod-terraform-state-446503125863"
    key          = "ecs-fargate/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}