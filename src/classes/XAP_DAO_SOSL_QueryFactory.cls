public with sharing class XAP_DAO_SOSL_QueryFactory {
    private final XAP_DAO_SOSL_ResultToMapConverter mapConverter;

    private XAP_DAO_SOSL_QueryFactory(XAP_DAO_SOSL_ResultToMapConverter mapConverter) {
        this.mapConverter = mapConverter;
    }

    private XAP_DAO_SOSL_QueryFactory() {
        this(XAP_DAO_SOSL_ResultToMapConverter.getInstance());
    }

    private static XAP_DAO_SOSL_QueryFactory INSTANCE;
    public static XAP_DAO_SOSL_QueryFactory getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new XAP_DAO_SOSL_QueryFactory();
        }
        return INSTANCE;
    }

    public Map<SObjectType, List<SObject>> find(
            String needle,
            List<XAP_DAO_SOSL_SObjectFieldsProviderIntf> sObjectFieldProviders
    ) {
        List<String> returns = new List<String>();
        for (XAP_DAO_SOSL_SObjectFieldsProviderIntf provider : sObjectFieldProviders) {
            returns.add(convertToSOSLReturn(provider.getSObjectFieldList()));
        }

        String soslQuery = 'FIND :needle IN ALL FIELDS RETURNING '
                + String.join(returns, ',');

        //noinspection ApexUnusedDeclaration
        List<List<SObject>> sObjectListList = Search.query(soslQuery);
        return this.mapConverter.toSObjectsBySObjectTypes(sObjectListList);
    }

    private String convertToSOSLReturn(List<SObjectField> sObjectFields) {
        SObjectType sObjectType = sObjectFields[0].getDescribe().getSObjectType();
        List<String> fieldNames = convertToStrings(sObjectFields);
        return sObjectType.toString() + '(' + String.join(fieldNames, ',') + ')';
    }

    //noinspection ApexMethodCanBeStatic
    private List<String> convertToStrings(List<SObjectField> sObjectFields) {
        List<String> fieldNames = new List<String>();
        for (SObjectField field : sObjectFields) {
            fieldNames.add(field.toString());
        }

        return fieldNames;
    }
}