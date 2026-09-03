targetScope = 'subscription'

@description('Deployment environment')
param environment string

@description('Default Azure location')
param location string

@description('Load Balancer configuration')
param landingZones object


//===================================================
// INTERNAL LOAD BALANCERS
//===================================================

module loadBalancerModule './networking/loadBalancer.bicep' = [
  for lb in landingZones.loadBalancers: {

    name: 'lb-${lb.loadBalancerName}-${environment}-${location}'

    scope: resourceGroup(lb.resourceGroupName)

    params: {
      loadBalancerName: lb.loadBalancerName
      location: lb.location

      skuName: lb.skuName
      skuTier: lb.skuTier

      frontendName: lb.frontendName
      frontendPrivateIp: lb.frontendPrivateIp
      subnetId: lb.subnetId

      backendPoolName: lb.backendPoolName
      backendAddresses: lb.backendAddresses

      probeName: lb.probeName
      probeProtocol: lb.probeProtocol
      probePort: lb.probePort

      ruleName: lb.ruleName
      ruleProtocol: lb.ruleProtocol
      frontendPort: lb.frontendPort
      backendPort: lb.backendPort

      idleTimeoutInMinutes: lb.idleTimeoutInMinutes
      enableFloatingIp: lb.enableFloatingIp
      enableTcpReset: lb.enableTcpReset
    }
  }
]
