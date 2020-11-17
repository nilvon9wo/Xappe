public class XAP_TRG_TriggerContext {
	@TestVisible public Boolean isBefore { get; private set; }
	@TestVisible public Boolean isAfter { get; private set; }
	@TestVisible public Boolean isInsert { get; private set; }
	@TestVisible public Boolean isUpdate { get; private set; }
	@TestVisible public Boolean isDelete { get; private set; }
	@TestVisible public Boolean isUndelete { get; private set; }
	@TestVisible public Boolean isExecuting { get; private set; }

	@TestVisible public List<SObject> oldSObjectList { get; private set; }
	@TestVisible public List<SObject> newSObjectList { get; private set; }
	@TestVisible public Map<Id, SObject> oldSObjectByIdMap { get; private set; }
	@TestVisible public Map<Id, SObject> newSObjectByIdMap { get; private set; }

	@TestVisible public TriggerOperation operationType { get; private set; }
	@TestVisible public Integer size { get; private set; }

	@TestVisible public SObjectType sObjectType {
		get {
			if (this.sObjectType == null) {
				this.sObjectType = this.selectSObjectType();
			}
			return this.sObjectType;
		}
		private set;
	}

	public XAP_TRG_TriggerContext() {
		this.isInsert = Trigger.isInsert;
		this.isUpdate = Trigger.isUpdate;
		this.isDelete = Trigger.isDelete;
		this.isUndelete = Trigger.isUndelete;
		this.isBefore = Trigger.isBefore;
		this.isAfter = Trigger.isAfter;
		this.isExecuting = Trigger.isExecuting;

		this.newSObjectList = Trigger.new;
		this.oldSObjectList = Trigger.old;
		this.newSObjectByIdMap = Trigger.newMap;
		this.oldSObjectByIdMap = Trigger.oldMap;

		this.operationType = Trigger.operationType;
		this.size = Trigger.size;
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

	private Map<Object, Object> valueByKeyMap = new Map<Object, Object>();

	public Object get(Object key) {
		return this.valueByKeyMap.get(key);
	}

	private XAP_TRG_TriggerContext set(Object key, Object value) {
		if (!this.valueByKeyMap.containsKey(key)) {
			this.valueByKeyMap.put(key, value);
		}
		else {
			throw new XAP_TRG_TriggerException('Trigger Context keys can not be reassigned,');
		}
		return this;
	}
}
