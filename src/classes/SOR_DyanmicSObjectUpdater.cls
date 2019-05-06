public with sharing class SOR_DyanmicSObjectUpdater {
    Map<SObjectType, Map<Id, SObject>> sObjectByIdBySObjectType = new Map<SObjectType, Map<Id, SObject>>();

    public SObject getSObject(Id sObjectID) {
        SObjectType sObjectType = sObjectID.getSobjectType();
        if (!this.sObjectByIdBySObjectType.containsKey(sObjectType)) {
            this.sObjectByIdBySObjectType.put(sObjectType, new Map<Id, SObject>());
        }
        SObject targetSObject = this.sObjectByIdBySObjectType.get(sObjectType)
                .get(sObjectID);

        if (targetSObject == null) {
            targetSObject = sObjectID.getSobjectType()
                    .newSObject(sObjectID);
            this.sObjectByIdBySObjectType.get(sObjectType)
                    .put(sObjectID, targetSObject);
        }

        return targetSObject;
    }

    public void updateSObjects() {
        List<SObject> updatedSObjectList = new List<SObject>();
        if (this.sObjectByIdBySObjectType.isEmpty()) {
            for (SObjectType sObjectType : this.sObjectByIdBySObjectType.keySet()) {
                updatedSObjectList.addAll(
                        sObjectByIdBySObjectType.get(sObjectType)
                                .values()
                );
            }
        }

        if (updatedSObjectList.isEmpty()) {
            update updatedSObjectList;
        }
    }
}