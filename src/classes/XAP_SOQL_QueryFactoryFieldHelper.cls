public class XAP_SOQL_QueryFactoryFieldHelper {
	XAP_SOQL_QueryFactoryRelationshipHelper relationshipHelper;
	XAP_SOQL_SecurityUtils securityUtils;

	private XAP_SOQL_QueryFactoryFieldHelper(XAP_SOQL_QueryFactoryRelationshipHelper relationshipHelper, 	XAP_SOQL_SecurityUtils securityUtils) {
		this.relationshipHelper = relationshipHelper;
		this.securityUtils = securityUtils;
	}
 
	private XAP_SOQL_QueryFactoryFieldHelper() {
		this(XAP_SOQL_QueryFactoryRelationshipHelper.getInstance(), XAP_SOQL_SecurityUtils.getInstance());
	}
	
	private static XAP_SOQL_QueryFactoryFieldHelper INSTANCE;

	public Set<String> selectFields(XAP_SOQL_Query query, Schema.FieldSet fieldSet, Boolean allowCrossObject){
		if(fieldSet.getSObjectType() != query.sObjectType) {
			throw new XAP_SOQL_InvalidFieldSetException(
				'Field set "' + fieldSet.getName() + '" is not for SObject type "' + query.sObjectType+'"'
			);
		}
			
		for(Schema.FieldSetMember field: fieldSet.getFields()){
			if(!allowCrossObject && field.getFieldPath().contains('.')) {
				throw new XAP_SOQL_InvalidFieldSetException(
					'Cross-object query.fieldSet not allowed and field "'+field.getFieldPath()+'"" is a cross-object field.'
				);
			} 
			query.fieldSet.add( this.getFieldPath(query, field.getFieldPath()) );
		}
		return query.fieldSet;
	}

	public Set<String> selectFields(XAP_SOQL_Query query, Set<Schema.SObjectField> fieldSet){
		for(Schema.SObjectField token : fieldSet){
			if(token == null) {
				throw new XAP_SOQL_InvalidFieldException();
			}
					
			if (query.enforceFLS) {
				this.securityUtils.checkFieldIsReadable(query.sObjectType, token);
			} 
					
			query.fieldSet.add( this.getFieldTokenPath(token) );
		}
		return query.fieldSet;
	}

	public Set<String> selectFields(XAP_SOQL_Query query, Set<String> fieldNames){
		for(String fieldName : fieldNames){
			query.fieldSet.add( this.getFieldPath(query, fieldName) );
		}	
		return query.fieldSet;
	}

	// ------------------------------------------------------------------------------------
	
	public static XAP_SOQL_QueryFactoryFieldHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_SOQL_QueryFactoryFieldHelper();
		}
		return INSTANCE;  
	}
 
	public String getFieldTokenPath(Schema.SObjectField field){
		if(field == null){
			throw new XAP_SOQL_InvalidFieldException('Invalid field: null');
		}
		return field.getDescribe().getName();
	}
	
	public String getFieldPath(XAP_SOQL_Query query, String fieldName){
		if(!fieldName.contains('.')){ 
			Schema.SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(query.sObjectType).getField(fieldName.toLowerCase());
			if(token == null) {
				throw new XAP_SOQL_InvalidFieldException(fieldName,query.sObjectType);
			}
				
			if (query.enforceFLS) {
				this.securityUtils.checkFieldIsReadable(query.sObjectType, token);
			} 
			return token.getDescribe().getName();
		}

		return String.join(this.relationshipHelper.transverseRelationships(query, fieldName), '.');
	}
	
}