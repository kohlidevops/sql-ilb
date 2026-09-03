@description('Load Balancer name')
param loadBalancerName string

@description('Azure region')
param location string

@description('Load Balancer SKU name')
param skuName string

@description('Load Balancer SKU tier')
param skuTier string

@description('Existing subnet resource ID')
param subnetId string

@description('Frontend IP configuration name')
param frontendName string

@description('Static frontend private IP')
param frontendPrivateIp string

@description('Backend pool name')
param backendPoolName string

@description('Backend IP addresses')
param backendAddresses array

@description('Health probe name')
param probeName string

@description('Health probe protocol')
param probeProtocol string

@description('Health probe port')
param probePort int

@description('Load balancing rule name')
param ruleName string

@description('Load balancing rule protocol')
param ruleProtocol string

@description('Frontend port')
param frontendPort int

@description('Backend port')
param backendPort int

@description('Idle timeout')
param idleTimeoutInMinutes int

@description('Enable Floating IP / DSR')
param enableFloatingIp bool

@description('Enable TCP reset')
param enableTcpReset bool


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
// INTERNAL LOAD BALANCER
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
    // FRONTEND
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
    // BACKEND POOL
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


output loadBalancerId string = loadBalancer.id

output loadBalancerName string = loadBalancer.name

output frontendIpConfigurationId string = frontendIpConfigurationId

output backendPoolId string = backendPoolId

output frontendPrivateIp string = frontendPrivateIp

output probeId string = probeId
