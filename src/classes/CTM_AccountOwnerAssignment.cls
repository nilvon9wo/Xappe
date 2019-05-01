public class CTM_AccountOwnerAssignment implements XAP_TRIG_TriggerEventHandlerIntf {
	XAP_UTIL_SObjectValueSetExtractor setHelper;

	CTM_RegionTypeEnumHelper regionTypeEnumHelper;
	CTM_TerritoryRegionFieldHelper territoryRegionFieldHelper;
	DAO_TerritoryAssignmentSelector territoryAssignmentSelector;
	
	public CTM_AccountOwnerAssignment(
			XAP_UTIL_SObjectValueSetExtractor setHelper,

			CTM_RegionTypeEnumHelper regionTypeEnumHelper, 
			CTM_TerritoryRegionFieldHelper territoryRegionFieldHelper,
			DAO_TerritoryAssignmentSelector territoryAssignmentSelector
		) {
		this.setHelper = setHelper;

		this.regionTypeEnumHelper = regionTypeEnumHelper;
		this.territoryRegionFieldHelper = territoryRegionFieldHelper;
		this.territoryAssignmentSelector = territoryAssignmentSelector;
	}
	 
	public CTM_AccountOwnerAssignment() {
		this(
			XAP_UTIL_SObjectValueSetExtractor.getInstance(),
			
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
			Territory_Assignment__c territoryAssignment = getTerritotyAssignment(
				newAccount, 
				this.regionTypeEnumHelper.toEnum(newAccount), 
				territoryAssignmentByTerritoryRegionByRegionTypeMap
			);
			newAccount.OwnerId = territoryAssignment.Territory_Owner__c;
			newAccount.Territory__c = territoryAssignment.Territory__c;
		}
		return newAccountList;
	}
	
	private Territory_Assignment__c getTerritotyAssignment(
			Account newAccount, 
			CTM_RegionTypeEnum regionType, 
			Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>> territoryAssignmentByTerritoryRegionByRegionTypeMap
		) {
		String regionValue = (String) newAccount.get(this.territoryRegionFieldHelper.getAccountRegionField(regionType)); 

		Map<String, Territory_Assignment__c> territoryAssignmentByTerritoryRegionMap = territoryAssignmentByTerritoryRegionByRegionTypeMap.get(regionType);
		if (territoryAssignmentByTerritoryRegionMap != null) {
			return territoryAssignmentByTerritoryRegionMap.get(regionValue);
		}
		
		if (regionType == CTM_RegionTypeEnum.STATE) {
			return this.getTerritotyAssignment(newAccount, CTM_RegionTypeEnum.COUNTRY, territoryAssignmentByTerritoryRegionByRegionTypeMap);
		}
		
		throw new CTM_AmbiguousTerritoryException('No suitable territory found for: ' + regionType + ': ' + regionValue);
	}
	
	private Map<CTM_RegionTypeEnum, Set<String>> buildRegionSetByRegionTypeMap(List<Account> newAccountList) {
		return new Map<CTM_RegionTypeEnum, Set<String>> {
			CTM_RegionTypeEnum.COUNTRY => this.setHelper.extractNonBlanksFrom(newAccountList, Account.BillingCountry),
			CTM_RegionTypeEnum.STATE => this.setHelper.extractNonBlanksFrom(newAccountList, Account.BillingState)
		}; 
	}
}