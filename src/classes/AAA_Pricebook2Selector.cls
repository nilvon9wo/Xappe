public class AAA_Pricebook2Selector extends A00_SObjectSelector {
    private AAA_Pricebook2Selector() {
    }

    private static AAA_Pricebook2Selector instance;

    public static AAA_Pricebook2Selector getInstance() {
        if (instance == null) {
            instance = new AAA_Pricebook2Selector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Pricebook2.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Pricebook2.Id
        };
    }
}