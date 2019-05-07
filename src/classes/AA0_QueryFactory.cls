public class AA0_QueryFactory {
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    public AA0_QueryFactory(Schema.SObjectType sObjectType, XAP_DAO_SOQL_SecurityUtils securityUtils) {
        this.sObjectType = sObjectType;
        this.securityUtils = securityUtils;

        this.fields = new Set<String>();
        this.order = new List<Ordering>();
        this.enforceFLS = false;
    }

    public AA0_QueryFactory(Schema.SObjectType sObjectType) {
        this(sObjectType, XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    public Schema.SObjectType sObjectType { get; private set; }

    @TestVisible
    private Set<String> fields;
    private String conditionExpression;
    private Integer limitCount;
    private Integer offsetCount;
    private List<Ordering> order;

    private Boolean enforceFLS;

    private Boolean sortSelectFields = true;

    private Schema.ChildRelationship relationship;
    private Map<Schema.ChildRelationship, AA0_QueryFactory> subselectQueryMap;

    private String getFieldPath(String fieldName) {
        if (!fieldName.contains('.')) { //single field
            Schema.SObjectField token = A00_SObjectDescribe.getDescribe(sObjectType).getField(fieldName.toLowerCase());
            if (token == null)
                throw new InvalidFieldException(fieldName, this.sObjectType);
            if (enforceFLS)
                this.securityUtils.checkFieldIsReadable(this.sObjectType, token);
            return token.getDescribe().getName();
        }

        //traversing FK relationship(s)
        List<String> fieldPath = new List<String>();
        Schema.sObjectType lastSObjectType = sObjectType;
        Iterator<String> i = fieldName.split('\\.').iterator();
        while (i.hasNext()) {
            String field = i.next();
            Schema.SObjectField token = A00_SObjectDescribe.getDescribe(lastSObjectType).getField(field.toLowerCase());
            DescribeFieldResult tokenDescribe = token != null ? token.getDescribe() : null;

            if (token != null && enforceFLS) {
                this.securityUtils.checkFieldIsReadable(lastSObjectType, token);
            }

            if (token != null && i.hasNext() && tokenDescribe.getSOAPType() == Schema.SOAPType.ID) {
                lastSObjectType = tokenDescribe.getReferenceTo()[0]; //if it's polymorphic doesn't matter which one we get
                fieldPath.add(tokenDescribe.getRelationshipName());
            } else if (token != null && !i.hasNext()) {
                fieldPath.add(tokenDescribe.getName());
            } else {
                if (token == null)
                    throw new InvalidFieldException(field, lastSObjectType); else
                        throw new NonReferenceFieldException(lastSObjectType + '.' + field + ' is not a lookup or master-detail field but is used in a cross-object query field.');
            }
        }

        return String.join(fieldPath, '.');
    }

    @TestVisible
    private static String getFieldTokenPath(Schema.SObjectField field) {
        if (field == null) {
            throw new InvalidFieldException('Invalid field: null');
        }
        return field.getDescribe().getName();
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof AA0_QueryFactory) || ((AA0_QueryFactory) obj).sObjectType != this.sObjectType || ((AA0_QueryFactory) obj).fields.size() != this.fields.size())
            return false;
        return ((AA0_QueryFactory) obj).toSOQL() == this.toSOQL();
    }

    private AA0_QueryFactory(Schema.ChildRelationship relationship) {
        this(relationship.getChildSObject());
        this.relationship = relationship;
    }

    public AA0_QueryFactory assertIsAccessible() {
        this.securityUtils.checkObjectIsReadable(this.sObjectType);
        return this;
    }

    public AA0_QueryFactory setEnforceFLS(Boolean enforce) {
        this.enforceFLS = enforce;
        return this;
    }

    public AA0_QueryFactory setSortSelectFields(Boolean doSort) {
        this.sortSelectFields = doSort;
        return this;
    }

    public AA0_QueryFactory addField(String fieldName) {
        fields.add(getFieldPath(fieldName));
        return this;
    }

    public AA0_QueryFactory addField(Schema.SObjectField field) {
        if (field == null)
            throw new InvalidFieldException(null, this.sObjectType);
        if (enforceFLS)
            this.securityUtils.checkFieldIsReadable(sObjectType, field);
        fields.add(getFieldTokenPath(field));
        return this;
    }

    public AA0_QueryFactory addFields(Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            fields.add(getFieldPath(fieldName));
        }
        return this;
    }

    public AA0_QueryFactory addFields(List<String> fieldNames) {
        for (String fieldName : fieldNames)
            fields.add(getFieldPath(fieldName));
        return this;
    }

    public AA0_QueryFactory addFields(Set<Schema.SObjectField> fields) {
        for (Schema.SObjectField token : fields) {
            if (token == null)
                throw new InvalidFieldException();
            if (enforceFLS)
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            this.fields.add(getFieldTokenPath(token));
        }
        return this;
    }

    public AA0_QueryFactory addFields(List<Schema.SObjectField> fields) {
        for (Schema.SObjectField token : fields) {
            if (token == null)
                throw new InvalidFieldException();
            if (enforceFLS)
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            this.fields.add(getFieldTokenPath(token));
        }
        return this;
    }

    public AA0_QueryFactory addFields(Schema.FieldSet fieldSet) {
        return selectFieldSet(fieldSet, true);
    }

    public AA0_QueryFactory selectFieldSet(Schema.FieldSet fieldSet, Boolean allowCrossObject) {
        if (fieldSet.getSObjectType() != sObjectType)
            throw new InvalidFieldSetException('Field set "' + fieldSet.getName() + '" is not for SObject type "' + sObjectType + '"');
        for (Schema.FieldSetMember field : fieldSet.getFields()) {
            if (!allowCrossObject && field.getFieldPath().contains('.'))
                throw new InvalidFieldSetException('Cross-object fields not allowed and field "' + field.getFieldPath() + '"" is a cross-object field.');
            fields.add(getFieldPath(field.getFieldPath()));
        }
        return this;
    }

    public AA0_QueryFactory setCondition(String conditionExpression) {
        this.conditionExpression = conditionExpression;
        return this;
    }

    public String getCondition() {
        return this.conditionExpression;
    }

    public AA0_QueryFactory setLimit(Integer limitCount) {
        this.limitCount = limitCount;
        return this;
    }

    public Integer getLimit() {
        return this.limitCount;
    }

    public AA0_QueryFactory setOffset(Integer offsetCount) {
        this.offsetCount = offsetCount;
        return this;
    }

    public Integer getOffset() {
        return this.offsetCount;
    }

    public AA0_QueryFactory addOrdering(Ordering o) {
        this.order.add(o);
        return this;
    }


    public AA0_QueryFactory setOrdering(Ordering o) {
        this.order = new List<Ordering>{
                o
        };
        return this;
    }

    public List<Ordering> getOrderings() {
        return this.order;
    }


    public Set<String> getSelectedFields() {
        return this.fields;
    }


    public AA0_QueryFactory subselectQuery(SObjectType related) {
        System.debug(LoggingLevel.WARN, 'fflib_QueryFactory.subselectQuery(Schema.SObjectType) is deprecated and will be removed in a future release. Use fflib_QueryFactory.subselectQuery(String) or fflib_QueryFactory.subselectQuery(ChildRelationship) instead.');
        return setSubselectQuery(getChildRelationship(related), false);
    }


    public AA0_QueryFactory subselectQuery(SObjectType related, Boolean assertIsAccessible) {
        System.debug(LoggingLevel.WARN, 'fflib_QueryFactory.subselectQuery(Schema.SObjectType, Boolean) is deprecated and will be removed in a future release. Use fflib_QueryFactory.subselectQuery(String, Boolean) or fflib_QueryFactory.subselectQuery(ChildRelationship, Boolean) instead.');
        return setSubselectQuery(getChildRelationship(related), assertIsAccessible);
    }


    public AA0_QueryFactory subselectQuery(String relationshipName) {
        return subselectQuery(relationshipName, false);
    }


    public AA0_QueryFactory subselectQuery(String relationshipName, Boolean assertIsAccessible) {
        ChildRelationship relationship = getChildRelationship(relationshipName);
        if (relationship != null) {
            return setSubselectQuery(relationship, assertIsAccessible);
        }
        throw new InvalidSubqueryRelationshipException('Invalid call to subselectQuery with relationshipName = ' + relationshipName + '.  Relationship does not exist for ' + sObjectType.getDescribe().getName());
    }


    public AA0_QueryFactory subselectQuery(ChildRelationship relationship) {
        return subselectQuery(relationship, false);
    }


    public AA0_QueryFactory subselectQuery(ChildRelationship relationship, Boolean assertIsAccessible) {
        return setSubselectQuery(relationship, assertIsAccessible);
    }


    private AA0_QueryFactory setSubselectQuery(ChildRelationship relationship, Boolean assertIsAccessible) {
        if (this.relationship != null) {
            throw new InvalidSubqueryRelationshipException('Invalid call to subselectQuery.  You may not add a subselect query to a subselect query.');
        }
        if (this.subselectQueryMap == null) {
            this.subselectQueryMap = new Map<ChildRelationship, AA0_QueryFactory>();
        }
        if (this.subselectQueryMap.containsKey(relationship)) {
            return subselectQueryMap.get(relationship);
        }

        AA0_QueryFactory subselectQuery = new AA0_QueryFactory(relationship);

        //The child queryFactory should be configured in the same way as the parent by default - can override after if required
        subSelectQuery.setSortSelectFields(sortSelectFields);

        if (assertIsAccessible) {
            subSelectQuery.assertIsAccessible();
        }
        subselectQueryMap.put(relationship, subSelectQuery);
        return subSelectQuery;
    }

    public List<AA0_QueryFactory> getSubselectQueries() {
        if (subselectQueryMap != null) {
            return subselectQueryMap.values();
        }
        return null;
    }

    private Schema.ChildRelationship getChildRelationship(sObjectType objType) {
        for (Schema.ChildRelationship childRow : sObjectType.getDescribe().getChildRelationships()) {
            //occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
            //if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getChildSObject() == objType && childRow.getRelationshipName() != null) {
                return childRow;
            }
        }
        throw new InvalidSubqueryRelationshipException('Invalid call to subselectQuery.  Invalid relationship for table ' + sObjectType + ' and objtype=' + objType);
    }

    private Schema.ChildRelationship getChildRelationship(String relationshipName) {
        for (Schema.ChildRelationship childRow : sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getRelationshipName() == relationshipName) {
                return childRow;
            }
        }
        return null;
    }

    public AA0_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        order.add(
                new Ordering(getFieldPath(fieldName), direction, nullsLast)
        );
        return this;
    }

    public AA0_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        order.add(
                new Ordering(getFieldTokenPath(field), direction, nullsLast)
        );
        return this;
    }

    public AA0_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        order.add(
                new Ordering(getFieldPath(fieldName), direction)
        );
        return this;
    }

    public AA0_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        order.add(
                new Ordering(getFieldTokenPath(field), direction)
        );
        return this;
    }

    public AA0_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        Ordering ordr = new Ordering(getFieldPath(fieldName), direction, nullsLast);
        return setOrdering(ordr);
    }

    public AA0_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        Ordering ordr = new Ordering(getFieldTokenPath(field), direction, nullsLast);
        return setOrdering(ordr);
    }

    public AA0_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        Ordering ordr = new Ordering(getFieldPath(fieldName), direction);
        return setOrdering(ordr);
    }

    public AA0_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        Ordering ordr = new Ordering(getFieldTokenPath(field), direction);
        return setOrdering(ordr);
    }

    public String toSOQL() {
        String result = 'SELECT ';
        //if no fields have been added, just add the Id field so that the query or subquery will not just fail
        if (fields.size() == 0) {
            if (enforceFLS) this.securityUtils.checkFieldIsReadable(sObjectType, 'Id');
            result += 'Id';
        } else {
            List<String> fieldsToQuery = new List<String>(fields);

            if (sortSelectFields) {
                fieldsToQuery.sort();
            }

            result += String.join(fieldsToQuery, ', ');
        }

        if (subselectQueryMap != null && !subselectQueryMap.isEmpty()) {
            for (AA0_QueryFactory childRow : subselectQueryMap.values()) {
                result += ', (' + childRow.toSOQL() + ') ';
            }
        }
        result += ' FROM ' + (relationship != null ? relationship.getRelationshipName() : sObjectType.getDescribe().getName());
        if (conditionExpression != null)
            result += ' WHERE ' + conditionExpression;

        if (order.size() > 0) {
            result += ' ORDER BY ';
            for (Ordering o : order)
                result += o.toSOQL() + ', ';
            result = result.substring(0, result.length() - 2);
        }

        if (limitCount != null)
            result += ' LIMIT ' + limitCount;

        if (offsetCount != null)
            result += ' OFFSET ' + offsetCount;

        return result;
    }

    public AA0_QueryFactory deepClone() {

        AA0_QueryFactory clone = new AA0_QueryFactory(this.sObjectType)
                .setLimit(this.limitCount)
                .setOffset(this.offsetCount)
                .setCondition(this.conditionExpression)
                .setEnforceFLS(this.enforceFLS);

        Map<Schema.ChildRelationship, AA0_QueryFactory> subqueries = this.subselectQueryMap;
        if (subqueries != null) {
            Map<Schema.ChildRelationship, AA0_QueryFactory> clonedSubqueries = new Map<Schema.ChildRelationship, AA0_QueryFactory>();
            for (Schema.ChildRelationship key : subqueries.keySet()) {
                clonedSubqueries.put(key, subqueries.get(key).deepClone());
            }
            clone.subselectQueryMap = clonedSubqueries;
        }

        clone.relationship = this.relationship;
        clone.order = this.order.clone();
        clone.fields = this.fields.clone();

        return clone;
    }

    public class Ordering {
        private XAP_DAO_SOQL_QuerySortOrderEnum direction;
        private boolean nullsLast;
        private String field;

        public Ordering(String sobjType, String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
            this(
                    A00_SObjectDescribe.getDescribe(sobjType).getField(fieldName),
                    direction
            );
        }

        public Ordering(Schema.SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
            this(AA0_QueryFactory.getFieldTokenPath(field), direction, false); //SOQL docs state NULLS FIRST is default behavior
        }
        public Ordering(Schema.SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
            this(AA0_QueryFactory.getFieldTokenPath(field), direction, nullsLast);
        }
        @TestVisible
        private Ordering(String field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
            this(field, direction, false);
        }
        @TestVisible
        private Ordering(String field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
            this.direction = direction;
            this.field = field;
            this.nullsLast = nullsLast;
        }
        public String getField() {
            return this.field;
        }
        public XAP_DAO_SOQL_QuerySortOrderEnum getDirection() {
            return direction;
        }
        public String toSOQL() {
            return field + ' ' + (direction == XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING ? 'ASC' : 'DESC') + (nullsLast ? ' NULLS LAST ' : ' NULLS FIRST ');
        }
    }


    public class InvalidFieldException extends Exception {
        private String fieldName;
        private Schema.SObjectType objectType;
        public InvalidFieldException(String fieldname, Schema.SObjectType objectType) {
            this.objectType = objectType;
            this.fieldName = fieldName;
            this.setMessage('Invalid field \'' + fieldName + '\' for object \'' + objectType + '\'');
        }
    }
    public class InvalidFieldSetException extends Exception {
    }
    public class NonReferenceFieldException extends Exception {
    }
    public class InvalidSubqueryRelationshipException extends Exception {
    }
}