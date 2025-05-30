resource "azurerm_resource_group" "main" {
    name = "rg-terraform-test"
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet-demo"
    address_space = ["10.0.0.0/16"]
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "frontsubnet" {
    name = "front-subnet"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]  
}
resource "azurerm_subnet" "backsubnet" {
    name = "back-subnet"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.2.0/24"]  
}
resource "azurerm_subnet" "dbsubnet" {
    name = "db-subnet"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.3.0/24"]  
}


#AKS cluster

resource "azurerm_kubernetes_cluster" "aks" {
    name= "aks-demo"
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    dns_prefix = "aks-demo"

    default_node_pool {
        name = "default"
        node_count = 1
        vm_size = "Standard_DS2_v2"
    }

    identity {
        type = "SystemAssigned"
    }
}