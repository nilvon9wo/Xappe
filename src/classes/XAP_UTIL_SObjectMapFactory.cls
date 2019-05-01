public virtual class XAP_UTIL_SObjectMapFactory {
	private static XAP_UTIL_SObjectMapFactory instance;
	protected XAP_UTIL_SObjectMapFactory() {
	}
	
	public static XAP_UTIL_SObjectMapFactory getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectMapFactory();
		}
		return instance;
	}
	 
    public static Map<Id, List<SObject>> mapBySpecifiedIdField (List<SObject> homogeneousSObjectList, SObjectField idField) {
	    if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
	        return null;
	    }
	
	    Map<Id, List<SObject>> sObjectListBySpecifiedIdMap = new Map<Id, List<SObject>>();
	    for (SObject sObj : homogeneousSObjectList) {
	        Id specifiedId = (Id) sObj.get(idField);
	        if (!String.isBlank(specifiedId)) {
	            if (!sObjectListBySpecifiedIdMap.containsKey(sObj.Id)) {
	                sObjectListBySpecifiedIdMap.put(sObj.Id, new List<SObject>());
	            }
	            sObjectListBySpecifiedIdMap.get(sObj.id).add(sObj); 
	        }
	    }
	
	    String mapType = 'Map<Id, List<' + homogeneousSObjectList[0].getSObjectType() + '>>';
	    Map<Id, List<SObject>> concreteSObjectListByIdMap = (Map<Id, List<SObject>>)Type.forName(mapType).newInstance();
	    concreteSObjectListByIdMap.putAll(sObjectListBySpecifiedIdMap);
	
	    return concreteSObjectListByIdMap;
	}    

    public static Map<Id, SObject> mapByUniqueSpecifiedIdField (List<SObject> sObjectList, SObjectField idField) {
	    if (sObjectList == null || sObjectList.isEmpty()) {
	        return null;
	    }
	
	    Map<Id, SObject> sObjectBySpecifiedIdMap = new Map<Id,  SObject>();
	    for (SObject sObj : sObjectList) {
	        Id specifiedId = (Id) sObj.get(idField);
	        if (!String.isBlank(specifiedId)) {
	            if (sObjectBySpecifiedIdMap.containsKey(sObj.Id)) {
           			throw new XAP_UTIL_MapManyToOneException(
	    				'Many-to-one relationships.  '
	    				+ ' Id ' + sObj.Id + ' is assigned to both'
	    				+ ' 1: ' + sObj + ' and '
	    				+ ' 2: ' + sObjectBySpecifiedIdMap.get(sObj.Id)
	    			);
	            }
	            sObjectBySpecifiedIdMap.put(sObj.id, sObj); 
	        }
	    }
	
	    return sObjectBySpecifiedIdMap;
	}    

}
