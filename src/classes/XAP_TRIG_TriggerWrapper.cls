public class XAP_TRIG_TriggerWrapper {     
	@TestVisible public Boolean 		 isExecuting 	   {get; private set;}
	@TestVisible public Boolean 		 isInsert   	   {get; private set;}
	@TestVisible public Boolean 		 isUpdate   	   {get; private set;}
	@TestVisible public Boolean 		 isDelete   	   {get; private set;}
	@TestVisible public Boolean 		 isUndelete 	   {get; private set;}
	@TestVisible public Boolean 		 isBefore          {get; private set;}
	@TestVisible public Boolean 		 isAfter           {get; private set;}
	@TestVisible public List<SObject> 	 oldSObjectList    {get; private set;}
	@TestVisible public List<SObject>	 newSObjectList    {get; private set;}
	@TestVisible public Map<Id, SObject> oldSObjectByIdMap {get; private set;}
	@TestVisible public Map<Id, SObject> newSObjectByIdMap {get; private set;}
	
	@TestVisible public SObjectType SObjectType {
			get {
				if (this.SObjectType == null) {
					Boolean hasNewSObjectList = (this.newSObjectList != null && !this.newSObjectList.isEmpty()); 		
					Boolean hasOldSObjectList = (this.oldSObjectList != null && !this.oldSObjectList.isEmpty()); 		
				    
				    SObject sampleSObject = hasNewSObjectList
				        ? this.newSObjectList[0] 
				        : ((hasOldSObjectList) ? this.oldSObjectList[0] : null); 
				        
			    	this.SObjectType = (sampleSObject != null)
			    		? sampleSObject.getSObjectType()
			    		: null;		
				}
				return this.SObjectType;
			} 
			private set;
	}
	 
	@TestVisible public TriggerOperation operation {
			get {
				if (this.operation == null && this.isExecuting) {
			        if( this.isBefore ) {
			            if( this.isInsert ) {
			                this.operation = TriggerOperation.BEFORE_INSERT;
			            } else if( this.isUpdate ) {
			                this.operation = TriggerOperation.BEFORE_UPDATE;
			            } else if( this.isDelete ) {
			                this.operation = TriggerOperation.BEFORE_DELETE;
			            }
			        } else if( this.isAfter ) {
			            if( this.isInsert ) {
			                this.operation = TriggerOperation.AFTER_INSERT;
			            } else if( this.isUpdate ) {
			                this.operation = TriggerOperation.AFTER_UPDATE;
			            } else if( this.isDelete ) {
			                this.operation = TriggerOperation.AFTER_DELETE;
			            } else if( this.isUndelete ) {
			                this.operation = TriggerOperation.AFTER_UNDELETE;
			            }
			        }
				}
				return this.operation;
			} 
			private set;
	}
	
	public XAP_TRIG_TriggerWrapper() {
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