public virtual class DAO_AuthProviderSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
	private DAO_AuthProviderSelector() {
	}

	private static DAO_AuthProviderSelector instance;

	public static DAO_AuthProviderSelector getInstance() {
		if (instance == null) {
			instance = new DAO_AuthProviderSelector();
		}
		return instance;
	}

	public SObjectType getSObjectType() {
		return AuthProvider.SObjectType;
	}

	private List<SObjectField> getSObjectFieldList() {
		return new List<SObjectField>{
				AuthProvider.Id,
				AuthProvider.SsoKickoffUrl
		};
	}

	public List<AuthProvider> selectByDeveloperName(Set<String> developerNameIdSet) {
		return this.createQueryFactory()
				.setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(
						AuthProvider.DeveloperName,
						developerNameIdSet
				))
				.query();
	}
}