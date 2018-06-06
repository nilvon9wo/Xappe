public virtual class XAP_UTIL_ListExtractor {
	private static XAP_UTIL_ListExtractor INSTANCE;
	protected XAP_UTIL_ListExtractor() {
	}
	
	public static XAP_UTIL_ListExtractor getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_UTIL_ListExtractor();
		}
		return INSTANCE;
	}
	
	// Extract true for predicate collection ----------------------------------------------------------------------
	
    public virtual List<SObject> extractWhereAllPredicatesTrue(List<SObject> sObjectList, List<XAP_FUNC_PredicateIntf> predicateList) {
    	return (new AllPredicateListExtractor(predicateList)).extractFrom(sObjectList); 
    }
	
	@testVisible
	private class AllPredicateListExtractor extends ListExtractor { 
		List<XAP_FUNC_PredicateIntf> predicateList;
		
		AllPredicateListExtractor(List<XAP_FUNC_PredicateIntf> predicateList) {
			this.predicateList = predicateList;
		} 
		
		override Boolean isTrueFor(SObject sObj) {
			for(XAP_FUNC_PredicateIntf predicate : predicateList) {
				if (!predicate.isTrue(sObj)) {
					return false;
				}
			}
			return true;
		}
	} 
	
	
	// Extract where true  -----------------------------------------------------------------------------------------

    public virtual List<SObject> extractWhereTrueFrom(List<SObject> sObjectList, SObjectField booleanField) {
    	return (new IsTrueListExtractor(booleanField)).extractFrom(sObjectList); 
    }

	@testVisible
	private class IsTrueListExtractor extends ListExtractor { 
		SObjectField sObjectField;
		
		IsTrueListExtractor(SObjectField sObjectField) {
			this.sObjectField = sObjectField;
		} 
		
		override Boolean isTrueFor(SObject sObj) {
			return (Boolean) sObj.get(this.sObjectField);
		}
	} 

	// Extract where changed to true  -----------------------------------------------------------------------------------------

    public virtual List<SObject> extractWhereChangedToTrueFrom(
    		List<SObject> newSObjectList, 
    		Map<Id, SObject> oldSObjectByIdMap, 
    		SObjectField booleanField
    	) {
    	return (new IsChangedToTrueListExtractor(oldSObjectByIdMap, booleanField)).extractFrom(newSObjectList); 
    }

	@testVisible
	private class IsChangedToTrueListExtractor extends ListExtractor { 
		Map<Id, SObject> oldSObjectByIdMap;
		SObjectField sObjectField;
		
		IsChangedToTrueListExtractor(Map<Id, SObject> oldSObjectByIdMap, SObjectField sObjectField) {
			this.oldSObjectByIdMap = oldSObjectByIdMap;
			this.sObjectField = sObjectField;
		} 
		
		override Boolean isTrueFor(SObject newSObject) {
			SObject oldSObject = (this.oldSObjectByIdMap != null)
				 ? this.oldSObjectByIdMap.get(newSObject.id)
				 : null;
				 
			Boolean hasNoOld = oldSObject == null;
			return hasNoOld || this.isChangedToTrue(newSObject, oldSObject);
		}
		
		@testVisible
		private Boolean isChangedToTrue(SObject newSObject, SObject oldSObject) {
			return (Boolean) newSObject.get(this.sObjectField)
				&& (!(Boolean) oldSObject.get(this.sObjectField)); 
		}
	} 

	// Extract where not null  -----------------------------------------------------------------------------------------

    public virtual List<SObject> extractWhereNotNullFrom(List<SObject> sObjectList, SObjectField sObjectField) {
    	return (new IsNotNullListExtractor(sObjectField)).extractFrom(sObjectList); 
    }
    
	@testVisible
	private class IsNotNullListExtractor extends ListExtractor { 
		SObjectField sObjectField;
		
		IsNotNullListExtractor(SObjectField sObjectField) {
			this.sObjectField = sObjectField;
		}

		override Boolean isTrueFor(SObject sObj) {
			return (sObj.get(sObjectField) != null);
		}
	} 

	// Extract where null  -----------------------------------------------------------------------------------------

    public virtual List<SObject> extractWhereNullFrom(List<SObject> sObjectList, SObjectField sObjectField) {
    	return (new IsNullListExtractor(sObjectField)).extractFrom(sObjectList); 
    }
    
	@testVisible
	private class IsNullListExtractor extends ListExtractor { 
		SObjectField sObjectField;
		
		IsNullListExtractor(SObjectField sObjectField) {
			this.sObjectField = sObjectField;
		}

		override Boolean isTrueFor(SObject sObj) {
			return (sObj.get(sObjectField) == null);
		}
	} 

	// Extract by Id  -----------------------------------------------------------------------------------------

    public virtual List<SObject> extractByIdFrom(List<SObject> sObjectList, SObjectField sObjectField, Id id) {
    	return (new ForIdListExtractor(sObjectField, id)).extractFrom(sObjectList); 
    }
    
	@testVisible
	private class ForIdListExtractor extends ListExtractor { 
		SObjectField sObjectField;
		Id id;
		
		ForIdListExtractor(SObjectField sObjectField, Id id) {
			this.sObjectField = sObjectField;
			this.id = id;
		}

		override Boolean isTrueFor(SObject sObj) {
			return ((Id) sObj.get(sObjectField) == this.id);
		}
	} 

	// Abstract -----------------------------------------------------------------------------------------

    abstract private class ListExtractor {
    	public List<SObject> extractFrom(List<SObject> sObjectList) {
	    	List<SObject> resultList = new List<SObject>();
	    	for (SObject sObj : sObjectList) {
	    		if (this.isTrueFor(sObj)) {
	    			resultList.add(sObj);
	    		}
	    	}
	    	return resultList; 
    	} 
    	
    	abstract Boolean isTrueFor(SObject sObj);
    }
}