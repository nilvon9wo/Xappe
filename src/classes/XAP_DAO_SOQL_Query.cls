public class XAP_DAO_SOQL_Query {
    private static transient final Boolean DEFAULT_ENFORCE_FLS = false;
    private static transient final Boolean DEFAULT_SORT_SELECT_FIELDS = true;

    private XAP_DAO_SOQL_SecurityUtils securityUtils;
    public Schema.SObjectType sObjectType { get; private set; }

    public XAP_DAO_SOQL_Query(Schema.SObjectType sObjectType, XAP_DAO_SOQL_SecurityUtils securityUtils) {
        this.securityUtils = securityUtils;
        this.sObjectType = sObjectType;
        this.enforceFLS = DEFAULT_ENFORCE_FLS;
        this.fieldSet = new Set<String>();
        this.orderingList = new List<XAP_DAO_SOQL_QuerySortOrdering>();
        this.sortSelectFields = DEFAULT_SORT_SELECT_FIELDS;
    }

    public XAP_DAO_SOQL_Query(Schema.SObjectType sObjectType) {
        this(sObjectType, XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    public Set<String> fieldSet;
    public List<XAP_DAO_SOQL_QuerySortOrdering> orderingList;
    public Map<Schema.ChildRelationship, XAP_DAO_SOQL_QueryFactory> queryFactoryByRelationshipMap;

    public XAP_DAO_SOQL_WHERE_ClauseIntf conditionExpression;
    public Integer limitCount;
    public Integer offsetCount;
    public Boolean enforceFLS;
    public Boolean sortSelectFields;
    public Schema.ChildRelationship relationship;

    public List<XAP_DAO_SOQL_QuerySortOrdering> setOrdering(List<XAP_DAO_SOQL_QuerySortOrdering> orderingList) {
        this.orderingList = orderingList;
        return this.orderingList;
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> setOrdering(XAP_DAO_SOQL_QuerySortOrdering ordering) {
        return this.setOrdering(new List<XAP_DAO_SOQL_QuerySortOrdering>{
                ordering
        });
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        return this.setOrdering(new XAP_DAO_SOQL_QuerySortOrdering(field, direction, nullsLast));
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> setOrdering(String field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        return this.setOrdering(new XAP_DAO_SOQL_QuerySortOrdering(field, direction, nullsLast));
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> addOrdering(XAP_DAO_SOQL_QuerySortOrdering ordering) {
        this.orderingList.add(ordering);
        return this.orderingList;
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        return this.addOrdering(new XAP_DAO_SOQL_QuerySortOrdering(field, direction, nullsLast));
    }

    public List<XAP_DAO_SOQL_QuerySortOrdering> addOrdering(String field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        return this.addOrdering(new XAP_DAO_SOQL_QuerySortOrdering(field, direction, nullsLast));
    }

    public Boolean equals(Object obj) {
        if (!(obj instanceof XAP_DAO_SOQL_Query)
                || ((XAP_DAO_SOQL_Query) obj).SObjectType != this.sObjectType
                || ((XAP_DAO_SOQL_Query) obj).fieldSet.size() != this.fieldSet.size()
                ) {
            return false;
        }

        return ((XAP_DAO_SOQL_Query) obj).toQueryInterpolation() == this.toQueryInterpolation();
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        XAP_DAO_SOQL_QueryInterpolation whereInterpolation = this.conditionExpression.toQueryInterpolation();
        String soqlTemplate = this.toSoqlSelect()
                + this.toSoqlFrom()
                + this.toSOQL('WHERE', whereInterpolation.template)
                + this.toSoqlOrderBy()
                + this.toSOQL('LIMIT', this.limitCount)
                + this.toSOQL('OFFSET', this.offsetCount);
        return new XAP_DAO_SOQL_QueryInterpolation(soqlTemplate, whereInterpolation.objectsByKeyMap);
    }

    private String toSoqlSelect() {
        String result = 'SELECT ';

        if (this.fieldSet.size() == 0) {
            if (this.enforceFLS) {
                this.securityUtils.checkFieldIsReadable(this.sObjectType, 'Id');
            }
            result += 'Id';
        } else {
            List<String> fieldSetToQuery = new List<String>(this.fieldSet);
            if (this.sortSelectFields) {
                fieldSetToQuery.sort();
            }

            result += String.join(fieldSetToQuery, ', ');
        }

        if (this.queryFactoryByRelationshipMap != null && !this.queryFactoryByRelationshipMap.isEmpty()) {
            for (XAP_DAO_SOQL_QueryFactory childRow : this.queryFactoryByRelationshipMap.values()) {
                result += ', (' + childRow.toQueryInterpolation() + ') ';
            }
        }
        return result;
    }

    private String toSoqlFrom() {
        return ' FROM ' + (
                this.relationship != null
                        ? this.relationship.getRelationshipName()
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
}
