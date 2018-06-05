public class TRIG_TriggerWrapper {     
	@testVisible public Boolean 		 isExecuting 	   {get; private set;}
	@testVisible public Boolean 		 isInsert   	   {get; private set;}
	@testVisible public Boolean 		 isUpdate   	   {get; private set;}
	@testVisible public Boolean 		 isDelete   	   {get; private set;}
	@testVisible public Boolean 		 isUndelete 	   {get; private set;}  
	@testVisible public Boolean 		 isBefore          {get; private set;}
	@testVisible public Boolean 		 isAfter           {get; private set;}
	@testVisible public List<sObject> 	 oldSObjectList    {get; private set;}
	@testVisible public List<sObject>	 newSObjectList    {get; private set;}
	@testVisible public Map<ID, sObject> oldSObjectByIdMap {get; private set;}
	@testVisible public Map<ID, sObject> newSObjectByIdMap {get; private set;}
	
	@testVisible public SObjectType sObjectType {
			get {
				if (this.sObjectType == null) {
					Boolean hasNewSObjectList = (this.newSObjectList != null && !this.newSObjectList.isEmpty()); 		
					Boolean hasOldSObjectList = (this.oldSObjectList != null && !this.oldSObjectList.isEmpty()); 		
				    
				    SObject sampleSObject = hasNewSObjectList
				        ? this.newSObjectList[0] 
				        : ((hasOldSObjectList) ? this.oldSObjectList[0] : null); 
				        
			    	this.sObjectType = (sampleSObject != null)
			    		? sampleSObject.getSObjectType()
			    		: null;		
				}
				return this.sObjectType;
			} 
			private set;
	}
	 
	@testVisible public TRIG_TriggerEventOperationEnum operation { 
			get {
				if (this.operation == null && this.isExecuting) {
			        if( this.isBefore ) {
			            if( this.isInsert ) {
			                this.operation = TRIG_TriggerEventOperationEnum.BEFORE_INSERT;
			            } else if( this.isUpdate ) {
			                this.operation = TRIG_TriggerEventOperationEnum.BEFORE_UPDATE;
			            } else if( this.isDelete ) {
			                this.operation = TRIG_TriggerEventOperationEnum.BEFORE_DELETE;
			            }
			        } else if( this.isAfter ) {
			            if( this.isInsert ) {
			                this.operation = TRIG_TriggerEventOperationEnum.AFTER_INSERT;
			            } else if( this.isUpdate ) {
			                this.operation = TRIG_TriggerEventOperationEnum.AFTER_UPDATE;
			            } else if( this.isDelete ) {
			                this.operation = TRIG_TriggerEventOperationEnum.AFTER_DELETE;
			            } else if( this.isUndelete ) {
			                this.operation = TRIG_TriggerEventOperationEnum.AFTER_UNDELETE;
			            }
			        }
				}
				return this.operation;
			} 
			private set;
	}
	
	public TRIG_TriggerWrapper() {
		this.isExecuting 		= Trigger.isExecuting;
		this.isInsert 			= Trigger.isInsert;
		this.isUpdate 			= Trigger.isUpdate;
		this.isDelete 			= Trigger.isDelete;
		this.isUndelete 		= Trigger.isUndelete;
		this.isBefore 			= Trigger.isBefore;
		this.isAfter 			= Trigger.isAfter;
		this.oldSObjectList 	= Trigger.old;
		this.newSObjectList 	= Trigger.new;
		this.oldSObjectByIdMap 	= Trigger.oldMap;
		this.newSObjectByIdMap 	= Trigger.newMap;
	}
}