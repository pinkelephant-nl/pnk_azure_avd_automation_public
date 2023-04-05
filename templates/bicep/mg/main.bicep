targetScope = 'tenant'

@sys.description('Prefix for the management group hierarchy. This management group will be created as part of the deployment. Default: alz')
@minLength(2)
@maxLength(10)
param CustomerID string = 'tst'

@sys.description('Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter. Default: Azure Landing Zones')
@minLength(2)
param CustomerFullName string = 'test'


@description('Tier 1 management groups. Must contain id and displayName properties.')
param tier1MgmtGroups array = [
{
          id: CustomerFullName
          displayName: CustomerFullName
          
        }

]

@description('Optional. Tier 2 management groups. Must contain id, displayName and ParentId properties.')
param tier2MgmtGroups array = [
{
          id: '${CustomerID}-platform'
          displayName: '${CustomerID}-platform'
          parentId: CustomerFullName
        }
        {
          id: '${CustomerID}-landingzones'
          displayName: '${CustomerID}-landingzones'
          parentId: CustomerFullName
        }
        {
          id: '${CustomerID}-sandbox'
          displayName: '${CustomerID}-sandbox'
          parentId: CustomerFullName
        }
        {
          id: '${CustomerID}-decommissioned'
          displayName: '${CustomerID}-decommissioned'
          parentId: CustomerFullName
        }
      
]

@description('Optional. Tier 3 management groups. Must contain id, displayName and ParentId properties.')
param tier3MgmtGroups array = [
{
          id: '${CustomerID}-platform-connectivity'
          displayName: '${CustomerID}-platform-connectivity'
          parentId: '${CustomerID}-platform'
        }
        {
          id: '${CustomerID}-platform-identity'
          displayName: '${CustomerID}-platform-identity'
          parentId: '${CustomerID}-platform'
        }
        {
          id: '${CustomerID}-platform-management'
          displayName: '${CustomerID}-platform-management'
          parentId: '${CustomerID}-platform'
        }
        {
          id: '${CustomerID}-landingzones-${CustomerID}'
          displayName: '${CustomerID}-landingzones-${CustomerID}'
          parentId: '${CustomerID}-landingzones'
        }
        {
          id: '${CustomerID}-landingzones-xxx'
          displayName: '${CustomerID}-landingzones-xxx'
          parentId: '${CustomerID}-landingzones'
        }
]

@description('Optional. Tier 4 management groups. Must contain id, displayName and ParentId properties.')
param tier4MgmtGroups array = [
{
          id: '${CustomerID}-landingzones-${CustomerID}-prod'
          displayName: '${CustomerID}-landingzones-${CustomerID}-prod'
          parentId: '${CustomerID}-landingzones-${CustomerID}'
        }
        {
          id: '${CustomerID}-landingzones-${CustomerID}-nonprod'
          displayName: '${CustomerID}-landingzones-${CustomerID}-nonprod'
          parentId: '${CustomerID}-landingzones-${CustomerID}'
        }
        {
          id: '${CustomerID}-landingzones-xxx-prod'
          displayName: '${CustomerID}-landingzones-xxx-prod'
          parentId: '${CustomerID}-landingzones-xxx'
        }
        {
          id: '${CustomerID}-landingzones-xxx-nonprod'
          displayName: '${CustomerID}-landingzones-xxx-nonprod'
          parentId: '${CustomerID}-landingzones-xxx'
        }
        
]

@description('Tier 5 management groups')
param tier5MgmtGroups array = []

@description('Tier 6 management groups')
param tier6MgmtGroups array = []

@description('Optional. Default Management group for new subscriptions.')
param defaultMgId string = '${CustomerID}-decommissioned'

@description('Optional. Indicates whether RBAC access is required upon group creation under the root Management Group. Default value is true')
param authForNewMG bool = true

@description('Optional. Indicates whether Settings for default MG for new subscription and permissions for creating new MGs are configured. This configuration is applied on Tenant Root MG.')
param configMGSettings bool = false

module mg_hierarchy './modules/managementGroupHierarchy.bicep' = {
  name: 'management_groups'
  params: {
    tier1MgmtGroups: tier1MgmtGroups
    tier2MgmtGroups: tier2MgmtGroups
    tier3MgmtGroups: tier3MgmtGroups
    tier4MgmtGroups: tier4MgmtGroups
    tier5MgmtGroups: tier5MgmtGroups
    tier6MgmtGroups: tier6MgmtGroups
    defaultMgId: defaultMgId
    authForNewMG: authForNewMG
    configMGSettings: configMGSettings
  }
}

output managementGroups array = mg_hierarchy.outputs.managementGroups
output root_mg_settings object = mg_hierarchy.outputs.root_mg_settings
output tier_1_mgs array = mg_hierarchy.outputs.tier_1_mgs
output tier_2_mgs array = mg_hierarchy.outputs.tier_2_mgs
output tier_3_mgs array = mg_hierarchy.outputs.tier_3_mgs
output tier_4_mgs array = mg_hierarchy.outputs.tier_4_mgs
output tier_5_mgs array = mg_hierarchy.outputs.tier_5_mgs
output tier_6_mgs array = mg_hierarchy.outputs.tier_6_mgs
