public with sharing class DAO_AccountWithContactSelector {
    private final DAO_AccountSelector accountSelector;
    private final DAO_ContactSelector contactSelector;
    private final XAP_DAO_SOSL_QueryFactory soslQueryFactory;

    private DAO_AccountWithContactSelector(
            DAO_AccountSelector accountSelector,
            DAO_ContactSelector contactSelector,
            XAP_DAO_SOSL_QueryFactory soslQueryFactory
    ) {
        this.accountSelector = accountSelector;
        this.contactSelector = contactSelector;
        this.soslQueryFactory = soslQueryFactory;
    }

    private DAO_AccountWithContactSelector() {
        this(
                DAO_AccountSelector.getInstance(),
                DAO_ContactSelector.getInstance(),
                XAP_DAO_SOSL_QueryFactory.getInstance()
        );
    }

    private static DAO_AccountWithContactSelector INSTANCE;
    public static DAO_AccountWithContactSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAO_AccountWithContactSelector();
        }
        return INSTANCE;
    }

    //noinspection ApexUnusedDeclaration
    public List<Account> selectWithContacts() {
        XAP_DAO_SOQL_QueryFactory accountQueryFactory = this.accountSelector.createQueryFactory();
        this.contactSelector.injectParentToSelectChildFields(accountQueryFactory, 'Contacts');
        return accountQueryFactory
                .query();
    }

    public Map<SObjectType, List<SObject>> find(String needle) {
        return this.soslQueryFactory.find(needle, new List<XAP_DAO_SOSL_SObjectFieldsProviderIntf>{
                this.accountSelector,
                this.contactSelector
        });
    }
}