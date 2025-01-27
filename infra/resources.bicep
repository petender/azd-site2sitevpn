targetScope = 'resourceGroup'




@description('The shared key used to establish connection between the two vNet Gateways.')
@secure()
param sharedKey string = 'A1B2C3D4E5'

var vNet1 = {
  name: 'vNet1-${resourceGroup().location}'
  addressSpacePrefix: '10.0.0.0/23'
  subnetName: 'subnet1'
  subnetPrefix: '10.0.0.0/24'
  gatewayName: 'vNet1-Gateway'
  gatewaySubnetPrefix: '10.0.1.224/27'
  gatewayPublicIPName: 'gw1pip${uniqueString(resourceGroup().id)}'
  connectionName: 'vNet1-to-vNet2'
  asn: 65010
}
var vNet2 = {
  name: 'vNet2-${resourceGroup().location}'
  addressSpacePrefix: '10.0.2.0/23'
  subnetName: 'subnet1'
  subnetPrefix: '10.0.2.0/24'
  gatewayName: 'vNet2-Gateway'
  gatewaySubnetPrefix: '10.0.3.224/27'
  gatewayPublicIPName: 'gw2pip${uniqueString(resourceGroup().id)}'
  connection1Name: 'vNet2-to-vNet1'
  connection2Name: 'vNet2-to-vNet3'
  asn: 65020
}
var vNet3 = {
  name: 'vNet3-${resourceGroup().location}'
  addressSpacePrefix: '10.0.4.0/23'
  subnetName: 'subnet1'
  subnetPrefix: '10.0.4.0/24'
  gatewayName: 'vNet3-Gateway'
  gatewaySubnetPrefix: '10.0.5.224/27'
  gatewayPublicIPName: 'gw3pip${uniqueString(resourceGroup().id)}'
  connectionName: 'vNet3-to-vNet2'
  asn: 65030
}
var vnet1Ref = vNet1_name.id
var gateway1SubnetRef = '${vnet1Ref}/subnets/GatewaySubnet'
var vnet2Ref = vNet2_name.id
var gateway2SubnetRef = '${vnet2Ref}/subnets/GatewaySubnet'
var vnet3Ref = vNet3_name.id
var gateway3SubnetRef = '${vnet3Ref}/subnets/GatewaySubnet'
var gatewaySku = 'vpnGw1AZ'

resource vNet1_name 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vNet1.name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNet1.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vNet1.subnetName
        properties: {
          addressPrefix: vNet1.subnetPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vNet1.gatewaySubnetPrefix
        }
      }
    ]
  }
}

resource vNet2_name 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vNet2.name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNet2.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vNet2.subnetName
        properties: {
          addressPrefix: vNet2.subnetPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vNet2.gatewaySubnetPrefix
        }
      }
    ]
  }
}

resource vNet3_name 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vNet3.name
  location: 'eastasia'
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNet3.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vNet3.subnetName
        properties: {
          addressPrefix: vNet3.subnetPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vNet3.gatewaySubnetPrefix
        }
      }
    ]
  }
}

resource vNet1_gatewayPublicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: vNet1.gatewayPublicIPName
  location: 'westeurope'
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource vNet2_gatewayPublicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: vNet2.gatewayPublicIPName
  location: 'centralus'
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource vNet3_gatewayPublicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: vNet3.gatewayPublicIPName
  location: 'eastasia'
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource vNet1_gateway 'Microsoft.Network/virtualNetworkGateways@2019-11-01' = {
  name: vNet1.gatewayName
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: gateway1SubnetRef
          }
          publicIPAddress: {
            id: vNet1_gatewayPublicIP.id
          }
        }
        name: 'vNet1GatewayConfig'
      }
    ]
    gatewayType: 'Vpn'
    sku: {
      name: gatewaySku
      tier: gatewaySku
    }
    vpnGatewayGeneration: 'Generation1'
    vpnType: 'RouteBased'
    enableBgp: true
    bgpSettings: {
      asn: vNet1.asn
    }
  }
}

resource vNet2_gateway 'Microsoft.Network/virtualNetworkGateways@2019-11-01' = {
  name: vNet2.gatewayName
  location: 'centralus'
  properties: {
    ipConfigurations: [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: gateway2SubnetRef
          }
          publicIPAddress: {
            id: vNet2_gatewayPublicIP.id
          }
        }
        name: 'vNet2GatewayConfig'
      }
    ]
    gatewayType: 'Vpn'
    sku: {
      name: gatewaySku
      tier: gatewaySku
    }
    vpnGatewayGeneration: 'Generation1'
    vpnType: 'RouteBased'
    enableBgp: true
    bgpSettings: {
      asn: vNet2.asn
    }
  }
}

resource vNet3_gateway 'Microsoft.Network/virtualNetworkGateways@2019-11-01' = {
  name: vNet3.gatewayName
  location: 'eastasia'
  properties: {
    ipConfigurations: [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: gateway3SubnetRef
          }
          publicIPAddress: {
            id: vNet3_gatewayPublicIP.id
          }
        }
        name: 'vNet3GatewayConfig'
      }
    ]
    gatewayType: 'Vpn'
    sku: {
      name: gatewaySku
      tier: gatewaySku
    }
    vpnGatewayGeneration: 'Generation1'
    vpnType: 'RouteBased'
    enableBgp: true
    bgpSettings: {
      asn: vNet3.asn
    }
  }
}

resource vNet1_connection 'Microsoft.Network/connections@2019-11-01' = {
  name: vNet1.connectionName
  location: 'westeurope'
  properties: {
    virtualNetworkGateway1: {
      id: vNet1_gateway.id
    }
    virtualNetworkGateway2: {
      id: vNet2_gateway.id
    }
    connectionType: 'Vnet2Vnet'
    routingWeight: 3
    sharedKey: sharedKey
    enableBgp: true
  }
}

resource vNet2_connection1 'Microsoft.Network/connections@2019-11-01' = {
  name: vNet2.connection1Name
  location: 'centralus'
  properties: {
    virtualNetworkGateway1: {
      id: vNet2_gateway.id
    }
    virtualNetworkGateway2: {
      id: vNet1_gateway.id
    }
    connectionType: 'Vnet2Vnet'
    routingWeight: 3
    sharedKey: sharedKey
    enableBgp: true
  }
}

resource vNet2_connection2 'Microsoft.Network/connections@2019-11-01' = {
  name: vNet2.connection2Name
  location: 'centralus'
  properties: {
    virtualNetworkGateway1: {
      id: vNet2_gateway.id
    }
    virtualNetworkGateway2: {
      id: vNet3_gateway.id
    }
    connectionType: 'Vnet2Vnet'
    routingWeight: 3
    sharedKey: sharedKey
    enableBgp: true
  }
}

resource vNet3_connection 'Microsoft.Network/connections@2019-11-01' = {
  name: vNet3.connectionName
  location: 'eastasia'
  properties: {
    virtualNetworkGateway1: {
      id: vNet3_gateway.id
    }
    virtualNetworkGateway2: {
      id: vNet2_gateway.id
    }
    connectionType: 'Vnet2Vnet'
    routingWeight: 3
    sharedKey: sharedKey
    enableBgp: true
  }
}
