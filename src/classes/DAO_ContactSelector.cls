public virtual class DAO_ContactSelector extends XAP_DAO_SOQL_SObjectSelectorAbs
        implements XAP_DAO_ByContactIdSelectorIntf {
    private DAO_ContactSelector() {
    }

    private static DAO_ContactSelector instance;

    public static DAO_ContactSelector getInstance() {
        if (instance == null) {
            instance = new DAO_ContactSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Contact.Birthdate,
                Contact.Email,
                Contact.FirstName,
                Contact.Id,
                Contact.LastName,
                Contact.MobilePhone,
                Contact.Name,
                Contact.Phone,
                Contact.Salutation
        };
    }

    public List<Contact> selectByContactId(Set<Id> contactIdSet) {
        return super.selectById(contactIdSet);
    }

    public virtual List<Contact> selectByEmail(Set<String> emailSet) {
        return (List<Contact>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(Contact.Email, emailSet))
                        .toSOQL()
        );
    }
}
