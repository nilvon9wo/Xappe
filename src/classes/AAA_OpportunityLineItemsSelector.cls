public class AAA_OpportunityLineItemsSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private AAA_OpportunityLineItemsSelector() {
    }

    private static AAA_OpportunityLineItemsSelector instance;

    public static AAA_OpportunityLineItemsSelector getInstance() {
        if (instance == null) {
            instance = new AAA_OpportunityLineItemsSelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return OpportunityLineItem.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                OpportunityLineItem.Id
        };
    }
}