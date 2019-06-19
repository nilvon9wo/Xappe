public class XAP_UTIL_ListComparison {
	private List<Object> haystackList;
	private List<Object> needleList;

	public XAP_UTIL_ListComparison(List<Object> haystackList, List<Object> needleList) {
		this.haystackList = (haystackList != null) ? haystackList.clone() : null;
		this.needleList = (needleList != null) ? needleList.clone() : null;
	}

	private static Integer NOT_IN_LIST = -1;

	public Boolean hasSameStart {
		get {
			if (this.hasSameStart == null) {
				this.hasSameStart = this.haystackList == null && this.needleList == null
						|| this.haystackList.isEmpty() && this.needleList.isEmpty()
						|| this.haystackList[0] == this.needleList[0];
			}
			return this.hasSameStart;
		}
		private set;
	}

	public Boolean hasSameEnd {
		get {
			if (this.hasSameEnd == null) {
				this.hasSameEnd = this.haystackList == null && this.needleList == null
						|| this.haystackList.isEmpty() && this.needleList.isEmpty()
						|| this.haystackList[haystackList.size() - 1] == this.needleList[needleList.size() - 1];
			}
			return this.hasSameEnd;
		}
		private set;
	}

	public Boolean isSameSize {
		get {
			if (this.isSameSize == null) {
				Integer needleListSize = (this.needleList != null) ? this.needleList.size() : 0;
				Integer haystackListSize = (this.haystackList != null) ? this.haystackList.size() : 0;

				this.isSameSize = needleListSize == haystackListSize;
			}
			return this.isSameSize;
		}
		private set;
	}

	// Npte: This property is not suitable for comparing quantities of duplicated items;
	public Boolean hasAllMembers {
		get {
			if (this.hasAllMembers == null) {
				this.hasAllMembers = this.determineHasAllMembers();
			}
			return this.hasAllMembers;
		}
		private set;
	}

	private Boolean determineHasAllMembers() {
		if (this.needleList != null) {
			for (Object needle : this.needleList) {
				if (this.indexInHayStackListkByObjectInNeedleListMap.get(needle) == null) {
					return false;
				}
			}
		}
		return true;
	}

	// Npte: This property is not suitable for comparing lists where the members are not unique.
	public Boolean hasSameOrder {
		get {
			if (this.hasSameOrder == null) {
				this.hasSameOrder = this.determineSameOrder();
			}
			return this.hasSameOrder;
		}
		private set;
	}

	private Boolean determineSameOrder() {
		if (!this.hasAllMembers) {
			return false;
		}

		if (this.needleList == null || this.needleList.size() < 2) {
			return true;
		}

		Integer lastHaystackIndex = -1;
		for (Object needle : needleList) {
			Integer haystackIndex = this.indexInHayStackListkByObjectInNeedleListMap.get(needle);
			if (haystackIndex < lastHaystackIndex) {
				return false;
			}
			lastHaystackIndex = haystackIndex;
		}
		return true;
	}

	// Npte: This property is not suitable for comparing lists where the members are not unique.
	public Boolean isContiguous {
		get {
			if (this.isContiguous == null) {
				this.isContiguous = this.determineIsContiguous();
			}
			return this.isContiguous;
		}
		private set;
	}

	private Boolean determineIsContiguous() {
		if (!this.hasSameOrder) {
			return false;
		}

		Integer needleListSize = (this.needleList != null)
				? this.needleList.size()
				: 0;

		if (needleListSize < 2) {
			return true;
		}

		Integer nextExpectedIndex;
		for (Object needle : needleList) {
			Integer haystackIndex = this.indexInHayStackListkByObjectInNeedleListMap.get(needle);

			if (nextExpectedIndex == null) {
				nextExpectedIndex = haystackIndex + 1;
			}
			else {
				if (haystackIndex > nextExpectedIndex) {
					return false;
				}
			}
		}
		return true;
	}

	public Boolean isExactMatch {
		get {
			if (this.isExactMatch == null) {
				this.isExactMatch = this.hasAllMembers
						&& this.isSameSize
						&& this.hasSameStart
						&& this.hasSameEnd
						&& this.isContiguous
						&& this.isSameSize
						&& this.hasSameOrder;
			}
			return this.isExactMatch;
		}
		private set;
	}

	public Boolean isIllMatched {
		get {
			if (this.isIllMatched == null) {
				this.isIllMatched = !this.hasAllMembers;
			}
			return this.isIllMatched;
		}
		private set;
	}

	// Helpers ------------------------------------------------------------------

	private Map<Object, Integer> indexInHayStackListkByObjectInNeedleListMap {
		get {
			if (this.indexInHayStackListkByObjectInNeedleListMap != null) {
				return this.indexInHayStackListkByObjectInNeedleListMap;
			}
			else {
				this.indexInHayStackListkByObjectInNeedleListMap = new Map<Object, Integer>();
				if (this.haystackList != null) {
					for (Integer i = 0; i < this.haystackList.size(); i++) {
						indexInHayStackListkByObjectInNeedleListMap.put(this.haystackList[i], i);
					}
				}
				return this.indexInHayStackListkByObjectInNeedleListMap;
			}
		}
		private set;
	}
}