public class DAO_QueryFactoryRelationshipHelper {
	DAO_SecurityUtils securityUtils;
	
	private DAO_QueryFactoryRelationshipHelper(DAO_SecurityUtils securityUtils) {
		this.securityUtils = securityUtils;
	}

	private DAO_QueryFactoryRelationshipHelper() {
		this(DAO_SecurityUtils.getInstance());
	}

	private static DAO_QueryFactoryRelationshipHelper INSTANCE;
	
	public static DAO_QueryFactoryRelationshipHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new DAO_QueryFactoryRelationshipHelper();
		}
		return INSTANCE; 
	}
	 
	// getChildRelationship --------------------------------------------------------------------------------------
	    
 	public Schema.ChildRelationship getChildRelationship(DAO_Query query, sObjectType thatSObjectType){
        for (Schema.ChildRelationship childRow : query.sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getChildSObject() == thatSObjectType && childRow.getRelationshipName() != null) { 
                return childRow;
            }   
        }
        throw new DAO_InvalidSubqueryRelationshipException(
        	'Invalid call to subselectQuery.  Invalid relationship for sObjectType '+ query.sObjectType 
        	+ ' and sObjectType =' + thatSObjectType
        );
    }

 	public Schema.ChildRelationship getChildRelationship(DAO_Query query, String relationshipName){
        for (Schema.ChildRelationship childRow : query.sObjectType.getDescribe().getChildRelationships()){
            if (childRow.getRelationshipName() == relationshipName){ 
                return childRow;
            }   
        } 
        return null;
    } 

	// transverseRelationships  -------------------------------------------------------------------------------------

	public List<String> transverseRelationships(DAO_Query query, String fieldName) { 
		List<String> fieldPath = new List<String>();
		Schema.sObjectType lastSObjectType = query.sObjectType;
		Iterator<String> i = fieldName.split('\\.').iterator();
		while(i.hasNext()){
			String field = i.next();
			Schema.SObjectField token = DESC_SObjectDescribe.getDescribe(lastSObjectType).getField(field.toLowerCase());
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
					? (Exception) new DAO_InvalidFieldException(field,lastSObjectType)
				    : (Exception) new DAO_NonReferenceFieldException(lastSObjectType+'.'+field+' is not a lookup or master-detail field but is used in a cross-object query field.');
			}
		}
		return fieldPath;
	}

	    
}