public virtual class DAO_ThirdPartyAccountLinkSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_ThirdPartyAccountLinkSelector() {
    }

    private static DAO_ThirdPartyAccountLinkSelector instance;

    public static DAO_ThirdPartyAccountLinkSelector getInstance() {
        if (instance == null) {
            instance = new DAO_ThirdPartyAccountLinkSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return ThirdPartyAccountLink.SObjectType;
    }

    private List<Schema.SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                ThirdPartyAccountLink.Id,
                ThirdPartyAccountLink.Provider
        };
    }

    public List<ThirdPartyAccountLink> selectByHandle(Set<String> handleSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(
                        ThirdPartyAccountLink.Handle,
                        handleSet
                ))
                .query();
    }
}