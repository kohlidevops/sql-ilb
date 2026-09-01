@description('Internal Load Balancer name')
param loadBalancerName string

@description('Azure region')
param location string

@description('Load Balancer SKU')
param skuName string = 'Standard'

@description('Load Balancer tier')
param skuTier string = 'Regional'

@description('Existing subnet resource ID where the ILB frontend will reside')
param subnetId string

@description('Static private IP used by the ILB and future SQL AG listener')
param frontendPrivateIp string

@description('Frontend IP configuration name')
param frontendName string

@description('Backend address pool name')
param backendPoolName string

@description('Backend IP addresses. Empty until SQL VMs are available.')
param backendAddresses array = []

@description('Health probe name')
param probeName string

@description('Health probe protocol')
param probeProtocol string = 'Tcp'

@description('Health probe port')
param probePort int = 59999

@description('Load balancing rule name')
param ruleName string

@description('Load balancing rule protocol')
param ruleProtocol string = 'Tcp'

@description('Frontend port')
param frontendPort int = 1433

@description('Backend port')
param backendPort int = 1433

@description('Idle timeout in minutes')
param idleTimeoutInMinutes int = 4

@description('Enable Floating IP / Direct Server Return')
param enableFloatingIp bool = true

@description('Enable TCP reset')
param enableTcpReset bool = true


//===================================================
// RESOURCE IDS
//===================================================

var frontendIpConfigurationId = resourceId(
  'Microsoft.Network/loadBalancers/frontendIPConfigurations',
  loadBalancerName,
  frontendName
)

var backendPoolId = resourceId(
  'Microsoft.Network/loadBalancers/backendAddressPools',
  loadBalancerName,
  backendPoolName
)

var probeId = resourceId(
  'Microsoft.Network/loadBalancers/probes',
  loadBalancerName,
  probeName
)


//===================================================
// INTERNAL STANDARD LOAD BALANCER
//===================================================

resource loadBalancer 'Microsoft.Network/loadBalancers@2025-05-01' = {
  name: loadBalancerName
  location: location

  sku: {
    name: skuName
    tier: skuTier
  }

  properties: {

    //=================================================
    // FRONTEND IP
    //=================================================

    frontendIPConfigurations: [
      {
        name: frontendName

        properties: {
          privateIPAddress: frontendPrivateIp

          privateIPAllocationMethod: 'Static'

          subnet: {
            id: subnetId
          }
        }
      }
    ]


    //=================================================
    // BACKEND ADDRESS POOL
    //=================================================

    backendAddressPools: [
      {
        name: backendPoolName

        properties: {
          loadBalancerBackendAddresses: [
            for backend in backendAddresses: {
              name: backend.name

              properties: {
                ipAddress: backend.ipAddress

                subnet: {
                  id: subnetId
                }
              }
            }
          ]
        }
      }
    ]


    //=================================================
    // HEALTH PROBE
    //=================================================

    probes: [
      {
        name: probeName

        properties: {
          protocol: probeProtocol
          port: probePort
        }
      }
    ]


    //=================================================
    // LOAD BALANCING RULE
    //=================================================

    loadBalancingRules: [
      {
        name: ruleName

        properties: {
          frontendIPConfiguration: {
            id: frontendIpConfigurationId
          }

          backendAddressPool: {
            id: backendPoolId
          }

          probe: {
            id: probeId
          }

          protocol: ruleProtocol

          frontendPort: frontendPort

          backendPort: backendPort

          idleTimeoutInMinutes: idleTimeoutInMinutes

          enableFloatingIP: enableFloatingIp

          enableTcpReset: enableTcpReset
        }
      }
    ]
  }
}


//===================================================
// OUTPUTS
//===================================================

output loadBalancerId string = loadBalancer.id

output loadBalancerName string = loadBalancer.name

output frontendIpConfigurationId string = frontendIpConfigurationId

output backendPoolId string = backendPoolId

output frontendPrivateIp string = frontendPrivateIp

output probeId string = probeId
