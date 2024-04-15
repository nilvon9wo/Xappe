public with sharing class XAP_DAO_SOSL_ResultToMapConverter {
    private XAP_DAO_SOSL_ResultToMapConverter() {
    }

    private static XAP_DAO_SOSL_ResultToMapConverter INSTANCE;
    public static XAP_DAO_SOSL_ResultToMapConverter getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new XAP_DAO_SOSL_ResultToMapConverter();
        }
        return INSTANCE;
    }


    public Map<SObjectType, List<SObject>> toSObjectsBySObjectTypes(List<List<SObject>> sObjectListList) {
        Map<SObjectType, List<SObject>> sObjectsBySObjectTypes = new Map<SObjectType, List<SObject>>();
        for (List<SObject> sObjects : sObjectListList) {
            if (!sObjects.isEmpty()) {
                SObjectType sObjectType = sObjects[0].getSObjectType();
                sObjectsBySObjectTypes.put(sObjectType, sObjects);
            }
        }
        return sObjectsBySObjectTypes;
    }
}