public class XAP_DAO_SOQL_SObjectFieldHelper {
	XAP_DAO_SOQL_SecurityUtils securityUtils;

	private XAP_DAO_SOQL_SObjectFieldHelper(XAP_DAO_SOQL_SecurityUtils securityUtils) {
		this.securityUtils = securityUtils;
	}

	private XAP_DAO_SOQL_SObjectFieldHelper() {
		this(XAP_DAO_SOQL_SecurityUtils.getInstance());
	}

	private static XAP_DAO_SOQL_SObjectFieldHelper instance;

	public static XAP_DAO_SOQL_SObjectFieldHelper getInstance() {
		instance = new XAP_DAO_SOQL_SObjectFieldHelper();
		return instance;
	}

	public String getFieldPath(SObjectType sObjectType, String fieldName, Boolean enforceFLS) {
		return (this.isSingleField(fieldName))
				? this.getFieldName(sObjectType, fieldName, enforceFLS)
						.getDescribe()
						.getName()
				: this.traverseFieldKeyRelationships(sObjectType, fieldName, enforceFLS);
	}

	private Boolean isSingleField(String fieldName) {
		return !fieldName.contains('.');
	}

	private SObjectField getFieldName(SObjectType sObjectType, String fieldName, Boolean enforceFLS) {
		SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(sObjectType)
				.getField(fieldName.toLowerCase());
		if (token == null) {
			throw new XAP_DAO_SOQL_InvalidFieldException(fieldName, sObjectType);
		}

		if (enforceFLS) {
			this.securityUtils.checkFieldIsReadable(sObjectType, token);
		}
		return token;
	}

	private String traverseFieldKeyRelationships(SObjectType sObjectType, String fieldPathString, Boolean enforceFLS) {
		List<String> fieldPath = new List<String>();
		SObjectType lastSObjectType = sObjectType;
		Iterator<String> fieldPathPartIterator = fieldPathString.split('\\.').iterator();
		while (fieldPathPartIterator.hasNext()) {
			String field = fieldPathPartIterator.next();
			SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(lastSObjectType)
					.getField(field.toLowerCase());
			DescribeFieldResult tokenDescribe = token != null ? token.getDescribe() : null;

			if (token != null && enforceFLS) {
				this.securityUtils.checkFieldIsReadable(lastSObjectType, token);
			}

			if (token != null && fieldPathPartIterator.hasNext() && tokenDescribe.getSoapType() == Schema.SoapType.ID) {
				lastSObjectType = tokenDescribe.getReferenceTo()[0]; //if it's polymorphic doesn't matter which one we get
				fieldPath.add(tokenDescribe.getRelationshipName());
			}
			else if (token != null && !fieldPathPartIterator.hasNext()) {
				fieldPath.add(tokenDescribe.getName());
			}
			else {
				if (token == null) {
					throw new XAP_DAO_SOQL_InvalidFieldException(field, lastSObjectType);
				}
				else {
					throw new XAP_DAO_SOQL_NonReferenceFieldException(
							lastSObjectType + '.' + field
									+ ' is not a lookup or master-detail field'
									+ 'but is used in a cross-object query field.'
					);
				}
			}
		}

		return String.join(fieldPath, '.');
	}

	public String getFieldTokenPath(SObjectField field) {
		if (field == null) {
			throw new XAP_DAO_SOQL_InvalidFieldException('Invalid field: null');
		}
		return field.getDescribe().getName();
	}
}