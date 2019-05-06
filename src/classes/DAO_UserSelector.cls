public virtual class DAO_UserSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_UserSelector() {
    }

    private static DAO_UserSelector instance;

    public static DAO_UserSelector getInstance() {
        if (instance == null) {
            instance = new DAO_UserSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return User.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                User.ContactId,
                User.Email,
                User.FederationIdentifier,
                User.FirstName,
                User.Id,
                User.LanguageLocaleKey,
                User.LastName,
                User.LocaleSidKey,
                User.MobilePhone,
                User.Name,
                User.Phone,
                User.Username,
                User.UserRoleId
        };
    }

    public override List<SObject> selectById(Set<Id> idSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }

    public virtual List<User> selectByUsername(Set<String> usernameSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(User.Username, usernameSet))
                .query();
    }

    public virtual List<User> selectByEmail(Set<String> emailSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(User.Email, emailSet))
                .query();
    }

    public virtual List<User> selectByMobilePhone(Set<String> mobilePhoneSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(User.MobilePhone, mobilePhoneSet))
                .query();
    }


}