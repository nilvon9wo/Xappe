public virtual class XAP_DAO_GenericDmlWrapper {
	private static XAP_DAO_GenericDmlWrapper INSTANCE;
	private XAP_DAO_GenericDmlWrapper() {
	}
	
	public XAP_DAO_GenericDmlWrapper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_DAO_GenericDmlWrapper();
		}
		return INSTANCE;
	}
	
	public static final Boolean ALL_OR_NONE = true;
	public static final Boolean NOT_ALL_OR_NONE = false;

	// Insert Methods -----------------------------------------------------------------------------------------

	public virtual List<XAP_DAO_DatabaseResultWrapper> doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
		return this.convert(Database.insert(sObjectList, dmlOptions));
	}    
		
	public virtual List<XAP_DAO_DatabaseResultWrapper> doInsert(List<SObject> sObjectList, Boolean allOrNone) {
		return this.convert(Database.insert(sObjectList, allOrNone));
	}    

	public virtual List<XAP_DAO_DatabaseResultWrapper> doInsert(List<SObject> sObjectList) {
		return this.doInsert(sObjectList, ALL_OR_NONE);
	}    

	// Update Methods -----------------------------------------------------------------------------------------

	public virtual List<XAP_DAO_DatabaseResultWrapper> doUpdate(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
		return this.convert(Database.update(sObjectList, dmlOptions));
	}    
		
	
	public virtual List<XAP_DAO_DatabaseResultWrapper> doUpdate(List<SObject> sObjectList, Boolean allOrNone) {
		return this.convert(Database.update(sObjectList, allOrNone));
	}     

	public virtual List<XAP_DAO_DatabaseResultWrapper> doUpdate(List<SObject> sObjectList) {
		return this.doUpdate(sObjectList, ALL_OR_NONE);
	}    

	// Upsert Methods -----------------------------------------------------------------------------------------

	public virtual List<XAP_DAO_DatabaseResultWrapper> doUpsert(List<SObject> homogeneousSObjectList, Boolean allOrNone) {
		if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
			return null;
		}
		
	  	// @see: https://salesforce.stackexchange.com/questions/215514/how-can-i-upsert-a-homogeneous-listsobject-in-a-good-way/215518#215518
    	String listType = 'List<' + homogeneousSObjectList[0].getSObjectType() + '>';
    	List<SObject> concreteSObjectList = (List<SObject>)Type.forName(listType).newInstance();
    	concreteSObjectList.addAll(homogeneousSObjectList);

		return this.convert(Database.upsert(concreteSObjectList, allOrNone));
	}    

	public virtual List<XAP_DAO_DatabaseResultWrapper> doUpsert(List<SObject> homogeneousSObjectList) {
		return this.doUpsert(homogeneousSObjectList, ALL_OR_NONE);
	}    
 
	// Delete Methods -----------------------------------------------------------------------------------------

	public virtual List<XAP_DAO_DatabaseResultWrapper> doDelete(List<SObject> sObjectList, Boolean allOrNone) {
		return this.convert(Database.delete(sObjectList, allOrNone));
	}    

	public virtual List<XAP_DAO_DatabaseResultWrapper> doDelete(List<SObject> sObjectList) {
		return this.doDelete(sObjectList, ALL_OR_NONE); 
	}    
	
	// Helper Methods --------------------------------------------------------------------------------------------
	
	@testVisible
	private List<XAP_DAO_DatabaseResultWrapper> convert(List<Database.SaveResult> saveResultList) {
		List<XAP_DAO_DatabaseResultWrapper> resultWrapperList = new List<XAP_DAO_DatabaseResultWrapper>();
		for (Database.SaveResult saveResult : saveResultList) {
			resultWrapperList.add(new XAP_DAO_DatabaseResultWrapper(saveResult));
		}
		return resultWrapperList;
	}

	@testVisible
	private List<XAP_DAO_DatabaseResultWrapper> convert(List<Database.DeleteResult> deleteResultList) {
		List<XAP_DAO_DatabaseResultWrapper> resultWrapperList = new List<XAP_DAO_DatabaseResultWrapper>();
		for (Database.DeleteResult deleteResult : deleteResultList) {
			resultWrapperList.add(new XAP_DAO_DatabaseResultWrapper(deleteResult));
		}
		return resultWrapperList;
	}

	@testVisible
	private List<XAP_DAO_DatabaseResultWrapper> convert(List<Database.UpsertResult> upsertResultList) {
		List<XAP_DAO_DatabaseResultWrapper> resultWrapperList = new List<XAP_DAO_DatabaseResultWrapper>();
		for (Database.UpsertResult upsertResult : upsertResultList) {
			resultWrapperList.add(new XAP_DAO_DatabaseResultWrapper(upsertResult));
		}
		return resultWrapperList;
	}

}