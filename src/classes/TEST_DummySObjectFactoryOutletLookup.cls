@IsTest
public class TEST_DummySObjectFactoryOutletLookup implements XFTY_DummySObjectProviderLookupIntf {
    private static final Map<SObjectType, Type> OUTLET_TYPE_BY_SOBJECT_TYPE
            = new Map<SObjectType, Type>{
                    Account.SObjectType => TEST_DummyAccountFactoryOutlet.class,
                    Contact.SObjectType => TEST_DummyContactFactoryOutlet.class,
                    Product2.SObjectType => TEST_DummyProduct2FactoryOutlet.class,
                    User.SObjectType => TEST_DummyUserFactoryOutlet.class,
                    XAP_TRIG_TriggerSetting__c.SObjectType => TEST_DummyXapTriggerSettingFactoryOutlet.class
            };

    private static final Map<SObjectType, XFTY_DummySobjectProviderIntf> OUTLET_INSTANCE_BY_SOBJECT_TYPE
            = new Map<SObjectType, XFTY_DummySobjectProviderIntf>();

    public static XFTY_DummySobjectProviderIntf get(SObjectType sObjectType) {
        if (!OUTLET_INSTANCE_BY_SOBJECT_TYPE.containsKey(sObjectType)) {
            if (!(OUTLET_TYPE_BY_SOBJECT_TYPE.containsKey(sObjectType))) {
                new LookupException('No factory outlet found for : ' + sObjectType);
            }
            OUTLET_INSTANCE_BY_SOBJECT_TYPE.put(
                    sObjectType,
                    (XFTY_DummySobjectProviderIntf) (OUTLET_TYPE_BY_SOBJECT_TYPE.get(sObjectType)).newInstance()
            );
        }
        return OUTLET_INSTANCE_BY_SOBJECT_TYPE.get(sObjectType);
    }

    // --------------------------------------------------------------------------

    public class LookupException extends Exception {
    }
}