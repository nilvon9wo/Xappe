public class XAP_TRIG_TriggerProperties {
	@TestVisible public Boolean isExecuting { get; private set; }
	@TestVisible public Boolean isInsert { get; private set; }
	@TestVisible public Boolean isUpdate { get; private set; }
	@TestVisible public Boolean isDelete { get; private set; }
	@TestVisible public Boolean isUndelete { get; private set; }
	@TestVisible public Boolean isBefore { get; private set; }
	@TestVisible public Boolean isAfter { get; private set; }

	@TestVisible public List<SObject> oldSObjectList { get; private set; }
	@TestVisible public List<SObject> newSObjectList { get; private set; }
	@TestVisible public Map<Id, SObject> oldSObjectByIdMap { get; private set; }
	@TestVisible public Map<Id, SObject> newSObjectByIdMap { get; private set; }

	@TestVisible public System.TriggerOperation operationType { get; private set; }

	@TestVisible public SObjectType sObjectType {
		get {
			if (this.sObjectType == null) {
				this.sObjectType = this.selectSObjectType();
			}
			return this.sObjectType;
		}
		private set;
	}

	private XAP_COLL_SObjectListExtractor listExtractor;

	private XAP_COLL_SObjectValueSetExtractor setExtractor;

	private XAP_TRIG_TriggerProperties(XAP_COLL_SObjectListExtractor listExtractor) {
		this.isExecuting = Trigger.isExecuting;
		this.isInsert = Trigger.isInsert;
		this.isUpdate = Trigger.isUpdate;
		this.isDelete = Trigger.isDelete;
		this.isUndelete = Trigger.isUndelete;
		this.isBefore = Trigger.isBefore;
		this.isAfter = Trigger.isAfter;
		this.oldSObjectList = Trigger.old;
		this.newSObjectList = Trigger.new;
		this.oldSObjectByIdMap = Trigger.oldMap;
		this.newSObjectByIdMap = Trigger.newMap;
		
		this.operationType = Trigger.operationType;
		this.listExtractor = listExtractor;



		this.setExtractor = setExtractor;



	}

	public XAP_TRIG_TriggerProperties() {
		this(XAP_COLL_SObjectListExtractor.getInstance());
	}

	@TestVisible
	private SObjectType selectSObjectType() {
		// This assumes a homogenous list, which I think should always be true for triggers.
		Boolean hasNewSObjectList = (this.newSObjectList != null && !this.newSObjectList.isEmpty());
		Boolean hasOldSObjectList = (this.oldSObjectList != null && !this.oldSObjectList.isEmpty());

		SObject sampleSObject = hasNewSObjectList
				? this.newSObjectList[0]
				: ((hasOldSObjectList) ? this.oldSObjectList[0] : null);

		return (sampleSObject != null)
				? sampleSObject.getSObjectType()
				: null;
	}

	public List<SObject> collectChangedFor(SObjectField sObjectField) {
		return (this.isInsert)
				? this.newSObjectList
				: this.collectChangedOnUpdate(sObjectField);
	}

	private List<SObject> collectChangedOnUpdate(SObjectField sObjectField) {
		XAP_PRED_SObjectFieldIsChanged predicate
				= new XAP_PRED_SObjectFieldIsChanged(this.oldSObjectByIdMap, sObjectField);
		return  this.listExtractor.extractWhereTrue(this.newSObjectList, predicate);
	}




	public List<SObject> collectListForNewlyTrue(SObjectField BooleanField) {
		return this.listExtractor.extractWhereAllPredicatesTrue(this.newSObjectList, new List<XAP_PRED_SObjectPredicateIntf>{
				new XAP_PRED_SObjectFieldTargetFieldIsTrue(BooleanField),
				new XAP_PRED_SObjectFieldHasChanged(BooleanField, this.oldSObjectByIdMap)
		});
	}

	public List<SObject> collectListForNewlyHavingValue(SObjectField targetField, Object targetValue) {
		return this.listExtractor.extractWhereAllPredicatesTrue(this.newSObjectList, new List<XAP_PRED_SObjectPredicateIntf>{
				new XAP_PRED_SObjectFieldHasTargetValue(targetField, targetValue),
				new XAP_PRED_SObjectFieldHasChanged(targetField, this.oldSObjectByIdMap)
		});
	}	
	public List<SObject> collectNewBlanksFor(SObjectField sObjectField) {
		return (this.isInsert)
				? this.newSObjectList
				: this.listExtractor.extractWhereBlank(this.newSObjectList, sObjectField);
	}



	public Set<Id> collectNonNullIdSetForNew(SObjectField targetField) {
		return this.setExtractor.extractNonNullIdsFrom(this.newSObjectList, targetField);
	}

	public Set<String> collectNonBlankStringSetForNew(SObjectField targetField) {
		return this.setExtractor.extractNonBlankStringsFrom(this.newSObjectList, targetField);
	}

}
