using '../modules/main.bicep'


//===================================================
// ENVIRONMENT
//===================================================

param environment = 'dev'

param location = 'centralus'


//===================================================
// LANDING ZONES
//===================================================

param landingZones = {

  //=================================================
  // INTERNAL LOAD BALANCER
  //=================================================

  loadBalancers: [

    {
      //=============================================
      // LOAD BALANCER
      //=============================================

      loadBalancerName: 'ilb-sql-ag-dev'

      resourceGroupName: 'rg-sql-ag-dev'

      location: location

      skuName: 'Standard'

      skuTier: 'Regional'


      //=============================================
      // EXISTING SQL SUBNET
      //=============================================

      subnetId: '/subscriptions/a98c3501-7e50-4380-a713-b02e7444f4e5/resourceGroups/rg-sql-ag-dev/providers/Microsoft.Network/virtualNetworks/vnet-sql-ag-dev/subnets/sql-subnet'


      //=============================================
      // ILB FRONTEND
      //=============================================

      frontendName: 'sql-ag-frontend'

      // This will also be the future AG listener IP
      frontendPrivateIp: '10.10.1.20'


      //=============================================
      // BACKEND POOL
      //=============================================

      backendPoolName: 'sql-ag-backend-pool'

      // SQL VMs don't exist yet.
      // Add their private IPs after VM creation.

      backendAddresses: []


      //=============================================
      // HEALTH PROBE
      //=============================================

      probeName: 'sql-ag-health-probe'

      probeProtocol: 'Tcp'

      probePort: 59999


      //=============================================
      // LOAD BALANCING RULE
      //=============================================

      ruleName: 'sql-ag-rule'

      ruleProtocol: 'Tcp'

      frontendPort: 1433

      backendPort: 1433

      idleTimeoutInMinutes: 4

      enableFloatingIp: true

      enableTcpReset: true
    }
  ]
}
