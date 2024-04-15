public with sharing class LWCR_AccountController {
    private final DAO_AccountSelector accountSelector;

    private LWCR_AccountController() {
        this(DAO_AccountSelector.getInstance());
    }

    public LWCR_AccountController(DAO_AccountSelector accountSelector) {
        this.accountSelector = accountSelector;
    }

    private static LWCR_AccountController INSTANCE;
    public static LWCR_AccountController getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new LWCR_AccountController();
        }
        return INSTANCE;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts() {
        return getInstance()
                .selectAll();
    }

    public List<Account> selectAll() {
        return this.accountSelector.selectAll();
    }

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactsForAccountBornAfter() {
        throw new AuraHandledException('Forced error.');
    }
}