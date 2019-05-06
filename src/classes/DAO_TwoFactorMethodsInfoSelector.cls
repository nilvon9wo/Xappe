public virtual class DAO_TwoFactorMethodsInfoSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_TwoFactorMethodsInfoSelector() {
    }

    private static DAO_TwoFactorMethodsInfoSelector instance;

    public static DAO_TwoFactorMethodsInfoSelector getInstance() {
        if (instance == null) {
            instance = new DAO_TwoFactorMethodsInfoSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return TwoFactorMethodsInfo.SObjectType;
    }

    private List<Schema.SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                TwoFactorMethodsInfo.Id,
                TwoFactorMethodsInfo.HasUserVerifiedEmailAddress
        };
    }

    public List<TwoFactorMethodsInfo> selectByUserId(Set<Id> userIdSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(
                        TwoFactorMethodsInfo.UserId,
                        userIdSet
                ))
                .query();
    }
}