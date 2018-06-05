public class XAP_DAO_QuerySortOrdering{
	private static final Boolean NULLS_FIRST = false;
	private XAP_DAO_QuerySortOrderEnum direction;
	private Boolean nullsLast;
	private String field;

	public XAP_DAO_QuerySortOrdering(String sobjType, String fieldName, XAP_DAO_QuerySortOrderEnum direction){
		this(
			XAP_DESC_SObjectDescribe.getDescribe(sobjType).getField(fieldName),
			direction
			); 
		} 

	public XAP_DAO_QuerySortOrdering(Schema.SObjectField field, XAP_DAO_QuerySortOrderEnum direction){
		this(XAP_DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(field), direction, NULLS_FIRST);
	} 

	public XAP_DAO_QuerySortOrdering(Schema.SObjectField field, XAP_DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this(XAP_DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(field), direction, nullsLast); 
	}
	
	public XAP_DAO_QuerySortOrdering(String field, XAP_DAO_QuerySortOrderEnum direction){
		this(field, direction, NULLS_FIRST);
	}
	
	public XAP_DAO_QuerySortOrdering(String field, XAP_DAO_QuerySortOrderEnum direction, Boolean nullsLast){
		this.direction = direction;
		this.field = field;
		this.nullsLast = nullsLast;
	}
	
	public String getField(){
		return this.field;  
	}
	
	public XAP_DAO_QuerySortOrderEnum getDirection(){
		return this.direction;
	}
	
	public String toSOQL(){
		return this.field + ' ' 
			+ (this.direction == XAP_DAO_QuerySortOrderEnum.ASCENDING ? 'ASC' : 'DESC') 
			+ ' NULLS ' + (this.nullsLast ? 'LAST' : 'FIRST') + ' ';
	}
}