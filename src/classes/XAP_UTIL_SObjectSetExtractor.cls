public virtual class XAP_UTIL_SObjectSetExtractor {
	private static XAP_UTIL_SObjectSetExtractor INSTANCE;
	protected XAP_UTIL_SObjectSetExtractor() {
	}
	
	public static XAP_UTIL_SObjectSetExtractor getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_UTIL_SObjectSetExtractor();
		}
		return INSTANCE;
	}
		
    public virtual Set<Id> extractNonNullIdsFrom(List<SObject> sObjectList, SObjectField idField){
    	Set<Id> resultSet = new Set<Id>();
    	for (SObject sObj : sObjectList) {
    		if (sObj.get(idField) != null) {
    			resultSet.add((Id) sObj.get(idField));
    		} 
    	}
    	return resultSet; 
    }

    public virtual Set<String> extractNonBlanksFrom(List<SObject> sObjectList, SObjectField stringField){
    	Set<String> resultSet = new Set<String>();
    	for (SObject sObj : sObjectList) {
    		String value = (String) sObj.get(stringField);
    		if (!String.isBlank(value)) {
    			resultSet.add(value);
    		} 
    	}
    	return resultSet; 
    }
}