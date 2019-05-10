/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_QueryFactory.cls
 */
public class XAP_DAO_SOQL_QueryFactory {
    private XAP_DAO_SOQL_Querier querier;
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    public XAP_DAO_SOQL_QueryFactory(
            SObjectType sObjectType,
            XAP_DAO_SOQL_Querier querier,
            XAP_DAO_SOQL_SecurityUtils securityUtils
    ) {
        this.sObjectType = sObjectType;
        this.querier = querier;
        this.securityUtils = securityUtils;
    }

    public XAP_DAO_SOQL_QueryFactory(SObjectType sObjectType) {
        this(sObjectType, XAP_DAO_SOQL_Querier.getInstance(), XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    public static final Boolean INCLUDING_FIELD_LEVEL_SECURITY = true;
    public static final Boolean EXCLUDING_FIELD_LEVEL_SECURITY = false;

    public static final Boolean INCLUDING_SORTED_SELECT_FIELDS = true;
    public static final Boolean EXCLUDING_SORTED_SELECT_FIELDS = false;

    public SObjectType sObjectType { get; private set; }

    @TestVisible
    private Set<String> fieldSet = new Set<String>();
    private XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression;
    private Integer limitCount;
    private Integer offsetCount;
    private List<XAP_DAO_SOQL_QuerySortOrdering> orderingList = new List<XAP_DAO_SOQL_QuerySortOrdering>();

    private Boolean enforceFLS = EXCLUDING_FIELD_LEVEL_SECURITY;
    private Boolean sortSelectFields = INCLUDING_SORTED_SELECT_FIELDS;

    private Schema.ChildRelationship childRelationship;
    private Map<Schema.ChildRelationship, XAP_DAO_SOQL_QueryFactory> factoryByChildRelationshipMap;

    private String getFieldPath(String fieldName) {
        return (this.isSingleField(fieldName))
                ? this.getFieldName(fieldName).getDescribe().getName()
                : this.traverseFieldKeyRelationships(fieldName);
    }

    private Boolean isSingleField(String fieldName) {
        return !fieldName.contains('.');
    }

    private SObjectField getFieldName(String fieldName) {
        Schema.SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(sObjectType)
                .getField(fieldName.toLowerCase());
        if (token == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException(fieldName, this.sObjectType);
        }

        if (enforceFLS) {
            this.securityUtils.checkFieldIsReadable(this.sObjectType, token);
        }
        return token;
    }

    private String traverseFieldKeyRelationships(String fieldPathString) {
        List<String> fieldPath = new List<String>();
        SObjectType lastSObjectType = sObjectType;
        Iterator<String> fieldPathPartIterator = fieldPathString.split('\\.').iterator();
        while (fieldPathPartIterator.hasNext()) {
            String field = fieldPathPartIterator.next();
            Schema.SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(lastSObjectType)
                    .getField(field.toLowerCase());
            DescribeFieldResult tokenDescribe = token != null ? token.getDescribe() : null;

            if (token != null && enforceFLS) {
                this.securityUtils.checkFieldIsReadable(lastSObjectType, token);
            }

            if (token != null && fieldPathPartIterator.hasNext() && tokenDescribe.getSoapType() == Schema.SoapType.ID) {
                lastSObjectType = tokenDescribe.getReferenceTo()[0]; //if it's polymorphic doesn't matter which one we get
                fieldPath.add(tokenDescribe.getRelationshipName());
            }
            else if (token != null && !fieldPathPartIterator.hasNext()) {
                fieldPath.add(tokenDescribe.getName());
            }
            else {
                if (token == null) {
                    throw new XAP_DAO_SOQL_InvalidFieldException(field, lastSObjectType);
                }
                else {
                    throw new XAP_DAO_SOQL_NonReferenceFieldException(
                            lastSObjectType + '.' + field
                                    + ' is not a lookup or master-detail field'
                                    + 'but is used in a cross-object query field.'
                    );
                }
            }
        }

        return String.join(fieldPath, '.');
    }


    @TestVisible
    private static String getFieldTokenPath(Schema.SObjectField field) {
        if (field == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException('Invalid field: null');
        }
        return field.getDescribe().getName();
    }

    public Boolean equals(Object obj) {
        return obj instanceof XAP_DAO_SOQL_QueryFactory
                && ((XAP_DAO_SOQL_QueryFactory) obj).sObjectType == this.sObjectType
                && ((XAP_DAO_SOQL_QueryFactory) obj).fieldSet.size() == this.fieldSet.size()
                && ((XAP_DAO_SOQL_QueryFactory) obj).toSOQL() == this.toSOQL();
    }

    private XAP_DAO_SOQL_QueryFactory(Schema.ChildRelationship relationship) {
        this(relationship.getChildSObject());
        this.childRelationship = relationship;
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
        this.fieldSet.add(getFieldPath(fieldName));
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addField(Schema.SObjectField field) {
        if (field == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException(null, this.sObjectType);
        }
        if (enforceFLS) {
            this.securityUtils.checkFieldIsReadable(sObjectType, field);
        }
        this.fieldSet.add(getFieldTokenPath(field));
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldSet.add(getFieldPath(fieldName));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(List<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldSet.add(getFieldPath(fieldName));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(Set<Schema.SObjectField> fields) {
        for (Schema.SObjectField token : fields) {
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException();
            }
            if (enforceFLS) {
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            }
            this.fieldSet.add(getFieldTokenPath(token));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(List<Schema.SObjectField> fields) {
        for (Schema.SObjectField token : fields) {
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException();
            }
            if (enforceFLS) {
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            }
            this.fieldSet.add(getFieldTokenPath(token));
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addFields(FieldSet fieldSet) {
        return selectFieldSet(fieldSet, true);
    }

    public XAP_DAO_SOQL_QueryFactory selectFieldSet(FieldSet fieldSet, Boolean allowCrossObject) {
        if (fieldSet.getSObjectType() != sObjectType) {
            throw new XAP_DAO_SOQL_InvalidFieldSetException('Field set "' + fieldSet.getName() + '" is not for SObject type "' + sObjectType + '"');
        }
        for (FieldSetMember field : fieldSet.getFields()) {
            if (!allowCrossObject && field.getFieldPath().contains('.')) {
                throw new XAP_DAO_SOQL_InvalidFieldSetException('Cross-object fields not allowed and field "' + field.getFieldPath() + '"" is a cross-object field.');
            }
            this.fieldSet.add(this.getFieldPath(field.getFieldPath()));
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

    public XAP_DAO_SOQL_QueryFactory addOrdering(XAP_DAO_SOQL_QuerySortOrdering o) {
        this.orderingList.add(o);
        return this;
    }


    public XAP_DAO_SOQL_QueryFactory setOrdering(XAP_DAO_SOQL_QuerySortOrdering o) {
        this.orderingList = new List<XAP_DAO_SOQL_QuerySortOrdering>{
                o
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
                        + '.  Relationship does not exist for ' + sObjectType.getDescribe().getName()
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
            return factoryByChildRelationshipMap.get(relationship);
        }

        XAP_DAO_SOQL_QueryFactory subselectQuery = new XAP_DAO_SOQL_QueryFactory(relationship);

        //The child queryFactory should be configured in the same way as the parent by default - can override after if required
        subselectQuery.setSortSelectFields(sortSelectFields);

        if (assertIsAccessible) {
            subselectQuery.assertIsAccessible();
        }
        factoryByChildRelationshipMap.put(relationship, subselectQuery);
        return subselectQuery;
    }

    public List<XAP_DAO_SOQL_QueryFactory> getSubselectQueries() {
        if (factoryByChildRelationshipMap != null) {
            return factoryByChildRelationshipMap.values();
        }
        return null;
    }

    private Schema.ChildRelationship getChildRelationship(SObjectType objType) {
        for (Schema.ChildRelationship childRow : sObjectType.getDescribe().getChildRelationships()) {
            //occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
            //if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getChildSObject() == objType && childRow.getRelationshipName() != null) {
                return childRow;
            }
        }
        throw new XAP_DAO_SOQL_InvalidSubqueryException(
                'Invalid call to subselectQuery.  Invalid relationship for table '
                        + sObjectType + ' and objtype=' + objType
        );
    }

    private Schema.ChildRelationship getChildRelationship(String relationshipName) {
        for (Schema.ChildRelationship childRow : sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getRelationshipName() == relationshipName) {
                return childRow;
            }
        }
        return null;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(getFieldPath(fieldName), direction, nullsLast)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(
            SObjectField field,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(getFieldTokenPath(field), direction, nullsLast)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(getFieldPath(fieldName), direction)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        orderingList.add(
                new XAP_DAO_SOQL_QuerySortOrdering(getFieldTokenPath(field), direction)
        );
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        XAP_DAO_SOQL_QuerySortOrdering ordr
                = new XAP_DAO_SOQL_QuerySortOrdering(getFieldPath(fieldName), direction, nullsLast);
        return setOrdering(ordr);
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(
            SObjectField field,
            XAP_DAO_SOQL_QuerySortOrderEnum direction,
            Boolean nullsLast
    ) {
        XAP_DAO_SOQL_QuerySortOrdering ordr
                = new XAP_DAO_SOQL_QuerySortOrdering(getFieldTokenPath(field), direction, nullsLast);
        return setOrdering(ordr);
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        XAP_DAO_SOQL_QuerySortOrdering ordr = new XAP_DAO_SOQL_QuerySortOrdering(getFieldPath(fieldName), direction);
        return setOrdering(ordr);
    }

    public XAP_DAO_SOQL_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        XAP_DAO_SOQL_QuerySortOrdering ordr = new XAP_DAO_SOQL_QuerySortOrdering(getFieldTokenPath(field), direction);
        return setOrdering(ordr);
    }

    public String toSOQL() {
        return toQueryInterpolation().template;
    }

    public XAP_DAO_SOQL_QueryFactory deepClone() {

        XAP_DAO_SOQL_QueryFactory clone = new XAP_DAO_SOQL_QueryFactory(this.sObjectType)
                .setLimit(this.limitCount)
                .setOffset(this.offsetCount)
                .setCondition(this.conditionExpression)
                .setEnforceFLS(this.enforceFLS);

        Map<Schema.ChildRelationship, XAP_DAO_SOQL_QueryFactory> subqueries = this.factoryByChildRelationshipMap;
        if (subqueries != null) {
            Map<Schema.ChildRelationship, XAP_DAO_SOQL_QueryFactory> clonedSubqueries
                    = new Map<Schema.ChildRelationship, XAP_DAO_SOQL_QueryFactory>();
            for (Schema.ChildRelationship key : subqueries.keySet()) {
                clonedSubqueries.put(key, subqueries.get(key).deepClone());
            }
            clone.factoryByChildRelationshipMap = clonedSubqueries;
        }

        clone.childRelationship = this.childRelationship;
        clone.orderingList = this.orderingList.clone();
        clone.fieldSet = this.fieldSet.clone();

        return clone;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        XAP_DAO_SOQL_QueryInterpolation whereInterpolation = (this.conditionExpression != null)
                ? this.conditionExpression.toQueryInterpolation()
                : null;
        String soqlTemplate = this.toSoqlSelect()
                + this.toSoqlFrom()
                + (
                (whereInterpolation != null)
                        ? this.toSOQL('WHERE', whereInterpolation.template)
                        : ''
        )
                + this.toSoqlOrderBy()
                + this.toSOQL('LIMIT', this.limitCount)
                + this.toSOQL('OFFSET', this.offsetCount);

        return new XAP_DAO_SOQL_QueryInterpolation(
                soqlTemplate,
                (whereInterpolation != null)
                        ? whereInterpolation.objectsByKeyMap
                        : null
        );
    }

    private String toSoqlSelect() {
        String result = 'SELECT ';

        if (this.fieldSet.size() == 0) {
            if (this.enforceFLS) {
                this.securityUtils.checkFieldIsReadable(this.sObjectType, 'Id');
            }
            result += 'Id';
        }
        else {
            List<String> fieldSetToQuery = new List<String>(this.fieldSet);
            if (this.sortSelectFields) {
                fieldSetToQuery.sort();
            }

            result += String.join(fieldSetToQuery, ', ');
        }

        if (this.factoryByChildRelationshipMap != null && !this.factoryByChildRelationshipMap.isEmpty()) {
            for (XAP_DAO_SOQL_QueryFactory childRow : this.factoryByChildRelationshipMap.values()) {
                result += ', (' + childRow.toQueryInterpolation().template + ') ';
            }
        }
        return result;
    }

    private String toSoqlFrom() {


        return ' FROM ' + (
                this.childRelationship != null
                        ? this.childRelationship.getRelationshipName()
                        : this.sObjectType.getDescribe().getName()
        );
    }

    private String toSoqlOrderBy() {
        String result = '';
        if (this.orderingList.size() > 0) {
            result += ' ORDER BY ';
            for (XAP_DAO_SOQL_QuerySortOrdering ordering : this.orderingList) {
                result += ordering.toSOQL() + ', ';
            }

            result = result.substring(0, result.length() - 2);
        }
        return result;
    }

    private String toSOQL(String keyword, Object value) {
        return (value != null)
                ? ' ' + keyword + ' ' + value
                : '';
    }

    public List<SObject> query() {
        return this.querier.selectFor(this.toQueryInterpolation());
    }

    public Database.QueryLocator getQueryLocator() {
        return this.querier.getQueryLocatorFor(this.toQueryInterpolation());
    }
}