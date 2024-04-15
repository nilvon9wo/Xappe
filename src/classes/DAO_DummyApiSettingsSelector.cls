public with sharing class DAO_DummyApiSettingsSelector {
    private DAO_DummyApiSettingsSelector()
    {
    }

    private static DAO_DummyApiSettingsSelector INSTANCE;
    public static DAO_DummyApiSettingsSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAO_DummyApiSettingsSelector();
        }
        return INSTANCE;
    }

    public Dummy_Api_Settings__c selectInstance() {
        return Dummy_Api_Settings__c.getInstance();
    }
}