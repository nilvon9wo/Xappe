public class XAP_DAO_SOQL_Subselector {
    SObjectType sObjectType;
    XAP_DAO_SOQL_ChildRelationshipFinder newChildRelationshipFinder;

    private XAP_DAO_SOQL_Subselector(
            SObjectType sObjectType,
            XAP_DAO_SOQL_ChildRelationshipFinder newChildRelationshipFinder) {
        this.sObjectType = sObjectType;
        this.newChildRelationshipFinder = newChildRelationshipFinder;
    }

    public XAP_DAO_SOQL_Subselector(SObjectType sObjectType) {
        this(sObjectType, XAP_DAO_SOQL_ChildRelationshipFinder.getInstance());
    }

    private static final Boolean ASSERT_ACCESSIBLE = true;
    private static final Boolean DO_NOT_ASSERT_ACCESSIBLE = false;

    private static final Boolean SORT_SELECTED_FIELDS = true;
    private static final Boolean DO_NOT_SORT_SELECTED_FIELDS = false;

    private Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> factoryByChildRelationshipMap;

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship existingChildRelationship, SObjectType newChileRelationshipType) {
        try {
            return this.setSubselectQuery(
                    existingChildRelationship,
                    this.newChildRelationshipFinder.getChildRelationship(this.sObjectType, newChileRelationshipType),
                    DO_NOT_ASSERT_ACCESSIBLE,
                    DO_NOT_SORT_SELECTED_FIELDS
            );
        }
        catch (XAP_DAO_SOQL_NoRelationshipException ex) {
            throw new XAP_DAO_SOQL_InvalidSubqueryException(ex.getMessage());
        }
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship existingChildRelationship, SObjectType newChileRelationshipType, Boolean assertIsAccessible) {
        return this.setSubselectQuery(
                existingChildRelationship,
                this.newChildRelationshipFinder.getChildRelationship(this.sObjectType, newChileRelationshipType),
                assertIsAccessible,
                DO_NOT_SORT_SELECTED_FIELDS
        );
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship existingChildRelationship, String newChildRelationshipName) {
        return this.subselectQuery(existingChildRelationship, newChildRelationshipName, false);
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship existingChildRelationship, String newChildRelationshipName, Boolean assertIsAccessible) {
        ChildRelationship relationship
                = this.newChildRelationshipFinder.getChildRelationship(this.sObjectType, newChildRelationshipName);
        if (relationship != null) {
            return this.setSubselectQuery(existingChildRelationship, relationship, assertIsAccessible, DO_NOT_SORT_SELECTED_FIELDS);
        }
        throw new XAP_DAO_SOQL_InvalidSubqueryException(
                'Invalid call to subselectQuery with newRelationshipName = ' + newChildRelationshipName
                        + '.  Relationship does not exist for ' + this.sObjectType.getDescribe().getName()
        );
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship existingChildRelationship, ChildRelationship newChildRelationship) {
        return this.subselectQuery(existingChildRelationship, newChildRelationship, DO_NOT_ASSERT_ACCESSIBLE, DO_NOT_SORT_SELECTED_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship existingChildRelationship, ChildRelationship newChildRelationship, Boolean assertIsAccessible) {
        return this.subselectQuery(existingChildRelationship, newChildRelationship, assertIsAccessible, DO_NOT_SORT_SELECTED_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(
            ChildRelationship existingChildRelationship,
            ChildRelationship newChildRelationship,
            Boolean assertIsAccessible,
            Boolean sortSelectFields
    ) {
        return this.setSubselectQuery(existingChildRelationship, newChildRelationship, assertIsAccessible, sortSelectFields);
    }


    public XAP_DAO_SOQL_QueryFactory setSubselectQuery(
            ChildRelationship existingChildRelationship,
            ChildRelationship newChildRelationship,
            Boolean assertIsAccessible,
            Boolean sortSelectFields
    ) {
        if (existingChildRelationship != null) {
            throw new XAP_DAO_SOQL_InvalidSubqueryException(
                    'Invalid call to subselectQuery.  You may not add a subselect query to a subselect query.'
            );
        }
        if (this.factoryByChildRelationshipMap == null) {
            this.factoryByChildRelationshipMap = new Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory>();
        }
        if (this.factoryByChildRelationshipMap.containsKey(newChildRelationship)) {
            return this.factoryByChildRelationshipMap.get(newChildRelationship);
        }

        XAP_DAO_SOQL_QueryFactory subselectQuery = new XAP_DAO_SOQL_QueryFactory(newChildRelationship)
            .setSortSelectFields(sortSelectFields);

        if (assertIsAccessible) {
            subselectQuery.assertIsAccessible();
        }

        this.factoryByChildRelationshipMap.put(newChildRelationship, subselectQuery);
        return subselectQuery;
    }

    public List<XAP_DAO_SOQL_QueryFactory> getSubselectQueries() {
        return (this.factoryByChildRelationshipMap != null)
                ? this.factoryByChildRelationshipMap.values()
                : null;
    }
}