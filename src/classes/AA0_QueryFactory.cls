public class AA0_QueryFactory {
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    public AA0_QueryFactory(Schema.SObjectType sObjectType, XAP_DAO_SOQL_SecurityUtils securityUtils) {
        this.sObjectType = sObjectType;
        this.securityUtils = securityUtils;

        this.fields = new Set<String>();
        this.order = new List<Ordering>();
        this.enforceFLS = false;
        System.debug('#######AA0_QueryFactory  securityUtils: ' + securityUtils);
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
    /**
     * Integrate checking for READ Field Level Security within the selectField(s) methods
     * This can optionally be enforced (or not) by calling the setEnforceFLS method prior to calling
     * one of the selectField or addFieldset methods.
    **/
    private Boolean enforceFLS;

    private Boolean sortSelectFields = true;

    /**
     * The relationship and  subselectQueryMap variables are used to support subselect queries.  Subselects can be added to
     * a query, as long as it isn't a subselect query itself.  You may have many subselects inside
     * a query, but they may only be 1 level deep (no subselect inside a subselect)
     * to add a subselect, call the subselectQuery method, passing in the ChildRelationship.
    **/
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

    /**
     * fflib_QueryFactory instances will be considered equal if they produce the same SOQL query.
     * A faster comparison will first be attempted to check if they apply to the same table, and contain the same number of fields selected.
     * This method will never return true if the provided object is not an instance of fflib_QueryFactory.
     * @param obj the object to check equality of.
    **/
    public boolean equals(Object obj) {
        if (!(obj instanceof AA0_QueryFactory) || ((AA0_QueryFactory) obj).sObjectType != this.sObjectType || ((AA0_QueryFactory) obj).fields.size() != this.fields.size())
            return false;
        return ((AA0_QueryFactory) obj).toSOQL() == this.toSOQL();
    }

    /**
     * Construct a new fflib_QueryFactory instance with no options other than the FROM clause and the relationship.
     * This should be used when constructing a subquery query for addition to a parent query.
     * Objects created with this constructor cannot be added to another object using the subselectQuery method.
     * You *must* call selectField(s) before {@link #toSOQL} will return a valid, runnable query.
     * @param relationship the ChildRelationship to be used in the FROM Clause of the resultant Query (when set overrides value of table). This sets the value of {@link #relationship} and {@link #table}.
    **/
    private AA0_QueryFactory(Schema.ChildRelationship relationship) {
        this(relationship.getChildSObject());
        this.relationship = relationship;
    }

    public AA0_QueryFactory assertIsAccessible() {
        System.debug('####### this.securityUtils: ' + this.securityUtils);
        System.debug('####### table: ' + this.sObjectType);
        this.securityUtils.checkObjectIsReadable(this.sObjectType);
        return this;
    }

    public AA0_QueryFactory setEnforceFLS(Boolean enforce) {
        this.enforceFLS = enforce;
        return this;
    }

    /**
     * Sets a flag to indicate that this query should have ordered
     * query fields in the select statement (this at a small cost to performance).
     * If you are processing large query sets, you should switch this off.
     * @param whether or not select fields should be sorted in the soql statement.
     **/
    public AA0_QueryFactory setSortSelectFields(Boolean doSort) {
        this.sortSelectFields = doSort;
        return this;
    }

    /**
     * Selects a single field from the SObject specified in {@link #table}.
     * Selecting fields is idempotent, if this field is already selected calling this method will have no additional impact.
     * @param fieldName the API name of the field to add to the query's SELECT clause.
     **/
    public AA0_QueryFactory addField(String fieldName) {
        fields.add(getFieldPath(fieldName));
        return this;
    }
    /**
     * Selects a field, avoiding the possible ambiguitiy of String API names.
     * @see #selectField(String)
     * @param field the {@link Schema.SObjectField} to select with this query.
     * @exception InvalidFieldException If the field is null {@code field}.
    **/
    public AA0_QueryFactory addField(Schema.SObjectField field) {
        if (field == null)
            throw new InvalidFieldException(null, this.sObjectType);
        if (enforceFLS)
            this.securityUtils.checkFieldIsReadable(sObjectType, field);
        fields.add(getFieldTokenPath(field));
        return this;
    }
    /**
     * Selects multiple fields. This acts the same as calling {@link #selectField(String)} multiple times.
     * @param fieldNames the Set of field API names to select.
    **/
    public AA0_QueryFactory addFields(Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            fields.add(getFieldPath(fieldName));
        }
        return this;
    }
    /**
     * Selects multiple fields. This acts the same as calling {@link #selectField(String)} multiple times.
     * @param fieldNames the List of field API names to select.
    **/
    public AA0_QueryFactory addFields(List<String> fieldNames) {
        for (String fieldName : fieldNames)
            fields.add(getFieldPath(fieldName));
        return this;
    }
    /**
     * Selects multiple fields. This acts the same as calling {@link #selectField(Schema.SObjectField)} multiple times.
     * @param fieldNames the set of {@link Schema.SObjectField}s to select.
     * @exception InvalidFieldException if the fields are null {@code fields}.
    **/
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
    /**
     * Selects multiple fields. This acts the same as calling {@link #selectField(Schema.SObjectField)} multiple times.
     * @param fieldNames the set of {@link Schema.SObjectField}s to select.
     * @exception InvalidFieldException if the fields are null {@code fields}.
    **/
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
    /**
     * @see #selectFieldSet(Schema.FieldSet,Boolean)
    **/
    public AA0_QueryFactory addFields(Schema.FieldSet fieldSet) {
        return selectFieldSet(fieldSet, true);
    }
    /**
     * This is equivielent to iterating the fields in the field set and calling {@link #selectField(String)} on each.
     * @param fieldSet Select all fields included in the field set.
     * @param allowCrossObject if false this method will throw an exception if any fields in the field set reference fields on a related record.
     * @exception InvalidFieldSetException if the fieldset is invalid for table {@code fields}.
    **/
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
    /**
     * @param conditionExpression Sets the WHERE clause to the string provided. Do not include the "WHERE".
    **/
    public AA0_QueryFactory setCondition(String conditionExpression) {
        this.conditionExpression = conditionExpression;
        return this;
    }
    /**
     * @returns the current value of the WHERE clause, if any, as set by {@link #setCondition}
    **/
    public String getCondition() {
        return this.conditionExpression;
    }
    /**
     * @param limitCount if not null causes a LIMIT caluse to be added to the resulting query.
    **/
    public AA0_QueryFactory setLimit(Integer limitCount) {
        this.limitCount = limitCount;
        return this;
    }
    /**
     * @returns the current value of the LIMIT clause, if any.
    **/
    public Integer getLimit() {
        return this.limitCount;
    }
    /**
     * @param offsetCount if not null causes a OFFSET caluse to be added to the resulting query.
    **/
    public AA0_QueryFactory setOffset(Integer offsetCount) {
        this.offsetCount = offsetCount;
        return this;
    }
    /**
     * @returns the current value of the OFFSET clause, if any.
    **/
    public Integer getOffset() {
        return this.offsetCount;
    }
    /**
     * @param o an instance of {@link fflib_QueryFactory.Ordering} to be added to the query's ORDER BY clause.
    **/
    public AA0_QueryFactory addOrdering(Ordering o) {
        this.order.add(o);
        return this;
    }

    /**
     * @param o an instance of {@link fflib_QueryFactory.Ordering} to remove all existing (for instance defaults) and be added to the query's ORDER BY clause.
     **/
    public AA0_QueryFactory setOrdering(Ordering o) {
        this.order = new List<Ordering>{
                o
        };
        return this;
    }
    /**
     * @returns the list of orderings that will be used as the query's ORDER BY clause. You may remove elements from the returned list, or otherwise mutate it, to remove previously added orderings.
    **/
    public List<Ordering> getOrderings() {
        return this.order;
    }

    /**
     * @returns the selected fields
     **/
    public Set<String> getSelectedFields() {
        return this.fields;
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationship already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @deprecated  Replaced by {@link #subselectQuery(String relationshipName)} and {@link #subselectQuery(ChildRelationship relationship)}
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param related The related object type
    **/
    public AA0_QueryFactory subselectQuery(SObjectType related) {
        System.debug(LoggingLevel.WARN, 'fflib_QueryFactory.subselectQuery(Schema.SObjectType) is deprecated and will be removed in a future release. Use fflib_QueryFactory.subselectQuery(String) or fflib_QueryFactory.subselectQuery(ChildRelationship) instead.');
        return setSubselectQuery(getChildRelationship(related), false);
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationship already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @deprecated  Replaced by {@link #subselectQuery(String relationshipName, Boolean assertIsAccessible)} and {@link #subselectQuery(ChildRelationship relationship, Boolean assertIsAccessible)}
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param related The related object type
     * @param assertIsAccessible indicates whether to check if the user has access to the subquery object
    **/
    public AA0_QueryFactory subselectQuery(SObjectType related, Boolean assertIsAccessible) {
        System.debug(LoggingLevel.WARN, 'fflib_QueryFactory.subselectQuery(Schema.SObjectType, Boolean) is deprecated and will be removed in a future release. Use fflib_QueryFactory.subselectQuery(String, Boolean) or fflib_QueryFactory.subselectQuery(ChildRelationship, Boolean) instead.');
        return setSubselectQuery(getChildRelationship(related), assertIsAccessible);
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationshipName already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param relationshipName The relationshipName to be added as a subquery
    **/
    public AA0_QueryFactory subselectQuery(String relationshipName) {
        return subselectQuery(relationshipName, false);
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationship already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param relationshipName The relationshipName to be added as a subquery
     * @param assertIsAccessible indicates whether to check if the user has access to the subquery object
    **/
    public AA0_QueryFactory subselectQuery(String relationshipName, Boolean assertIsAccessible) {
        ChildRelationship relationship = getChildRelationship(relationshipName);
        if (relationship != null) {
            return setSubselectQuery(relationship, assertIsAccessible);
        }
        throw new InvalidSubqueryRelationshipException('Invalid call to subselectQuery with relationshipName = ' + relationshipName + '.  Relationship does not exist for ' + sObjectType.getDescribe().getName());
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationshipName already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param relationship The ChildRelationship to be added as a subquery
    **/
    public AA0_QueryFactory subselectQuery(ChildRelationship relationship) {
        return subselectQuery(relationship, false);
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationship already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param relationship The ChildRelationship to be added as a subquery
     * @param assertIsAccessible indicates whether to check if the user has access to the subquery object
    **/
    public AA0_QueryFactory subselectQuery(ChildRelationship relationship, Boolean assertIsAccessible) {
        return setSubselectQuery(relationship, assertIsAccessible);
    }

    /**
     * Add a subquery query to this query.  If a subquery for this relationship already exists, it will be returned.
     * If not, a new one will be created and returned.
     * @exception InvalidSubqueryRelationshipException If this method is called on a subselectQuery or with an invalid relationship
     * @param relationship The ChildRelationship to be added as a subquery
    **/
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

    /**
     * @returns the list of subquery instances of fflib_QueryFactory which will be added to the SOQL as relationship/child/sub-queries.
    **/
    public List<AA0_QueryFactory> getSubselectQueries() {
        if (subselectQueryMap != null) {
            return subselectQueryMap.values();
        }
        return null;
    }

    /**
     * Get the ChildRelationship from the Table for the object type passed in.
     * @param objType The object type of the child relationship to get
    **/
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

    /**
     * Get the ChildRelationship from the Table for the relationship name passed in.
     * @param relationshipName The name of the object's ChildRelationship on get
    **/
    private Schema.ChildRelationship getChildRelationship(String relationshipName) {
        for (Schema.ChildRelationship childRow : sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getRelationshipName() == relationshipName) {
                return childRow;
            }
        }
        return null;
    }

    /**
     * Add a field to be sorted on.  This may be a direct field or a field
     * related through an object lookup or master-detail relationship.
     * Use the set to store unique field names, since we only want to sort
     * by the same field one time.  The sort expressions are stored in a list
     * so that they are applied to the SOQL in the same order that they
     * were added in.
     * @param fieldName The string value of the field to be sorted on
     * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
     * @param nullsLast whether to sort null values last (NULLS LAST keyword included).
    **/
    public AA0_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        order.add(
                new Ordering(getFieldPath(fieldName), direction, nullsLast)
        );
        return this;
    }

    /**
    * Add a field to be sorted on.  This may be a direct field or a field
    * related through an object lookup or master-detail relationship.
    * Use the set to store unique field names, since we only want to sort
    * by the same field one time.  The sort expressions are stored in a list
    * so that they are applied to the SOQL in the same order that they
    * were added in.
    * @param field The SObjectfield to sort.  This can only be a direct reference.
    * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
    * @param nullsLast whether to sort null values last (NULLS LAST keyword included).
   **/
    public AA0_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        order.add(
                new Ordering(getFieldTokenPath(field), direction, nullsLast)
        );
        return this;
    }

    /**
	 * Add a field to be sorted on.  This may be a direct field or a field 
	 * related through an object lookup or master-detail relationship.
	 * Use the set to store unique field names, since we only want to sort
	 * by the same field one time.  The sort expressions are stored in a list
	 * so that they are applied to the SOQL in the same order that they
	 * were added in. 
	 * The "NULLS FIRST" keywords will be included by default.  If "NULLS LAST" 
	 * is required, use one of the overloaded addOrdering methods which include this parameter.
	 * @param fieldName The string value of the field to be sorted on
	 * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
	**/
    public AA0_QueryFactory addOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        order.add(
                new Ordering(getFieldPath(fieldName), direction)
        );
        return this;
    }

    /**
    * Add a field to be sorted on.  This may be a direct field or a field
    * related through an object lookup or master-detail relationship.
    * Use the set to store unique field names, since we only want to sort
    * by the same field one time.  The sort expressions are stored in a list
    * so that they are applied to the SOQL in the same order that they
    * were added in.
    * The "NULLS FIRST" keywords will be included by default.  If "NULLS LAST"
    * is required, use one of the overloaded addOrdering methods which include this parameter.
    * @param field The SObjectfield to sort.  This can only be a direct reference.
    * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
   **/
    public AA0_QueryFactory addOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        order.add(
                new Ordering(getFieldTokenPath(field), direction)
        );
        return this;
    }

    /**
     * Remove existing ordering and set a field to be sorted on.  This may be a direct field or a field
     * related through an object lookup or master-detail relationship.
     * Use the set to store unique field names, since we only want to sort
     * by the same field one time.  The sort expressions are stored in a list
     * so that they are applied to the SOQL in the same order that they
     * were added in.
     * @param fieldName The string value of the field to be sorted on
     * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
     * @param nullsLast whether to sort null values last (NULLS LAST keyword included).
    **/
    public AA0_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        Ordering ordr = new Ordering(getFieldPath(fieldName), direction, nullsLast);
        return setOrdering(ordr);
    }

    /**
     * Remove existing ordering and set a field to be sorted on.  This may be a direct field or a field
     * related through an object lookup or masterdetail relationship.
     * Use the set to store unique field names, since we only want to sort
     * by the same field one time.  The sort expressions are stored in a list
     * so that they are applied to the SOQL in the same order that they
     * were added in.
     * @param field The SObjectfield to sort.  This can only be a direct reference.
     * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
     * @param nullsLast whether to sort null values last (NULLS LAST keyword included).
    **/
    public AA0_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction, Boolean nullsLast) {
        Ordering ordr = new Ordering(getFieldTokenPath(field), direction, nullsLast);
        return setOrdering(ordr);
    }

    /**
     * Remove existing ordering and set a field to be sorted on.  This may be a direct field or a field
     * related through an object lookup or master-detail relationship.
     * Use the set to store unique field names, since we only want to sort
     * by the same field one time.  The sort expressions are stored in a list
     * so that they are applied to the SOQL in the same order that they
     * were added in.
     * @param fieldName The string value of the field to be sorted on
     * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
    **/
    public AA0_QueryFactory setOrdering(String fieldName, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        Ordering ordr = new Ordering(getFieldPath(fieldName), direction);
        return setOrdering(ordr);
    }

    /**
     * Remove existing ordering and set a field to be sorted on.  This may be a direct field or a field
     * related through an object lookup or masterdetail relationship.
     * Use the set to store unique field names, since we only want to sort
     * by the same field one time.  The sort expressions are stored in a list
     * so that they are applied to the SOQL in the same order that they
     * were added in.
     * @param field The SObjectfield to sort.  This can only be a direct reference.
     * @param SortOrder the direction to be sorted on (ASCENDING or DESCENDING)
    **/
    public AA0_QueryFactory setOrdering(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
        Ordering ordr = new Ordering(getFieldTokenPath(field), direction);
        return setOrdering(ordr);
    }

    /**
     * Convert the values provided to this instance into a full SOQL string for use with Database.query
     * Check to see if subqueries queries need to be added after the field list.
    **/
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

    /**
     * Create a "deep" clone of this object that can be safely mutated without affecting the cloned instance
     * @return a deep clone of this fflib_QueryFactory
    **/
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
        /**
         * Construct a new ordering instance for use with {@link fflib_QueryFactory#addOrdering}
         * Once constructed it's properties may not be modified.
        **/
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