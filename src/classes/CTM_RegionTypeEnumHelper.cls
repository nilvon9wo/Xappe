public class CTM_RegionTypeEnumHelper {
    private CTM_RegionTypeEnumHelper() {
    }

    private static CTM_RegionTypeEnumHelper instance;

    public static CTM_RegionTypeEnumHelper getInstance() {
        if (instance == null) {
            instance = new CTM_RegionTypeEnumHelper();
        }
        return instance;
    }

    private static final Map<SObjectType, SObjectField> COUNTRY_FIELD_BY_SOBJECT_TYPE = new Map<SObjectType, SObjectField>{
            Account.SObjectType => Account.BillingCountry,
            Territory_Assignment__c.SObjectType => Territory_Assignment__c.Territory_Country__c
    };

    private static final Map<SObjectType, SObjectField> STATE_FIELD_BY_SOBJECT_TYPE = new Map<SObjectType, SObjectField>{
            Account.SObjectType => Account.BillingState,
            Territory_Assignment__c.SObjectType => Territory_Assignment__c.Territory_State__c
    };

    public CTM_RegionTypeEnum toEnum(Account account) {
        return this.toEnum((SObject) account);
    }

    public CTM_RegionTypeEnum toEnum(Territory_Assignment__c territoryAssignment) {
        return this.toEnum((SObject) territoryAssignment);
    }

    private CTM_RegionTypeEnum toEnum(SObject sObj) {
        SObjectType sObjectType = sObj.getSObjectType();
        String state = (String) sObj.get(STATE_FIELD_BY_SOBJECT_TYPE.get(sObjectType));
        String country = (String) sObj.get(COUNTRY_FIELD_BY_SOBJECT_TYPE.get(sObjectType));

        if (!String.isBlank(state)) {
            return CTM_RegionTypeEnum.STATE;
        }

        if (!String.isBlank(country)) {
            return CTM_RegionTypeEnum.COUNTRY;
        }

        throw new CTM_AmbiguousTerritoryException('Region Type can not be identified for: ' + sObj);
    }
}