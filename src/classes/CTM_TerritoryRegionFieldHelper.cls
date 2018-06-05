public class CTM_TerritoryRegionFieldHelper {
	private CTM_TerritoryRegionFieldHelper() {
	}
	
	private static CTM_TerritoryRegionFieldHelper INSTANCE;
	
	public static CTM_TerritoryRegionFieldHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new CTM_TerritoryRegionFieldHelper();
		}
		return INSTANCE;
	}
	 
	
	public SObjectField getTerritoryAssignmentRegionField(CTM_RegionTypeEnum regionType) {
		return (CTM_RegionTypeEnum.COUNTRY.equals(regionType)) 
				? Territory_Assignment__c.Territory_Country__c 
				: Territory_Assignment__c.Territory_State__c;
	}

	public SObjectField getAccountRegionField(CTM_RegionTypeEnum regionType) {
		return (CTM_RegionTypeEnum.COUNTRY.equals(regionType)) 
				? Account.BillingCountry 
				: Account.BillingState;
	}
    
}