module "resource-group" {
  source  = "./modules/resource-group"
  rg_name = var.root_rg_name
}