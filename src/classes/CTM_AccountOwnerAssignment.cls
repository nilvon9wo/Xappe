public class CTM_AccountOwnerAssignment implements XAP_TRIG_TriggerEventHandlerIntf {
	CTM_RegionTypeEnumHelper regionTypeEnumHelper;
	CTM_TerritoryRegionFieldHelper territoryRegionFieldHelper;
	DAO_TerritoryAssignmentSelector territoryAssignmentSelector;
	
	public CTM_AccountOwnerAssignment(
			CTM_RegionTypeEnumHelper regionTypeEnumHelper, 
			CTM_TerritoryRegionFieldHelper territoryRegionFieldHelper,
			DAO_TerritoryAssignmentSelector territoryAssignmentSelector
		) {
		this.regionTypeEnumHelper = regionTypeEnumHelper;
		this.territoryRegionFieldHelper = territoryRegionFieldHelper;
		this.territoryAssignmentSelector = territoryAssignmentSelector;
	}
	 
	public CTM_AccountOwnerAssignment() {
		this(
			CTM_RegionTypeEnumHelper.getInstance(), 
			CTM_TerritoryRegionFieldHelper.getInstance(), 
			DAO_TerritoryAssignmentSelector.getInstance()
		);  
	}	
	 
	public XAP_TRIG_TriggerEventHandlerIntf handle(XAP_TRIG_TriggerWrapper triggerWrapper) {
		List<Account> newAccountList = (List<Account>) triggerWrapper.newSObjectList;
		Map<CTM_RegionTypeEnum, Set<String>> regionSetByRegionTypeMap = this.buildRegionSetByRegionTypeMap(newAccountList);
		this.assignTerritories(newAccountList, this.territoryAssignmentSelector.selectCurrentByRegion(regionSetByRegionTypeMap));
		return this;
	} 
	
	private List<Account> assignTerritories(
			List<Account> newAccountList, 
			Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>> territoryAssignmentByTerritoryRegionByRegionTypeMap
		) {
		for (Account newAccount : newAccountList) {
			CTM_RegionTypeEnum regionType = this.regionTypeEnumHelper.toEnum(newAccount);
			Map<String, Territory_Assignment__c> territoryAssignmentByTerritoryRegionMap = territoryAssignmentByTerritoryRegionByRegionTypeMap.get(regionType);
			if (territoryAssignmentByTerritoryRegionMap == null) {
				throw new CTM_AmbiguousTerritoryException('No suitable territory found for: ' + regionType);
			}
			
			String regionValue = (String) newAccount.get(this.territoryRegionFieldHelper.getAccountRegionField(regionType)); 
			Territory_Assignment__c territoryAssignment = territoryAssignmentByTerritoryRegionMap.get(regionValue);
			if (territoryAssignment == null) {
				throw new CTM_AmbiguousTerritoryException('No suitable territory found for: ' + regionType + ': ' + regionValue);
			}
			  
			newAccount.OwnerId = territoryAssignment.Territory_Owner__c;
			newAccount.Territory__c = territoryAssignment.Territory__c;
		}
		return newAccountList;
	}
	
	private Map<CTM_RegionTypeEnum, Set<String>> buildRegionSetByRegionTypeMap(List<Account> newAccountList) {
		Map<CTM_RegionTypeEnum, Set<String>> regionByRegionTypeMap = new Map<CTM_RegionTypeEnum, Set<String>> {
			CTM_RegionTypeEnum.COUNTRY => new Set<String>(),
			CTM_RegionTypeEnum.STATE => new Set<String>()
		}; 
		for (Account newAccount : newAccountList) {
			CTM_RegionTypeEnum regionType = this.regionTypeEnumHelper.toEnum(newAccount);
			if (regionType != null) {
				regionByRegionTypeMap.get(regionType)
					.add((String) newAccount.get(this.territoryRegionFieldHelper.getAccountRegionField(regionType)));
			}
		}
		return regionByRegionTypeMap; 
	}
	
}