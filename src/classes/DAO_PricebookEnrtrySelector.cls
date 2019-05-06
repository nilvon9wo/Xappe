public class DAO_PricebookEnrtrySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_PricebookEnrtrySelector() {
    }

    private static DAO_PricebookEnrtrySelector instance;

    public static DAO_PricebookEnrtrySelector getInstance() {
        if (instance == null) {
            instance = new DAO_PricebookEnrtrySelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return PricebookEntry.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                PricebookEntry.Id
        };
    }
}