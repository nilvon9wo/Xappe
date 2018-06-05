public class DAO_QuerySortOrdering{
	private static final Boolean NULLS_FIRST = false;
	private DAO_QuerySortOrderEnum direction;
	private Boolean nullsLast;
	private String field;

	public DAO_QuerySortOrdering(String sobjType, String fieldName, DAO_QuerySortOrderEnum direction){
		this(
			DESC_SObjectDescribe.getDescribe(sobjType).getField(fieldName),
			direction
			); 
		} 

	public DAO_QuerySortOrdering(Schema.SObjectField field, DAO_QuerySortOrderEnum direction){
		this(DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(field), direction, NULLS_FIRST);
	} 

	public DAO_QuerySortOrdering(Schema.SObjectField field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this(DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(field), direction, nullsLast); 
	}
	
	public DAO_QuerySortOrdering(String field, DAO_QuerySortOrderEnum direction){
		this(field, direction, NULLS_FIRST);
	}
	
	public DAO_QuerySortOrdering(String field, DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this.direction = direction;
		this.field = field;
		this.nullsLast = nullsLast;
	}
	
	public String getField(){
		return this.field;  
	}
	
	public DAO_QuerySortOrderEnum getDirection(){
		return this.direction;
	}
	
	public String toSOQL(){
		return this.field + ' ' 
			+ (this.direction == DAO_QuerySortOrderEnum.ASCENDING ? 'ASC' : 'DESC') 
			+ ' NULLS ' + (this.nullsLast ? 'LAST' : 'FIRST') + ' ';
	}
}