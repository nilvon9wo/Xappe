/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_QueryFactory.cls
 */
public class XAP_DAO_SOQL_QueryFactory {
    XAP_DAO_SOQL_Querier querier;
    XAP_DAO_SOQL_SObjectFieldHelper fieldHelper;
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    public XAP_DAO_SOQL_QueryFactory(
            SObjectType sObjectType,
            XAP_DAO_SOQL_Querier querier,
            XAP_DAO_SOQL_SObjectFieldHelper fieldHelper,
            XAP_DAO_SOQL_SecurityUtils securityUtils
    ) {
        this.sObjectType = sObjectType;
        this.querier = querier;
        this.fieldHelper = fieldHelper;
        this.securityUtils = securityUtils;
    }

    public XAP_DAO_SOQL_QueryFactory(SObjectType sObjectType) {
        this(
                sObjectType,
                XAP_DAO_SOQL_Querier.getInstance(),
                XAP_DAO_SOQL_SObjectFieldHelper.getInstance(),
                XAP_DAO_SOQL_SecurityUtils.getInstance()
        );
    }

    private XAP_DAO_SOQL_QueryFactory(ChildRelationship relationship) {
        this(relationship.getChildSObject());
        this.childRelationship = relationship;
    }

    public SObjectType sObjectType { get; private set; }

    @TestVisible
    private Set<String> fieldSet = new Set<String>();
    private XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression;
    private Integer limitCount;
    private Integer offsetCount;
    private List<XAP_DAO_SOQL_QuerySortOrdering> orderingList = new List<XAP_DAO_SOQL_QuerySortOrdering>();

    private Boolean enforceFLS = XAP_DAO_SOQL_QueryInterpolationBuilder.EXCLUDING_FIELD_LEVEL_SECURITY;
    private Boolean sortSelectFields = XAP_DAO_SOQL_QueryInterpolationBuilder.INCLUDING_SORTED_SELECT_FIELDS;

    private ChildRelationship childRelationship;
    private Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> factoryByChildRelationshipMap;

    public Boolean equals(Object obj) {
        return obj instanceof XAP_DAO_SOQL_QueryFactory
                && ((XAP_DAO_SOQL_QueryFactory) obj).sObjectType == this.sObjectType
                && ((XAP_DAO_SOQL_QueryFactory) obj).fieldSet.size() == this.fieldSet.size()
                && ((XAP_DAO_SOQL_QueryFactory) obj).toSOQL() == this.toSOQL();
    }

    public XAP_DAO_SOQL_QueryFactory assertIsAccessible() {
        this.securityUtils.checkObjectIsReadable(this.sObjectType);
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setEnforceFLS(Boolean enforce) {
        this.enforceFLS = enforce;
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setSortSelectFields(Boolean doSort) {
        this.sortSelectFields = doSort;
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addField(String fieldName) {
        this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS));
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addField(Schema.SObjectField field) {
        if (field == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException(null, this.sObjectType);
        }
        if (this.enforceFLS) {
            this.securityUtils.checkFieldIsReadable(sObjectType, field);
        }
        this.fieldSet.add(this.fieldHelper.getFieldTokenPath(field));
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(List<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(Set<Schema.SObjectField> fields) {
        for (Schema.SObjectField token : fields) {
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException();
            }
            if (this.enforceFLS) {
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            }
            this.fieldSet.add(this.fieldHelper.getFieldTokenPath(token));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(List<Schema.SObjectField> fields) {
        for (Schema.SObjectField token : fields) {
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException();
            }
            if (this.enforceFLS) {
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            }
            this.fieldSet.add(this.fieldHelper.getFieldTokenPath(token));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(FieldSet fieldSet) {
        return selectFieldSet(fieldSet, true);
    }

    public XAP_DAO_SOQL_QueryFactory selectFieldSet(FieldSet fieldSet, Boolean allowCrossObject) {
        if (fieldSet.getSObjectType() != this.sObjectType) {
            throw new XAP_DAO_SOQL_InvalidFieldSetException('Field set "' + fieldSet.getName() + '" is not for SObject type "' + this.sObjectType + '"');
        }
        for (FieldSetMember field : fieldSet.getFields()) {
            if (!allowCrossObject && field.getFieldPath().contains('.')) {
                throw new XAP_DAO_SOQL_InvalidFieldSetException('Cross-object fields not allowed and field "' + field.getFieldPath() + '"" is a cross-object field.');
            }
            this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, field.getFieldPath(), this.enforceFLS));
        }
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

    public Integer getOffset() {
        return this.offsetCount;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(XAP_DAO_SOQL_QuerySortOrdering ordering) {
        this.orderingList.add(ordering);
        return this;
    }


    public XAP_DAO_SOQL_QueryFactory setOrdering(XAP_DAO_SOQL_QuerySortOrdering ordering) {
        this.orderingList = new List<XAP_DAO_SOQL_QuerySortOrdering>{
                ordering
        };
        return this;
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> getOrderings() {
        return this.orderingList;
    }


    public Set<String> getSelectedFields() {
        return this.fieldSet;
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(SObjectType related) {
        return setSubselectQuery(getChildRelationship(related), false);
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(SObjectType related, Boolean assertIsAccessible) {
        return setSubselectQuery(getChildRelationship(related), assertIsAccessible);
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(String relationshipName) {
        return subselectQuery(relationshipName, false);
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(String relationshipName, Boolean assertIsAccessible) {
        ChildRelationship relationship = getChildRelationship(relationshipName);
        if (relationship != null) {
            return setSubselectQuery(relationship, assertIsAccessible);
        }
        throw new XAP_DAO_SOQL_InvalidSubqueryException(
                'Invalid call to subselectQuery with relationshipName = ' + relationshipName
                        + '.  Relationship does not exist for ' + this.sObjectType.getDescribe().getName()
        );
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship relationship) {
        return subselectQuery(relationship, false);
    }


    public XAP_DAO_SOQL_QueryFactory subselectQuery(ChildRelationship relationship, Boolean assertIsAccessible) {
        return setSubselectQuery(relationship, assertIsAccessible);
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

        //The child queryFactory should be configured in the same way as the parent by default - can override after if required
        subselectQuery.setSortSelectFields(this.sortSelectFields);

        if (assertIsAccessible) {
            subselectQuery.assertIsAccessible();
        }
        this.factoryByChildRelationshipMap.put(relationship, subselectQuery);
        return subselectQuery;
    }

    public List<XAP_DAO_SOQL_QueryFactory> getSubselectQueries() {
        if (this.factoryByChildRelationshipMap != null) {
            return this.factoryByChildRelationshipMap.values();
        }
        return null;
    }

    private ChildRelationship getChildRelationship(SObjectType objType) {
        for (ChildRelationship childRow : this.sObjectType.getDescribe().getChildRelationships()) {
            //occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
            //if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getChildSObject() == objType && childRow.getRelationshipName() != null) {
                return childRow;
            }
        }
        throw new XAP_DAO_SOQL_InvalidSubqueryException(
                'Invalid call to subselectQuery.  Invalid relationship for table '
                        + this.sObjectType + ' and objtype=' + objType
        );
    }

    private ChildRelationship getChildRelationship(String relationshipName) {
        for (ChildRelationship childRow : this.sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getRelationshipName() == relationshipName) {
                return childRow;
            }
        }
        return null;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        this.orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS), direction, nullsLast)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(
            SObjectField field,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        this.orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldTokenPath(field), direction, nullsLast)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        this.orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS), direction)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        this.orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldTokenPath(field), direction)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        XAP_DAO_SOQL_QuerySortOrdering ordr
                = new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS), direction, nullsLast);
        return setOrdering(ordr);
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(
            SObjectField field,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        XAP_DAO_SOQL_QuerySortOrdering ordr
                = new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldTokenPath(field), direction, nullsLast);
        return setOrdering(ordr);
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        return setOrdering(new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, this.enforceFLS), direction));
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        return setOrdering(new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldTokenPath(field), direction));
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
        clone.orderingList = this.orderingList.clone();
        clone.fieldSet = this.fieldSet.clone();

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
        return (new XAP_DAO_SOQL_QueryInterpolationBuilder(this.sObjectType, this.fieldSet))
                .setConditionExpression(this.conditionExpression)
                .setEnforceFieldLevelSecurity(this.enforceFLS)
                .setSortSelectFields(this.sortSelectFields)
                .setChildRelationship(this.childRelationship)
                .setFactoryByChildRelationshipMap(this.factoryByChildRelationshipMap)
                .setOrderingList(this.orderingList)
                .setLimitCount(this.limitCount)
                .setOffsetCount(this.offsetCount)
                .toQueryInterpolation();
    }
}