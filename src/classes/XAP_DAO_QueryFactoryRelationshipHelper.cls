public class XAP_DAO_QueryFactoryRelationshipHelper {
	XAP_DAO_SecurityUtils securityUtils;
	
	private XAP_DAO_QueryFactoryRelationshipHelper(XAP_DAO_SecurityUtils securityUtils) {
		this.securityUtils = securityUtils;
	}

	private XAP_DAO_QueryFactoryRelationshipHelper() {
		this(XAP_DAO_SecurityUtils.getInstance());
	}

	private static XAP_DAO_QueryFactoryRelationshipHelper INSTANCE;
	
	public static XAP_DAO_QueryFactoryRelationshipHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_DAO_QueryFactoryRelationshipHelper();
		}
		return INSTANCE; 
	}
	 
	// getChildRelationship --------------------------------------------------------------------------------------
	    
 	public Schema.ChildRelationship getChildRelationship(XAP_DAO_Query query, sObjectType thatSObjectType){
        for (Schema.ChildRelationship childRow : query.sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getChildSObject() == thatSObjectType && childRow.getRelationshipName() != null) { 
                return childRow;
            }   
        }
        throw new XAP_DAO_InvalidSubqueryRelationException(
        	'Invalid call to subselectQuery.  Invalid relationship for sObjectType '+ query.SObjectType
        	+ ' and sObjectType =' + thatSObjectType
        );
    }

 	public Schema.ChildRelationship getChildRelationship(XAP_DAO_Query query, String relationshipName){
        for (Schema.ChildRelationship childRow : query.sObjectType.getDescribe().getChildRelationships()){
            if (childRow.getRelationshipName() == relationshipName){ 
                return childRow;
            }   
        } 
        return null;
    } 

	// transverseRelationships  -------------------------------------------------------------------------------------

	public List<String> transverseRelationships(XAP_DAO_Query query, String fieldName) { 
		List<String> fieldPath = new List<String>();
		Schema.SObjectType lastSObjectType = query.sObjectType;
		Iterator<String> i = fieldName.split('\\.').iterator();
		while(i.hasNext()){
			String field = i.next();
			Schema.SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(lastSObjectType).getField(field.toLowerCase());
			DescribeFieldResult tokenDescribe = token != null ? token.getDescribe() : null;
			
			if (token != null && query.enforceFLS) {
				this.securityUtils.checkFieldIsReadable(lastSObjectType, token);
			}

			if(token != null && i.hasNext() && tokenDescribe.getSOAPType() == Schema.SOAPType.ID){
				lastSObjectType = tokenDescribe.getReferenceTo()[0]; 
				fieldPath.add(tokenDescribe.getRelationshipName());
			} 
			else if(token != null && !i.hasNext()){
				fieldPath.add(tokenDescribe.getName());
			} 
			else{
				throw (token == null)
					? (Exception) new XAP_DAO_InvalidFieldException(field,lastSObjectType)
				    : (Exception) new XAP_DAO_NonReferenceFieldException(lastSObjectType+'.'+field+' is not a lookup or master-detail field but is used in a cross-object query field.');
			}
		}
		return fieldPath;
	}

	    
}