# sql-ilb

```
cd ~/sql-ag-ilb
```

# 1. Build

```
az bicep build \
  --file modules/main.bicep
```

# 2. Validate

```
az deployment sub validate \
  --location centralus \
  --template-file modules/main.bicep \
  --parameters environments/dev.bicepparam
```

# 3. What-If

```
az deployment sub what-if \
  --location centralus \
  --template-file modules/main.bicep \
  --parameters environments/dev.bicepparam
```

# 4. Deploy

```
az deployment sub create \
  --location centralus \
  --template-file modules/main.bicep \
  --parameters environments/dev.bicepparam
```

# Verify Template 2

## Check Load Balancer

```
az network lb show \
  --resource-group rg-sql-ag-dev \
  --name ilb-sql-ag-dev \
  --query "{Name:name,SKU:sku.name,Location:location}" \
  --output table
```

## Check Frontend

```
az network lb frontend-ip list \
  --resource-group rg-sql-ag-dev \
  --lb-name ilb-sql-ag-dev \
  --query "[].{Name:name,PrivateIP:privateIPAddress,PublicIP:publicIPAddress.id,Subnet:subnet.id}" \
  --output table
```

## Check Backend Pool

```
az network lb address-pool list \
  --resource-group rg-sql-ag-dev \
  --lb-name ilb-sql-ag-dev \
  --output table
```

## Check Health Probe

```
az network lb probe list \
  --resource-group rg-sql-ag-dev \
  --lb-name ilb-sql-ag-dev \
  --query "[].{Name:name,Protocol:protocol,Port:port}" \
  --output table
```

## Check Load Balancing Rule

```
az network lb rule list \
  --resource-group rg-sql-ag-dev \
  --lb-name ilb-sql-ag-dev \
  --query "[].{Name:name,Protocol:protocol,FrontendPort:frontendPort,BackendPort:backendPort,FloatingIP:enableFloatingIP,TcpReset:enableTcpReset}" \
  --output table
```
