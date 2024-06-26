@IsTest
public class XFTY_DummySObjectFactoryOutletLookup {
	private static final Map<SObjectType, Type> OUTLET_TYPE_BY_SOBJECT_TYPE
			= new Map<SObjectType, Type>{
					Account.SObjectType => TEST_DummyAccountFactoryOutlet.class,
					Contact.SObjectType => TEST_DummyContactFactoryOutlet.class,
					User.SObjectType => TEST_DummyUserFactoryOutlet.class
			};

	private static final Map<SObjectType, XFTY_DummySobjectFactoryOutletIntf> OUTLET_INSTANCE_BY_SOBJECT_TYPE
			= new Map<SObjectType, XFTY_DummySobjectFactoryOutletIntf>();

	public static XFTY_DummySobjectFactoryOutletIntf get(SObjectType sObjectType) {
		if (!OUTLET_INSTANCE_BY_SOBJECT_TYPE.containsKey(sObjectType)) {
			if (!(OUTLET_TYPE_BY_SOBJECT_TYPE.containsKey(sObjectType))) {
				new LookupException('No factory outlet found for : ' + sObjectType);
			}
			OUTLET_INSTANCE_BY_SOBJECT_TYPE.put(
					sObjectType,
					(XFTY_DummySobjectFactoryOutletIntf) (OUTLET_TYPE_BY_SOBJECT_TYPE.get(sObjectType)).newInstance()
			);
		}
		return OUTLET_INSTANCE_BY_SOBJECT_TYPE.get(sObjectType);
	}

	// --------------------------------------------------------------------------

	public class LookupException extends Exception {
	}
}