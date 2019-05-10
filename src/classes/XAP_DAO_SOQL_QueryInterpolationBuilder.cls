public class XAP_DAO_SOQL_QueryInterpolationBuilder {
    SObjectType sObjectType;
    Set<String> fieldSet;
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    private XAP_DAO_SOQL_QueryInterpolationBuilder(
            SObjectType sObjectType,
            Set<String> fieldSet,
            XAP_DAO_SOQL_SecurityUtils securityUtils
    ) {
        this.sObjectType = sObjectType;
        this.fieldSet = fieldSet;
        this.securityUtils = securityUtils;
    }

    public XAP_DAO_SOQL_QueryInterpolationBuilder(SObjectType sObjectType, Set<String> fieldSet) {
        this(sObjectType, fieldSet, XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    public static final Boolean INCLUDING_FIELD_LEVEL_SECURITY = true;
    public static final Boolean EXCLUDING_FIELD_LEVEL_SECURITY = false;

    public static final Boolean INCLUDING_SORTED_SELECT_FIELDS = true;
    public static final Boolean EXCLUDING_SORTED_SELECT_FIELDS = false;

    private XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setConditionExpression(
            XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression
    ) {
        this.conditionExpression = conditionExpression;
        return this;
    }

    private Integer limitCount;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setLimitCount(
            Integer limitCount
    ) {
        this.limitCount = limitCount;
        return this;
    }


    private Integer offsetCount;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setOffsetCount(
            Integer offsetCount
    ) {
        this.offsetCount = offsetCount;
        return this;
    }


    private List<XAP_DAO_SOQL_QuerySortOrdering> orderingList;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setOrderingList(
            List<XAP_DAO_SOQL_QuerySortOrdering> orderingList
    ) {
        this.orderingList = orderingList;
        return this;
    }


    private Boolean enforceFLS = EXCLUDING_FIELD_LEVEL_SECURITY;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setEnforceFieldLevelSecurity(
            Boolean enforceFLS
    ) {
        this.enforceFLS = enforceFLS;
        return this;
    }

    private Boolean sortSelectFields = INCLUDING_SORTED_SELECT_FIELDS;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setSortSelectFields(
            Boolean sortSelectFields
    ) {
        this.sortSelectFields = sortSelectFields;
        return this;
    }

    private ChildRelationship childRelationship;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setChildRelationship(
            ChildRelationship childRelationship
    ) {
        this.childRelationship = childRelationship;
        return this;
    }

    private Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> factoryByChildRelationshipMap;
    public XAP_DAO_SOQL_QueryInterpolationBuilder setFactoryByChildRelationshipMap(
            Map<ChildRelationship, XAP_DAO_SOQL_QueryFactory> factoryByChildRelationshipMap
    ) {
        this.factoryByChildRelationshipMap = factoryByChildRelationshipMap;
        return this;
    }


    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        XAP_DAO_SOQL_QueryInterpolation whereInterpolation = (this.conditionExpression != null)
                ? this.conditionExpression.toQueryInterpolation()
                : null;

        String soqlTemplate = this.toSoqlSelect()
                + this.toSoqlFrom()
                + (
                whereInterpolation != null
                        ? this.toSOQL('WHERE', whereInterpolation.template)
                        : ''
        )
                + (
                this.orderingList != null && !this.orderingList.isEmpty()
                        ? this.toSoqlOrderBy()
                        : ''
        )
                + (
                this.limitCount != null
                        ? this.toSOQL('LIMIT', this.limitCount)
                        : ''
        )
                + (
                this.offsetCount != null
                        ? this.toSOQL('OFFSET', this.offsetCount)
                        : ''
        );

        return new XAP_DAO_SOQL_QueryInterpolation(
                soqlTemplate,
                (whereInterpolation != null)
                        ? whereInterpolation.objectsByKeyMap
                        : null
        );
    }

    private String toSoqlSelect() {
        String result = 'SELECT ';

        if (this.fieldSet.isEmpty()) {
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
        String result = ' ORDER BY ';
        for (XAP_DAO_SOQL_QuerySortOrdering ordering : this.orderingList) {
            result += ordering.toSOQL() + ', ';
        }

        return result.substring(0, result.length() - 2);
    }

    private String toSOQL(String keyword, Object value) {
        return (value != null)
                ? ' ' + keyword + ' ' + value
                : '';
    }
}