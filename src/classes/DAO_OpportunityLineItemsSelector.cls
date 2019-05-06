public class DAO_OpportunityLineItemsSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_OpportunityLineItemsSelector() {
    }

    private static DAO_OpportunityLineItemsSelector instance;

    public static DAO_OpportunityLineItemsSelector getInstance() {
        if (instance == null) {
            instance = new DAO_OpportunityLineItemsSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return OpportunityLineItem.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                OpportunityLineItem.Id
        };
    }
}