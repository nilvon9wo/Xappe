public class DAO_TerritoryAssignmentSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    CTM_RegionTypeEnumHelper regionTypeEnumHelper;
    CTM_TerritoryRegionFieldHelper territoryRegionFieldHelper;

    private DAO_TerritoryAssignmentSelector(
            CTM_RegionTypeEnumHelper regionTypeEnumHelper,
            CTM_TerritoryRegionFieldHelper
                    territoryRegionFieldHelper
    ) {
        this.regionTypeEnumHelper = regionTypeEnumHelper;
        this.territoryRegionFieldHelper = territoryRegionFieldHelper;
    }

    private DAO_TerritoryAssignmentSelector() {
        this(CTM_RegionTypeEnumHelper.getInstance(), CTM_TerritoryRegionFieldHelper.getInstance());
    }

    private static DAO_TerritoryAssignmentSelector instance;

    public static DAO_TerritoryAssignmentSelector getInstance() {
        if (instance == null) {
            instance = new DAO_TerritoryAssignmentSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return Territory_Assignment__c.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Territory_Assignment__c.Id,
                Territory_Assignment__c.Territory__c,
                Territory_Assignment__c.Territory_Country__c,
                Territory_Assignment__c.Territory_End_Date__c,
                Territory_Assignment__c.Territory_Owner__c,
                Territory_Assignment__c.Territory_Start_Date__c,
                Territory_Assignment__c.Territory_State__c
        };
    }

    public Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>> selectCurrentByRegion(
            Map<CTM_RegionTypeEnum, Set<String>> regionSetByRegionTypeMap
    ) {
        List<Territory_Assignment__c> territoryAssignmentList
                = this.selectByRegionAndDatetime(regionSetByRegionTypeMap, System.today());
        return this.buildTerritoryAssignmentByTerritoryRegionByRegionTypeMap(territoryAssignmentList);
    }

    private List<Territory_Assignment__c> selectByRegionAndDatetime(
            Map<CTM_RegionTypeEnum, Set<String>> regionSetByRegionTypeMap, Date targetDate
    ) {
        Set<String> countrySet = regionSetByRegionTypeMap.get(CTM_RegionTypeEnum.COUNTRY);
        Set<String> stateSet = regionSetByRegionTypeMap.get(CTM_RegionTypeEnum.STATE);

        return (List<Territory_Assignment__c>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_AndClause(new List<XAP_DAO_SOQL_WHERE_ClauseIntf>{
                                new XAP_DAO_SOQL_WHERE_DateComparisonClause(
                                        Territory_Assignment__c.Territory_Start_Date__c, XAP_DAO_SOQL_WHERE_CompareOperatorEnum.LESS_THAN_OR_EQUAL, targetDate
                                ),
                                new XAP_DAO_SOQL_WHERE_DateComparisonClause(
                                        Territory_Assignment__c.Territory_End_Date__c, XAP_DAO_SOQL_WHERE_CompareOperatorEnum.GREATER_THAN_OR_EQUAL, targetDate
                                ),
                                new XAP_DAO_SOQL_WHERE_OrClause(new List<XAP_DAO_SOQL_WHERE_ClauseIntf>{
                                        new XAP_DAO_SOQL_WHERE_InStringSetClause(Territory_Assignment__c.Territory_State__c, stateSet),
                                        new XAP_DAO_SOQL_WHERE_InStringSetClause(Territory_Assignment__c.Territory_Country__c, countrySet)
                                })
                        }))
                        .toSOQL()
        );
    }

    private Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>> buildTerritoryAssignmentByTerritoryRegionByRegionTypeMap(
            List<Territory_Assignment__c> territoryAssignmentList
    ) {
        Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>> territoryAssignmentByTerritoryRegionByRegionTypeMap
                = new Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>>();

        for (Territory_Assignment__c territoryAssignment : territoryAssignmentList) {
            CTM_RegionTypeEnum regionType = this.regionTypeEnumHelper.toEnum(territoryAssignment);
            if (territoryAssignmentByTerritoryRegionByRegionTypeMap.get(regionType) == null) {
                territoryAssignmentByTerritoryRegionByRegionTypeMap.put(regionType, new Map<String, Territory_Assignment__c>());
            }

            String regionValue = this.getRegionValue(territoryAssignment, regionType, territoryAssignmentByTerritoryRegionByRegionTypeMap);
            territoryAssignmentByTerritoryRegionByRegionTypeMap.get(regionType)
                    .put(regionValue, territoryAssignment);
        }
        return territoryAssignmentByTerritoryRegionByRegionTypeMap;
    }

    private String getRegionValue(
            Territory_Assignment__c territoryAssignment,
            CTM_RegionTypeEnum regionType,
            Map<CTM_RegionTypeEnum, Map<String, Territory_Assignment__c>> territoryAssignmentByTerritoryRegionByRegionTypeMap
    ) {
        Map<String, Territory_Assignment__c> territoryAssignmentByRegionTypeMap
                = territoryAssignmentByTerritoryRegionByRegionTypeMap.get(regionType);
        SObjectField regionField = this.territoryRegionFieldHelper.getTerritoryAssignmentRegionField(regionType);

        String regionValue = (String) territoryAssignment.get(regionField);
        if (regionValue == null) {
            throw new CTM_AmbiguousTerritoryException(
                    'No suitable territory found for: ' + regionType + ': ' + regionValue
            );
        }
        if (territoryAssignmentByRegionTypeMap.get(regionValue) != null) {
            throw new CTM_AmbiguousTerritoryException(
                    'Multiple suitable territories found for: ' + regionType + ': ' + regionValue
                            + 'including ' + territoryAssignmentByRegionTypeMap.get(regionValue) + ' and ' + territoryAssignment
            );
        }
        return regionValue;
    }
}
