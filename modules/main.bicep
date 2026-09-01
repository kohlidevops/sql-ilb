targetScope = 'subscription'


//===================================================
// PARAMETERS
//===================================================

param environment string

param location string

param landingZones object


//===================================================
// INTERNAL LOAD BALANCERS
//===================================================

module loadBalancerModule 'networking/loadBalancer.bicep' = [
  for lb in landingZones.loadBalancers: {

    name: 'ilb-${lb.loadBalancerName}-${environment}-${location}'

    scope: resourceGroup(lb.resourceGroupName)

    params: {

      loadBalancerName: lb.loadBalancerName

      location: lb.location

      skuName: lb.skuName

      skuTier: lb.skuTier

      subnetId: lb.subnetId

      frontendPrivateIp: lb.frontendPrivateIp

      frontendName: lb.frontendName

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
