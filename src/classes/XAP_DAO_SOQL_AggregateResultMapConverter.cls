public with sharing class XAP_DAO_SOQL_AggregateResultMapConverter {
    private XAP_DAO_SOQL_AggregateResultMapConverter() {
    }

    private static XAP_DAO_SOQL_AggregateResultMapConverter INSTANCE;
    public static XAP_DAO_SOQL_AggregateResultMapConverter getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new XAP_DAO_SOQL_AggregateResultMapConverter();
        }
        return INSTANCE;
    }

    public Map<Id, Decimal> convertToDecimalById(
            AggregateResult[] results,
            SObjectField sObjectField,
            String valueName
    ) {
        String keyName = sObjectField.toString();
        Map<Id, Decimal> valueByIds = new Map<Id, Decimal>();
        for (AggregateResult result : results) {
            Id key = (Id) results[0].get(keyName);
            Decimal value = (Decimal) results[0].get(valueName);
            valueByIds.put(key, value);
        }
        return valueByIds;
    }


    public Map<String, Integer> convertToIntegerByString(
            AggregateResult[] results,
            SObjectField sObjectField,
            String valueName
    ) {
        String keyName = sObjectField.toString();
        Map<String, Integer> valueByStrings = new Map<String, Integer>();
        for (AggregateResult result : results) {
            String key = (String) results[0].get(keyName);
            Integer value = (Integer) results[0].get(valueName);
            valueByStrings.put(key, value);
        }
        return valueByStrings;
    }


    public Map<Object, Object> convertToObjectByObject(
            AggregateResult[] results,
            SObjectField sObjectField,
            String valueName
    ) {
        String keyName = sObjectField.toString();
        Map<Object, Object> valueByKeys = new Map<Object, Object>();
        for (AggregateResult result : results) {
            Object key = results[0].get(keyName);
            Object value = results[0].get(valueName);
            valueByKeys.put(key, value);
        }
        return valueByKeys;
    }
}