public class XAP_DAO_SOQL_ChildRelationshipFinder {
    private XAP_DAO_SOQL_ChildRelationshipFinder() {
    }

    private static XAP_DAO_SOQL_ChildRelationshipFinder instance;
    public static XAP_DAO_SOQL_ChildRelationshipFinder getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_SOQL_ChildRelationshipFinder();
        }
        return instance;
    }

    private static final Map<SObjectType, Map<SObjectType, ChildRelationship>>
            CHILD_RELATIONSHIP_BY_CHILD_SOBJECT_TYPE_BY_SOBJECT_TYPE_MAP
                    = new Map<SObjectType, Map<SObjectType, ChildRelationship>>();

    private static final Map<SObjectType, Map<String, ChildRelationship>>
            CHILD_RELATIONSHIP_BY_CHILD_RELATIONSHIP_NAME_BY_SOBJECT_TYPE_MAP
                    = new Map<SObjectType, Map<String, ChildRelationship>>();

    public ChildRelationship getChildRelationship(SObjectType parentSObjectType, SObjectType childSObjectType) {
        Map<SObjectType, ChildRelationship> childRelationshipsBySObjectTypeMap
                = this.getChildRelationshipsBySObjectTypeMap(parentSObjectType);

        ChildRelationship childRelationship = childRelationshipsBySObjectTypeMap.get(childSObjectType);
        if (childRelationship != null) {
            return childRelationship;
        }

        throw new XAP_DAO_SOQL_NoRelationshipException(
                'No relationship possible between '
                        + parentSObjectType + ' and requested type =' + childSObjectType
        );
    }

    public ChildRelationship getChildRelationship(SObjectType parentSObjectType, String childRelationshipName) {
        return this.getChildRelationshipsByRelationshipNameMap(parentSObjectType)
                .get(childRelationshipName);
    }

    private Map<SObjectType, ChildRelationship> getChildRelationshipsBySObjectTypeMap(SObjectType parentSObjectType) {
        Map<SObjectType, ChildRelationship> childRelationshipsBySObjectTypeMap
                = CHILD_RELATIONSHIP_BY_CHILD_SOBJECT_TYPE_BY_SOBJECT_TYPE_MAP.get(parentSObjectType);

        if (childRelationshipsBySObjectTypeMap == null) {
            this.buildMaps(parentSObjectType);
            childRelationshipsBySObjectTypeMap
                    = CHILD_RELATIONSHIP_BY_CHILD_SOBJECT_TYPE_BY_SOBJECT_TYPE_MAP.get(parentSObjectType);
        }

        return childRelationshipsBySObjectTypeMap;
    }

    private Map<String, ChildRelationship> getChildRelationshipsByRelationshipNameMap(SObjectType parentSObjectType) {
        Map<String, ChildRelationship> childRelationshipsByRelationshipNameMap
                = CHILD_RELATIONSHIP_BY_CHILD_RELATIONSHIP_NAME_BY_SOBJECT_TYPE_MAP.get(parentSObjectType);

        if (childRelationshipsByRelationshipNameMap == null) {
            this.buildMaps(parentSObjectType);
            childRelationshipsByRelationshipNameMap
                    = CHILD_RELATIONSHIP_BY_CHILD_RELATIONSHIP_NAME_BY_SOBJECT_TYPE_MAP.get(parentSObjectType);
        }

        return childRelationshipsByRelationshipNameMap;
    }

    private XAP_DAO_SOQL_ChildRelationshipFinder buildMaps(SObjectType parentSObjectType) {
        Map<SObjectType, ChildRelationship> childRelationshipsBySObjectTypeMap
                = new  Map<SObjectType, ChildRelationship>();
        Map<String, ChildRelationship> childRelationshipsByRelationshipNameMap = new Map<String, ChildRelationship>();

        for (ChildRelationship childRow : parentSObjectType.getDescribe().getChildRelationships()) {
            childRelationshipsBySObjectTypeMap.put(childRow.getChildSObject(), childRow);
            childRelationshipsByRelationshipNameMap.put(childRow.getRelationshipName(), childRow);
        }

        CHILD_RELATIONSHIP_BY_CHILD_SOBJECT_TYPE_BY_SOBJECT_TYPE_MAP
                .put(parentSObjectType, childRelationshipsBySObjectTypeMap);
        CHILD_RELATIONSHIP_BY_CHILD_RELATIONSHIP_NAME_BY_SOBJECT_TYPE_MAP
                .put(parentSObjectType, childRelationshipsByRelationshipNameMap);

        return this;
    }

}