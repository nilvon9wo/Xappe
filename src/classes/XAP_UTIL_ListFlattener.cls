public virtual class XAP_UTIL_ListFlattener {
    private static XAP_UTIL_ListFlattener instance;
    protected XAP_UTIL_ListFlattener() {
    }

    public static XAP_UTIL_ListFlattener getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_ListFlattener();
        }
        return instance;
    }

	public virtual List<SObject> flattenListOfLists(List<List<SObject>> listToFlatten) {
		List<SObject> flattenedList = new List<SObject>();
		for(List<SObject> singleList : listToFlatten) {
			flattenedList.addAll(singleList);
		}
		return flattenedList;
	}
}