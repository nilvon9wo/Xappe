public class XAP_DAO_SOQL_WHERE_InIdSetClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	String fieldName;
	Set<Id> idSet;

	private XAP_DAO_SOQL_WHERE_InIdSetClause(String fieldName, Set<Id> idSet) {
		this.fieldName = fieldName;
		this.idSet = idSet;
	}

	public XAP_DAO_SOQL_WHERE_InIdSetClause(SObjectField sObjectField, Set<Id> idSet) {
		this(XAP_DAO_SOQL_SObjectFieldHelper.getInstance().getFieldTokenPath(sObjectField), idSet);
	}

	public XAP_DAO_SOQL_WHERE_InIdSetClause(Set<Id> idSet) {
		this('Id', idSet);
	}

	public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
		String template = fieldName + ' IN :${idSet}';
		return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
				'idSet' => this.idSet
		});
	}
}