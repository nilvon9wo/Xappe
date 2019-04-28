@IsTest
public class XAP_DAO_GenericDmlWrapperMock extends XAP_DAO_GenericDmlWrapper {
	public static final String DML_EXCEPTION_MESSAGE = 'Exception by Design';
	public Boolean throwDmlException = false;
	
	public enum OperationType {DO_INSERT, DO_UPDATE, DO_UPSERT}
	public List<Operation> operationList = new List<Operation>();
	
	public List<List<XAP_DAO_DatabaseResultWrapper>> returnedResultWrapperListList;
	
	public Integer throwIndex = 0;
	private Integer returnIndex = 0;
	
	// Insert methods ------------------------------------------------------------------------------
	
	public override List<XAP_DAO_DatabaseResultWrapper> doInsert(List<SObject> sObjectList, Boolean allOrNone) {
		return this.mockInsert(sObjectList, allOrNone);
	}    
	
	public override List<XAP_DAO_DatabaseResultWrapper> doInsert(List<SObject> sObjectList) {
		return this.mockInsert(sObjectList, null);
	}   
	
	private List<XAP_DAO_DatabaseResultWrapper> mockInsert(List<SObject> sObjectList, Boolean allOrNone) {
		this.operationList.add(new Operation(OperationType.DO_INSERT, sObjectList, allOrNone));
		XAP_TEST_MockInsertHelper.addIds(sObjectList);   
		
		if (this.throwDmlException && throwIndex == returnIndex) {
			throw new DmlException(DML_EXCEPTION_MESSAGE);
		}
		
		return (this.returnedResultWrapperListList != null)
			? this.returnedResultWrapperListList[this.returnIndex++]
			: null;
	} 

	// Update methods ------------------------------------------------------------------------------

	public override List<XAP_DAO_DatabaseResultWrapper> doUpdate(List<SObject> sObjectList, Boolean allOrNone) {
		return this.mockUpdate(sObjectList, allOrNone);
	}    
	
	public override List<XAP_DAO_DatabaseResultWrapper> doUpdate(List<SObject> sObjectList) {
		return this.mockUpdate(sObjectList, null);
	}   

	private List<XAP_DAO_DatabaseResultWrapper> mockUpdate(List<SObject> sObjectList, Boolean allOrNone) {
		this.operationList.add(new Operation(OperationType.DO_UPDATE, sObjectList, allOrNone));
		
		if (this.throwDmlException && throwIndex == returnIndex) {
			throw new DmlException(DML_EXCEPTION_MESSAGE);
		}
		
		return (this.returnedResultWrapperListList != null)
			? this.returnedResultWrapperListList[this.returnIndex++]
			: null;
	} 

	// Upsert methods ------------------------------------------------------------------------------

	public override List<XAP_DAO_DatabaseResultWrapper> doUpsert(List<SObject> sObjectList, Boolean allOrNone) {
		return this.mockUpsert(sObjectList, allOrNone);
	}    

	public override List<XAP_DAO_DatabaseResultWrapper> doUpsert(List<SObject> sObjectList) {
		return this.mockUpsert(sObjectList, null);
	}    
    
	private List<XAP_DAO_DatabaseResultWrapper> mockUpsert(List<SObject> sObjectList, Boolean allOrNone) {
		this.operationList.add(new Operation(OperationType.DO_UPSERT, sObjectList, allOrNone));

		for (SObject sObj : sObjectList) {
			if (sObj.Id == null) {
				XAP_TEST_MockInsertHelper.addId(sObj);  
			}
		}		
		
		if (this.throwDmlException && throwIndex == returnIndex) {
			throw new DmlException(DML_EXCEPTION_MESSAGE);
		}
		
		return (this.returnedResultWrapperListList != null)
			? this.returnedResultWrapperListList[this.returnIndex++]
			: null;
	}     
    
    // -------------------------------------------------------------------------------------------
    
    public class Operation {
    	public OperationType operationType;
    	public List<SObject> sObjectList;
    	public Boolean allOrNone;
    	
    	public Operation(OperationType operationType, List<SObject> sObjectList, Boolean allOrNone) {
    		this.operationType = operationType;
    		this.sObjectList = sObjectList;
    		this.allOrNone = allOrNone;
    	} 
    }
}