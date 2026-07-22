module "resource-group" {
  source = "../modules/resource-group/"
  rgs    = var.rgs
}

module "vnet" {
  depends_on = [module.resource-group]
  source     = "../modules/virtual-network/"
  vnets      = var.vnets

}

module "public-ip" {
  depends_on = [module.resource-group]
  source     = "../modules/public-ip/"
  pips       = var.pips
}

module "subnet" {
  depends_on = [module.vnet,
  module.resource-group]
  source     = "../modules/subnet/"
  snets      = var.snets
}

module "virtual-machine" {
  depends_on = [module.resource-group,
  module.vnet,
  module.subnet]
  source = "../modules/virtual-machine/"
  nics   = var.nics
}