public class AAA_PricebookEnrtrySelector extends AA0_SObjectSelectorAbs {
    private AAA_PricebookEnrtrySelector() {
    }

    private static AAA_PricebookEnrtrySelector instance;

    public static AAA_PricebookEnrtrySelector getInstance() {
        if (instance == null) {
            instance = new AAA_PricebookEnrtrySelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return PricebookEntry.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                PricebookEntry.Id
        };
    }
}