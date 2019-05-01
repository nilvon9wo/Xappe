public virtual class DAO_UserSelector extends XAP_DAO_SOQL_SObjectSelectorAbs
        implements XAP_DAO_ByContactIdSelectorIntf {
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
        return (List<User>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                        .subselectQuery(Contact.SObjectType)
                        .toSOQL()
        );
    }

    public virtual List<User> selectByContactId(Set<Id> contactIdSet) {
        return (List<User>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(User.ContactId, contactIdSet))
                        .subselectQuery(Contact.SObjectType)
                        .toSOQL()
        );
    }

    public virtual List<User> selectByUsername(Set<String> usernameSet) {
        return (List<User>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(User.Username, usernameSet))
                        .subselectQuery(Contact.SObjectType)
                        .toSOQL()
        );
    }

    public virtual List<User> selectByEmail(Set<String> emailSet) {
        return (List<User>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(User.Email, emailSet))
                        .subselectQuery(Contact.SObjectType)
                        .toSOQL()
        );
    }
}
