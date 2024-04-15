public with sharing class LWCR_ContactController {
    private final DAO_ContactSelector contactSelector;

    private LWCR_ContactController() {
        this(DAO_ContactSelector.getInstance());
    }

    public LWCR_ContactController(DAO_ContactSelector contactSelector) {
        this.contactSelector = contactSelector;
    }

    private static LWCR_ContactController INSTANCE;
    public static LWCR_ContactController getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new LWCR_ContactController();
        }
        return INSTANCE;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactsBornAfter(Date birthDate) {
        return getInstance()
                .selectBornAfter(birthDate);
    }

    public List<Contact> selectBornAfter(Date birthDate) {
        return this.contactSelector.selectBornAfter(birthDate);
    }
}