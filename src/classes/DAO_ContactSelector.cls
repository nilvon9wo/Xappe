public virtual with sharing class DAO_ContactSelector extends XAP_DAO_SOQL_SObjectSelectorAbs
        implements XAP_DAO_SOSL_SObjectFieldsProviderIntf {
    private DAO_ContactSelector() {
    }

    private static DAO_ContactSelector INSTANCE;
    public static DAO_ContactSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAO_ContactSelector();
        }
        return INSTANCE;
    }

    public SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Contact.AccountId,
                Contact.Email,
                Contact.Id,
                Contact.LastName,
                Contact.Name,
                Contact.Phone,
                Contact.Title
        };
    }

    //noinspection ApexUnusedDeclaration
    public List<Contact> selectByNetEmail() {
        return this.selectByEmailDomain('.net');
    }

    public List<Contact> selectByEmailDomain(String domain) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_StringCompareClause(
                        Contact.Email,
                        XAP_DAO_SOQL_WHERE_CompareOperatorEnum.IS_LIKE,
                        '%' + domain + '%'
                ))
                .addOrdering(Contact.LastName, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
                .setSecurityEnforced()
                .query();
    }

    //noinspection ApexUnusedDeclaration
    public List<Contact> selectWithAccount() {
        return this.createQueryFactory()
                .addField('Account.Name')
                .query();
    }

    public List<Contact> selectBornAfter(Date birthDate) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_ObjectCompareClause(
                        Contact.Birthdate,
                        XAP_DAO_SOQL_WHERE_CompareOperatorEnum.GREATER_THAN,
                        birthDate
                ))
                .addOrdering(Contact.LastName, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
                .setSecurityEnforced()
                .query();
    }
}