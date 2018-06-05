public class DAO_Query {
	private static transient final Boolean DEFAULT_ENFORCE_FLS = false;
	private static transient final Boolean DEFAULT_SORT_SELECT_FIELDS = true;

	private DAO_SecurityUtils securityUtils;
	public Schema.SObjectType sObjectType {get; private set;}

    public DAO_Query (Schema.SObjectType sObjectType, DAO_SecurityUtils securityUtils) {
    	this.securityUtils = securityUtils;
		this.sObjectType = sObjectType;
		this.enforceFLS = DEFAULT_ENFORCE_FLS; 
		this.fieldSet = new Set<String>();
		this.orderingList = new List<DAO_QuerySortOrdering>();
		this.sortSelectFields = DEFAULT_SORT_SELECT_FIELDS;
    }

    public DAO_Query (Schema.SObjectType sObjectType) {
		this(sObjectType, DAO_SecurityUtils.getInstance());
    }
 
	public Set<String> fieldSet;
	public List<DAO_QuerySortOrdering> orderingList;
	public Map<Schema.ChildRelationship, DAO_QueryFactory> queryFactoryByRelationshipMap;
	
	public DAO_WHERE_ClauseIntf conditionExpression;  
	public Integer limitCount;
	public Integer offsetCount;
	public Boolean enforceFLS;
	public Boolean sortSelectFields; 
	public Schema.ChildRelationship relationship;

	public List<DAO_QuerySortOrdering> setOrdering(List<DAO_QuerySortOrdering> orderingList){
		this.orderingList = orderingList;
		return this.orderingList;
	}

	public List<DAO_QuerySortOrdering> setOrdering(DAO_QuerySortOrdering ordering){
		return this.setOrdering(new List<DAO_QuerySortOrdering>{ ordering });
	}

    public List<DAO_QuerySortOrdering> setOrdering(SObjectField field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		return this.setOrdering(new DAO_QuerySortOrdering(field, direction, nullsLast));
    }

    public List<DAO_QuerySortOrdering> setOrdering(String field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		return this.setOrdering(new DAO_QuerySortOrdering(field, direction, nullsLast));
    }

    public List<DAO_QuerySortOrdering> addOrdering(DAO_QuerySortOrdering ordering){
		this.orderingList.add(ordering);
		return this.orderingList;
    }

    public List<DAO_QuerySortOrdering> addOrdering(SObjectField field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		return this.addOrdering(new DAO_QuerySortOrdering(field, direction, nullsLast));
    }

    public List<DAO_QuerySortOrdering> addOrdering(String field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		return this.addOrdering(new DAO_QuerySortOrdering(field, direction, nullsLast));
    }

	public Boolean equals(Object obj){
		if( !(obj instanceof DAO_Query) 
			|| ((DAO_Query) obj).sObjectType != this.sObjectType 
			|| ((DAO_Query) obj).fieldSet.size() != this.fieldSet.size() 
		) {
			return false;
		}
			
		return ((DAO_Query) obj).toSOQL() == this.toSOQL(); 
	}

    
	public String toSOQL(){ 
		return this.toSoqlSelect()  
			+ this.toSoqlFrom()
			+ this.toSOQL('WHERE', this.conditionExpression.toSOQL())
			+ this.toSoqlOrderBy()
			+ this.toSOQL('LIMIT', this.limitCount)  
			+ this.toSOQL('OFFSET', this.offsetCount);
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
			if(this.sortSelectFields){
				fieldSetToQuery.sort(); 
			}	 
		
			result += String.join(fieldSetToQuery, ', ');  
		}
		
		if(this.queryFactoryByRelationshipMap != null && !this.queryFactoryByRelationshipMap.isEmpty()) {
			for (DAO_QueryFactory childRow : this.queryFactoryByRelationshipMap.values()) {
				result += ', (' + childRow.toSOQL() + ') ';
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
		if(this.orderingList.size() > 0) {
			result += ' ORDER BY ';
			for(DAO_QuerySortOrdering ordering :this.orderingList) {
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