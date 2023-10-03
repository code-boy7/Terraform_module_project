module "terraproject" {
  source = "C:/DEVOPS/09 TerraForm/modules/terra_aws_project"
   cidr = var.cidr
   subcidr = var.subcidr
   az = var.az
   sub_count = var.sub_count
   instance_types = var.instance_types
   keys = var.keys
   ami_id = var.ami_id
   instance_counts = var.instance_counts
}

output "vpc_ids" {
  value = module.terraproject.vpc_id
}
output "igw" {
    value = module.terraproject.igw_id
  
}

output "subs_id" {  
    value = module.terraproject.subnet_id
  
}
output "pub_id" {
  value = module.terraproject.publicip
}