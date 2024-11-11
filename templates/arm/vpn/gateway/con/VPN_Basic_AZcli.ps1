az network vnet show --name sme-vnet-pl-con-prd-westeu-001 --resource-group (($parameter.customerid.value) +'-pl-connectivity-net-prd-001')

az network vnet-gateway create `
        --name ($($parameter.customerId.value) +'-vgw1-' +'pl-con' +'-' +$($parameter.vpnsku.value).ToLower() +'-' +$($parameter.customerFullName.value).ToLower() +'_main' +'-prd' +'-westeu-001') `
        --resource-group (($parameter.customerid.value) +'-pl-connectivity-net-prd-001') `
        --public-ip-address ($($parameter.customerId.value) +'-pip' +'-' +'pl-con' +'-' +'vgw_' +$($parameter.customerId.value) +'-prd-westeu-001') `
        --vnet "/subscriptions/e88a6a72-8ca1-4535-b7b3-1af6e91e98a6/resourceGroups/sme-pl-connectivity-net-prd-001/providers/Microsoft.Network/virtualNetworks/sme-vnet-pl-con-prd-westeu-001" `
        --gateway-type Vpn `
        --vpn-gateway-generation Generation1 `
        --sku Basic `
        --vpn-type RouteBased `
        --no-wait
