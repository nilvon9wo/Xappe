public class CTM_RegionTypeEnumHelper {
	private CTM_RegionTypeEnumHelper() {
	}

	private static CTM_RegionTypeEnumHelper INSTANCE; 
	
	public static CTM_RegionTypeEnumHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new CTM_RegionTypeEnumHelper();
		}
		return INSTANCE;
	}
	
   	public static final Boolean HAS_COUNTRY = true;
   	public static final Boolean NO_COUNTRY = false;
   	
	public CTM_RegionTypeEnum toEnum(Account account) {
		if (String.isBlank(account.BillingState)) {
			return null;
		}
		return this.toEnum(!String.isBlank(account.BillingCountry));
	}

	public CTM_RegionTypeEnum toEnum(Territory_Assignment__c territoryAssignment) {
		if (String.isBlank(territoryAssignment.Territory_State__c)) {
			return null;
		}
		return this.toEnum(!String.isBlank(territoryAssignment.Territory_Country__c));
	}
   	
   	public CTM_RegionTypeEnum toEnum(Boolean value) {
   		return HAS_COUNTRY
   			? CTM_RegionTypeEnum.COUNTRY
   			: CTM_RegionTypeEnum.STATE;
   	}
}