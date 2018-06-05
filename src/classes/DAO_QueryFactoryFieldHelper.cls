public class DAO_QueryFactoryFieldHelper {
	DAO_QueryFactoryRelationshipHelper relationshipHelper;
	DAO_SecurityUtils securityUtils;

	private DAO_QueryFactoryFieldHelper(DAO_QueryFactoryRelationshipHelper relationshipHelper, 	DAO_SecurityUtils securityUtils) {
		this.relationshipHelper = relationshipHelper;
		this.securityUtils = securityUtils;
	}
 
	private DAO_QueryFactoryFieldHelper() {
		this(DAO_QueryFactoryRelationshipHelper.getInstance(), DAO_SecurityUtils.getInstance());
	}
	
	private static DAO_QueryFactoryFieldHelper INSTANCE;

	public Set<String> selectFields(DAO_Query query, Schema.FieldSet fieldSet, Boolean allowCrossObject){
		if(fieldSet.getSObjectType() != query.sObjectType) {
			throw new DAO_InvalidFieldSetException(
				'Field set "' + fieldSet.getName() + '" is not for SObject type "' + query.sObjectType+'"'
			);
		}
			
		for(Schema.FieldSetMember field: fieldSet.getFields()){
			if(!allowCrossObject && field.getFieldPath().contains('.')) {
				throw new DAO_InvalidFieldSetException(
					'Cross-object query.fieldSet not allowed and field "'+field.getFieldPath()+'"" is a cross-object field.'
				);
			} 
			query.fieldSet.add( this.getFieldPath(query, field.getFieldPath()) );
		}
		return query.fieldSet;
	}

	public Set<String> selectFields(DAO_Query query, Set<Schema.SObjectField> fieldSet){
		for(Schema.SObjectField token : fieldSet){
			if(token == null) {
				throw new DAO_InvalidFieldException();
			}
					
			if (query.enforceFLS) {
				this.securityUtils.checkFieldIsReadable(query.sObjectType, token);
			} 
					
			query.fieldSet.add( this.getFieldTokenPath(token) );
		}
		return query.fieldSet;
	}

	public Set<String> selectFields(DAO_Query query, Set<String> fieldNames){
		for(String fieldName : fieldNames){
			query.fieldSet.add( this.getFieldPath(query, fieldName) );
		}	
		return query.fieldSet;
	}

	// ------------------------------------------------------------------------------------
	
	public static DAO_QueryFactoryFieldHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new DAO_QueryFactoryFieldHelper();
		}
		return INSTANCE;  
	}
 
	public String getFieldTokenPath(Schema.SObjectField field){
		if(field == null){
			throw new DAO_InvalidFieldException('Invalid field: null');		
		}
		return field.getDescribe().getName();
	}
	
	public String getFieldPath(DAO_Query query, String fieldName){
		if(!fieldName.contains('.')){ 
			Schema.SObjectField token = DESC_SObjectDescribe.getDescribe(query.sObjectType).getField(fieldName.toLowerCase());
			if(token == null) {
				throw new DAO_InvalidFieldException(fieldName,query.sObjectType);
			}
				
			if (query.enforceFLS) {
				this.securityUtils.checkFieldIsReadable(query.sObjectType, token);
			} 
			return token.getDescribe().getName();
		}

		return String.join(this.relationshipHelper.transverseRelationships(query, fieldName), '.');
	}
	
}