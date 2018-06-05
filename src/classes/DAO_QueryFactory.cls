public class DAO_QueryFactory {
	private static final Boolean ALLOW_CROSS_OBJECT = true;
	private static final Boolean NOT_ASSERTED_ACCESSIBLE = false;
	private static final Boolean NULLS_FIRST = false;

	private DAO_Query query;
	private DAO_QueryFactoryFieldHelper fieldHelper;
	private DAO_QueryFactoryRelationshipHelper relationshipHelper; 
	private DAO_SecurityUtils securityUtils;

	public DAO_QueryFactory(
			DAO_Query query, 
			DAO_QueryFactoryFieldHelper fieldHelper,
			DAO_QueryFactoryRelationshipHelper relationshipHelper,
			DAO_SecurityUtils securityUtils
		){
		this.query = query;
		this.fieldHelper = fieldHelper;
		this.relationshipHelper = relationshipHelper;
		this.securityUtils = securityUtils;
	} 

	public DAO_QueryFactory(Schema.SObjectType sObjectType){
		this(
			new DAO_Query(sObjectType), 
			DAO_QueryFactoryFieldHelper.getInstance(), 
			DAO_QueryFactoryRelationshipHelper.getInstance(),
			DAO_SecurityUtils.getInstance() 
		);
	} 

	public DAO_QueryFactory(Schema.ChildRelationship relationship){
		this(relationship.getChildSObject());  
		this.query.relationship = relationship; 
	}

	// setters -----------------------------------------------------------
	public DAO_QueryFactory setCondition(DAO_WHERE_ClauseIntf conditionExpression){
		this.query.conditionExpression = conditionExpression;
		return this; 
	}

	public DAO_QueryFactory setLimit(Integer limitCount){
		this.query.limitCount = limitCount;
		return this;
	}

	public DAO_QueryFactory setOffset(Integer offsetCount){
		this.query.offsetCount = offsetCount;
		return this;
	}

	// sortSelectFields -----------------------------------------------------------
	public DAO_QueryFactory setSortSelectFields(Boolean doSort){
		this.query.sortSelectFields = doSort;
		return this;
	}

	public DAO_QueryFactory setQuerySortOrdering(DAO_QuerySortOrdering ordering){
		this.query.setOrdering(new List<DAO_QuerySortOrdering>{ ordering });
		return this;
	}

	public DAO_QueryFactory setQuerySortOrdering(SObjectField field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this.query.setOrdering(field, direction, nullsLast);
		return this;
	}

	public DAO_QueryFactory setQuerySortOrdering(SObjectField field, DAO_QuerySortOrderEnum direction){
		return this.setQuerySortOrdering(field, direction, NULLS_FIRST);
	}

	public DAO_QueryFactory setQuerySortOrdering(String fieldName, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this.query.setOrdering(this.fieldHelper.getFieldPath(this.query, fieldName), direction, nullsLast);
		return this;
	}

	public DAO_QueryFactory setQuerySortOrdering(String fieldName, DAO_QuerySortOrderEnum direction){
		return this.setQuerySortOrdering(this.fieldHelper.getFieldPath(this.query, fieldName), direction, NULLS_FIRST);
	} 
	
	public DAO_QueryFactory addOrdering(DAO_QuerySortOrdering ordering){
		this.query.addOrdering(ordering);
		return this;
	}
	
    public DAO_QueryFactory addOrdering(SObjectField field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this.query.addOrdering(field, direction, nullsLast);
		return this;
    }

    public DAO_QueryFactory addOrdering(SObjectField field, DAO_QuerySortOrderEnum direction){
		return this.addOrdering(field, direction, NULLS_FIRST);
    }

    public DAO_QueryFactory addOrdering(String fieldName, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this.query.addOrdering(this.fieldHelper.getFieldPath(this.query, fieldName), direction, nullsLast);
		return this; 
    }

    public DAO_QueryFactory addOrdering(String fieldName, DAO_QuerySortOrderEnum direction){
		return this.addOrdering(this.fieldHelper.getFieldPath(this.query, fieldName), direction, NULLS_FIRST);
    }

	// SubselectQueries -------------------------------------------------------------------------------------
	public DAO_QueryFactory subselectQuery(SObjectType related){ 
		Schema.ChildRelationship relationship = this.relationshipHelper.getChildRelationship(this.query, related); 
		return this.setSubselectQuery(relationship, NOT_ASSERTED_ACCESSIBLE);
	}

	private DAO_QueryFactory setSubselectQuery(ChildRelationship relationship, Boolean assertIsAccessible){
		if (relationship != null){
			throw new DAO_InvalidSubqueryRelationshipException(
				'Invalid call to subselectQuery.  You may not add a subselect query to a subselect query.'
			);
		} 

		if (this.query.queryFactoryByRelationshipMap == null){
			this.query.queryFactoryByRelationshipMap = new Map<ChildRelationship, DAO_QueryFactory>();
		}
		return (this.query.queryFactoryByRelationshipMap.containsKey(this.query.relationship))
			? this.query.queryFactoryByRelationshipMap.get(this.query.relationship)
			: this.setSubselectQuery(assertIsAccessible);
	}
	
	private DAO_QueryFactory setSubselectQuery(Boolean assertIsAccessible) {
		DAO_QueryFactory subselectQuery = new DAO_QueryFactory(this.query.relationship);
		subSelectQuery.setSortSelectFields(this.query.sortSelectFields);
		if(assertIsAccessible){
			subSelectQuery.assertIsAccessible(); 
		}
		this.query.queryFactoryByRelationshipMap.put(this.query.relationship, subSelectQuery);
		return subSelectQuery;
	}
	

	public DAO_QueryFactory subselectQuery(String relationshipName){ 
		return subselectQuery(relationshipName, NOT_ASSERTED_ACCESSIBLE);
	}

	public DAO_QueryFactory subselectQuery(String relationshipName, Boolean assertIsAccessible){
		ChildRelationship relationship = this.relationshipHelper.getChildRelationship(this.query, relationshipName);
		if (relationship != null) {
			return setSubselectQuery(relationship, assertIsAccessible);
		}

		throw new DAO_InvalidSubqueryRelationshipException(
			'Invalid call to subselectQuery with this.query.relationshipName = ' + relationshipName 
			+ '.  Relationship does not exist for ' + this.query.sObjectType.getDescribe().getName()
		);	
	} 

	public DAO_QueryFactory subselectQuery(ChildRelationship relationship){ 
		return subselectQuery(relationship, NOT_ASSERTED_ACCESSIBLE);
	}

	public DAO_QueryFactory subselectQuery(ChildRelationship relationship, Boolean assertIsAccessible){
		return setSubselectQuery(relationship, assertIsAccessible);
	}


	// Setters -------------------------------------------------------------------------------------

	public DAO_QueryFactory setEnforceFLS(Boolean enforce){
		this.query.enforceFLS = enforce;
		return this;
	}

	// assertions -------------------------------------------------------------------

	public DAO_QueryFactory assertIsAccessible(){
		this.securityUtils.checkObjectIsReadable(this.query.sObjectType);
		return this;
	}

	// Select Fields ----------------------------------------------------------------------------

	public DAO_QueryFactory selectFields(Schema.FieldSet fieldSet, Boolean allowCrossObject){ 
		this.fieldHelper.selectFields(this.query, fieldSet, allowCrossObject);
		return this;
	}

	public DAO_QueryFactory selectFields(Schema.FieldSet fieldSet){
		return this.selectFields(fieldSet, ALLOW_CROSS_OBJECT);
	}

	public DAO_QueryFactory selectFields(Set<Schema.SObjectField> fieldSet){
		this.fieldHelper.selectFields(this.query, fieldSet);
		return this;
	}

	public DAO_QueryFactory selectFields(List<Schema.SObjectField> fieldList){
		return this.selectFields(new Set<Schema.SObjectField>(fieldList));
	}

	public DAO_QueryFactory selectField(Schema.SObjectField field){
		return this.selectFields(new Set<Schema.SObjectField>{field});
	}

	public DAO_QueryFactory selectFields(Set<String> fieldNameSet){
		this.fieldHelper.selectFields(this.query, fieldNameSet);
		return this;
	}

	public DAO_QueryFactory selectFields(List<String> fieldNameList){
		return this.selectFields(new Set<String>(fieldNameList));
	}

	public DAO_QueryFactory selectField(String fieldName){ 		
		return this.selectFields(new Set<String>{fieldName});
	} 

	public DAO_QueryFactory deepClone(){	
		DAO_QueryFactory clone = new DAO_QueryFactory(this.query.sObjectType)
			.setLimit(this.query.limitCount)  
			.setOffset(this.query.offsetCount)
			.setCondition(this.query.conditionExpression)
			.setEnforceFLS(this.query.enforceFLS);

		Map<Schema.ChildRelationship, DAO_QueryFactory> subqueries = this.query.queryFactoryByRelationshipMap;
		if(subqueries != null) {
			Map<Schema.ChildRelationship, DAO_QueryFactory> clonedSubqueries = new Map<Schema.ChildRelationship, DAO_QueryFactory>();
			for(Schema.ChildRelationship key : subqueries.keySet()) {
				clonedSubqueries.put(key, subqueries.get(key).deepClone());
			}
			clone.query.queryFactoryByRelationshipMap = clonedSubqueries;
		}

		clone.query.relationship = this.query.relationship;
		clone.query.orderingList = this.query.orderingList.clone();
		clone.query.fieldSet = this.query.fieldSet.clone();

		return clone;
	}

	// Convert ------------------------------------------------------------------------------------------------

	public String toSOQL(){
		return this.query.toSOQL();
	}
}