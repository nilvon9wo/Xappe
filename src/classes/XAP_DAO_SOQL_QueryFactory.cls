/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see:
 * https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_QueryFactory.cls
 */
public class XAP_DAO_SOQL_QueryFactory {
    final XAP_DAO_SOQL_ChildRelationshipFinder childRelationshipFinder;
    final XAP_DAO_SOQL_OrderingCollection orderingCollection;
    final XAP_DAO_SOQL_Querier querier;
    final XAP_DAO_SOQL_SObjectFieldCollection fieldSetCollection;
    final XAP_DAO_SOQL_SecurityUtils securityUtils;

    public XAP_DAO_SOQL_QueryFactory(
            SObjectType sObjectType,
            XAP_DAO_SOQL_ChildRelationshipFinder childRelationshipFinder,
            XAP_DAO_SOQL_OrderingCollection orderListWrapper,
            XAP_DAO_SOQL_Querier querier,
            XAP_DAO_SOQL_SObjectFieldCollection fieldSetWrapper,
            XAP_DAO_SOQL_SecurityUtils securityUtils
    ) {
        this.sObjectType = sObjectType;
        this.childRelationshipFinder = childRelationshipFinder;
        this.orderingCollection = orderListWrapper;
        this.querier = querier;
        this.fieldSetCollection = fieldSetWrapper;
        this.securityUtils = securityUtils;
    }

    public XAP_DAO_SOQL_QueryFactory(SObjectType sObjectType) {
        this(
                sObjectType,
                XAP_DAO_SOQL_ChildRelationshipFinder.getInstance(),
                new XAP_DAO_SOQL_OrderingCollection(sObjectType),
                XAP_DAO_SOQL_Querier.getInstance(),
                new XAP_DAO_SOQL_SObjectFieldCollection(sObjectType),
                XAP_DAO_SOQL_SecurityUtils.getInstance()
        );
    }

    private XAP_DAO_SOQL_QueryFactory(ChildRelationship childRelationship) {
        this(childRelationship.getChildSObject());
        this.childRelationship = childRelationship;
    }

    private static final Boolean DO_NOT_ASSERT_ACCESSIBLE = false;

    public SObjectType sObjectType { get; private set; }

    @TestVisible
    private XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression;
    private Integer limitCount;
    private Integer offsetCount;
    private Boolean enforceFLS = XAP_DAO_SOQL_QueryInterpolationBuilder.EXCLUDING_FIELD_LEVEL_SECURITY;
    private Boolean enforceSecurity = false;
    private Boolean sortSelectFields = XAP_DAO_SOQL_QueryInterpolationBuilder.INCLUDING_SORTED_SELECT_FIELDS;

    private ChildRelationship childRelationship;
    private Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> factoryByChildRelationshipMap;

    public Boolean equals(Object obj) {
        return obj instanceof XAP_DAO_SOQL_QueryFactory
                && ((XAP_DAO_SOQL_QueryFactory) obj).sObjectType == this.sObjectType
                && ((XAP_DAO_SOQL_QueryFactory) obj).fieldSetCollection == this.fieldSetCollection
                && ((XAP_DAO_SOQL_QueryFactory) obj).toSOQL() == this.toSOQL();
    }

    public XAP_DAO_SOQL_QueryFactory assertIsAccessible() {
        this.securityUtils.checkObjectIsReadable(this.sObjectType);
        return this;
    }

    //noinspection ApexUnusedDeclaration,ProblematicWhitespace
    public XAP_DAO_SOQL_QueryFactory setEnforceFLS() {
        return this.setEnforceFLS(true);
    }

    public XAP_DAO_SOQL_QueryFactory setEnforceFLS(Boolean enforce) {
        this.enforceFLS = enforce;
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setSecurityEnforced() {
        return this.setSecurityEnforced(true);
    }

    public XAP_DAO_SOQL_QueryFactory setSecurityEnforced(Boolean enforce) {
        this.enforceSecurity = enforce;
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setSortSelectFields(Boolean doSort) {
        this.sortSelectFields = doSort;
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addField(String fieldName) {
        this.fieldSetCollection.add(fieldName, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addField(SObjectField field) {
        this.fieldSetCollection.add(field, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(Set<String> fieldNames) {
        this.fieldSetCollection.add(fieldNames, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(List<String> fieldNames) {
        this.fieldSetCollection.add(fieldNames, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(Set<SObjectField> fields) {
        this.fieldSetCollection.add(fields, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(List<SObjectField> fields) {
        this.fieldSetCollection.add(fields, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(FieldSet fieldSet) {
        this.fieldSetCollection.add(fieldSet, this.enforceFLS, XAP_DAO_SOQL_SObjectFieldCollection.ALLOW_CROSS_OBJECTS);
        return this;
    }

    //noinspection ApexUnusedDeclaration
    public XAP_DAO_SOQL_QueryFactory addFields(FieldSet fieldSet, Boolean allowCrossObject) {
        this.fieldSetCollection.add(fieldSet, this.enforceFLS, allowCrossObject);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setCondition(XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression) {
        this.conditionExpression = conditionExpression;
        return this;
    }

    public XAP_DAO_SOQL_WHERE_ClauseIntf getCondition() {
        return this.conditionExpression;
    }

    public XAP_DAO_SOQL_QueryFactory setLimit(Integer limitCount) {
        this.limitCount = limitCount;
        return this;
    }

    public Integer getLimit() {
        return this.limitCount;
    }

    public XAP_DAO_SOQL_QueryFactory setOffset(Integer offsetCount) {
        this.offsetCount = offsetCount;
        return this;
    }

    //noinspection ApexUnusedDeclaration
    public Integer getOffset() {
        return this.offsetCount;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(XAP_DAO_SOQL_QuerySortOrdering ordering) {
        this.orderingCollection.add(ordering);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(
            String fieldName,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        this.orderingCollection.add(fieldName, direction, nullsLast, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(
            SObjectField field,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        this.orderingCollection.add(field, direction, nullsLast);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        this.orderingCollection.add(fieldName, direction, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        this.orderingCollection.add(field, direction, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(
            String fieldName,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        this.orderingCollection.set(fieldName, direction, nullsLast, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(
            SObjectField field,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        this.orderingCollection.set(field, direction, nullsLast);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        this.orderingCollection.set(fieldName, direction, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        this.orderingCollection.set(field, direction, this.enforceFLS);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(XAP_DAO_SOQL_QuerySortOrdering ordering) {
        this.orderingCollection.set(ordering);
        return this;
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> getOrderings() {
        return this.orderingCollection.toList();
    }

    public Set<String> getSelectedFields() {
        return this.fieldSetCollection.toSet();
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(SObjectType related) {
        try {
            return this.setSubselectQuery(
                    this.childRelationshipFinder.getChildRelationship(this.sObjectType, related),
                    DO_NOT_ASSERT_ACCESSIBLE
            );
        } catch (XAP_DAO_SOQL_NoRelationshipException ex) {
            throw new XAP_DAO_SOQL_InvalidSubqueryException(ex.getMessage());
        }
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(SObjectType related, Boolean assertIsAccessible) {
        return this.setSubselectQuery(
                this.childRelationshipFinder.getChildRelationship(this.sObjectType, related),
                assertIsAccessible
        );
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(String relationshipName) {
        return this.subselectQuery(relationshipName, false);
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(String relationshipName, Boolean assertIsAccessible) {
        ChildRelationship relationship
                = this.childRelationshipFinder.getChildRelationship(this.sObjectType, relationshipName);
        if (relationship != null) {
            return this.setSubselectQuery(relationship, assertIsAccessible);
        }
        throw new XAP_DAO_SOQL_InvalidSubqueryException(
                'Invalid call to subselectQuery with relationshipName = ' + relationshipName
                        + '.  Relationship does not exist for ' + this.sObjectType.getDescribe().getName()
        );
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship relationship) {
        return this.subselectQuery(relationship, false);
    }

    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship relationship, Boolean assertIsAccessible) {
        return this.setSubselectQuery(relationship, assertIsAccessible);
    }

    private XAP_DAO_SOQL_QueryFactory setSubselectQuery(ChildRelationship relationship, Boolean assertIsAccessible) {
        if (this.childRelationship != null) {
            throw new XAP_DAO_SOQL_InvalidSubqueryException(
                    'Invalid call to subselectQuery.  You may not add a subselect query to a subselect query.'
            );
        }
        if (this.factoryByChildRelationshipMap == null) {
            this.factoryByChildRelationshipMap = new Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory>();
        }
        if (this.factoryByChildRelationshipMap.containsKey(relationship)) {
            return this.factoryByChildRelationshipMap.get(relationship);
        }

        XAP_DAO_SOQL_QueryFactory subselectQuery = new XAP_DAO_SOQL_QueryFactory(relationship);

        //The child queryFactory should be configured in the same way as the parent by default
        // - can override after if required
        subselectQuery.setSortSelectFields(this.sortSelectFields);

        if (assertIsAccessible) {
            subselectQuery.assertIsAccessible();
        }
        this.factoryByChildRelationshipMap.put(relationship, subselectQuery);
        return subselectQuery;
    }

    public List<XAP_DAO_SOQL_QueryFactory> getSubselectQueries() {
        return (this.factoryByChildRelationshipMap != null)
                ? this.factoryByChildRelationshipMap.values()
                : null;
    }

    public XAP_DAO_SOQL_QueryFactory deepClone() {
        XAP_DAO_SOQL_QueryFactory clone = new XAP_DAO_SOQL_QueryFactory(this.sObjectType)
                .setLimit(this.limitCount)
                .setOffset(this.offsetCount)
                .setCondition(this.conditionExpression)
                .setEnforceFLS(this.enforceFLS);

        Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> subqueries = this.factoryByChildRelationshipMap;
        if (subqueries != null) {
            Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> clonedSubqueries
                    = new Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory>();
            for (ChildRelationship key : subqueries.keySet()) {
                clonedSubqueries.put(key, subqueries.get(key).deepClone());
            }
            clone.factoryByChildRelationshipMap = clonedSubqueries;
        }

        clone.childRelationship = this.childRelationship;
        clone.orderingCollection.set(this.orderingCollection.toList().clone());
        clone.fieldSetCollection.add(this.fieldSetCollection, this.enforceFLS);
        return clone;
    }

    public String toSOQL() {
        return toQueryInterpolation().template;
    }

    public List<SObject> query() {
        return this.querier.selectFor(this.toQueryInterpolation());
    }

    public Database.QueryLocator getQueryLocator() {
        return this.querier.getQueryLocatorFor(this.toQueryInterpolation());
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        return (new XAP_DAO_SOQL_QueryInterpolationBuilder(this.sObjectType, this.fieldSetCollection))
                .setConditionExpression(this.conditionExpression)
                .setEnforceFieldLevelSecurity(this.enforceFLS)
                .setEnforceSecurity(this.enforceSecurity)
                .setSortSelectFields(this.sortSelectFields)
                .setChildRelationship(this.childRelationship)
                .setFactoryByChildRelationshipMap(this.factoryByChildRelationshipMap)
                .setOrderingList(this.orderingCollection)
                .setLimitCount(this.limitCount)
                .setOffsetCount(this.offsetCount)
                .toQueryInterpolation();
    }

    public override Integer hashCode() {
        Integer result = childRelationshipFinder != null ? System.hashCode(childRelationshipFinder) : 0;
        result = (31 * result) + (orderingCollection != null ? System.hashCode(orderingCollection) : 0);
        result = (31 * result) + (querier != null ? System.hashCode(querier) : 0);
        result = (31 * result) + (fieldSetCollection != null ? System.hashCode(fieldSetCollection) : 0);
        result = (31 * result) + (securityUtils != null ? System.hashCode(securityUtils) : 0);
        result = (31 * result) + (conditionExpression != null ? System.hashCode(conditionExpression) : 0);
        result = (31 * result) + System.hashCode(limitCount);
        result = (31 * result) + System.hashCode(offsetCount);
        result = (31 * result) + System.hashCode(enforceFLS);
        result = (31 * result) + System.hashCode(enforceSecurity);
        result = (31 * result) + System.hashCode(sortSelectFields);
        result = (31 * result) + (childRelationship != null ? System.hashCode(childRelationship) : 0);
        result = (31 * result) + (factoryByChildRelationshipMap != null
                ? System.hashCode(factoryByChildRelationshipMap)
                : 0);
        result = (31 * result) + System.hashCode(sObjectType);
        return result;
    }
}