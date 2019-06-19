public class CTM_TerritoryRegionFieldHelper {
	private CTM_TerritoryRegionFieldHelper() {
	}

	private static CTM_TerritoryRegionFieldHelper instance;

	public static CTM_TerritoryRegionFieldHelper getInstance() {
		if (instance == null) {
			instance = new CTM_TerritoryRegionFieldHelper();
		}
		return instance;
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
