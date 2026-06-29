@IsTest
public class TEST_DummyProduct2FactoryOutlet implements XFTY_DummySobjectProviderIntf {
    private static final XFTY_DummySObjectProviderLookupIntf PROVIDER_LOOKUP = new TEST_DummySObjectFactoryOutletLookup();
	public static final String DEFAULT_NAME_PREFIX = 'Test Product Name';
	private static final SObjectField PRIMARY_TARGET_FIELD = Product2.Id;

	public static final Product2 DEFAULT_PRODUCT {
		get {
			if (DEFAULT_PRODUCT == null) {
				DEFAULT_PRODUCT = (Product2) new XFTY_DummySObjectProvider(Product2.SObjectType, PROVIDER_LOOKUP)
						.setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
						.setInsertMode(XFTY_InsertModeEnum.NOW)
						.supply();
			}
			return DEFAULT_PRODUCT;
		}
		set;
	}
    //noinspection ApexUnusedDeclaration
    public static final Id DEFAULT_PRODUCT_ID {
			get {
				if (DEFAULT_PRODUCT_ID == null) {
					DEFAULT_PRODUCT_ID = DEFAULT_PRODUCT.Id;
				}
				return DEFAULT_PRODUCT_ID;
			}
			set;
	}

	private static final XFTY_DummySObjectMasterTemplate MASTER_TEMPLATE
			= new XFTY_DummySObjectMasterTemplate(PRIMARY_TARGET_FIELD)
					.put(Product2.IsActive, new XFTY_DummyDefaultValueExact(true))
					.put(Product2.Name, new XFTY_DummyDefaultValueIncrementingString(DEFAULT_NAME_PREFIX));

	public SObjectField getPrimaryTargetField() {
		return PRIMARY_TARGET_FIELD;
	}

	public XFTY_DummySObjectMasterTemplate getMasterTemplate() {
		return MASTER_TEMPLATE;
	}

    public XFTY_DummySObjectBundle createBundle(
            XFTY_DummySObjectProviderLookupIntf providerLookup,
            List<SObject> templateSObjectList,
            XFTY_InsertModeEnum insertMode,
            XFTY_InsertInclusivityEnum inclusivity
    ) {
        return XFTY_DummySObjectFactory.createBundle(providerLookup, MASTER_TEMPLATE, templateSObjectList, insertMode, inclusivity);
    }
}
