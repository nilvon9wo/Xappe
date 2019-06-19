public class XAP_DAO_SOQL_OrderingCollection {
	SObjectType sObjectType;
	XAP_DAO_SOQL_SObjectFieldHelper fieldHelper;
	XAP_DAO_SOQL_SecurityUtils securityUtils;

	private XAP_DAO_SOQL_OrderingCollection(
			SObjectType sObjectType,
			XAP_DAO_SOQL_SObjectFieldHelper fieldHelper,
			XAP_DAO_SOQL_SecurityUtils securityUtils
	) {
		this.sObjectType = sObjectType;
		this.fieldHelper = fieldHelper;
		this.securityUtils = securityUtils;
	}

	public XAP_DAO_SOQL_OrderingCollection(SObjectType sObjectType) {
		this(sObjectType, XAP_DAO_SOQL_SObjectFieldHelper.getInstance(), XAP_DAO_SOQL_SecurityUtils.getInstance());
	}
	private List<XAP_DAO_SOQL_QuerySortOrdering> orderingList {
		get {
			if (this.orderingList == null) {
				this.orderingList = new List<XAP_DAO_SOQL_QuerySortOrdering>();
			}
			return this.orderingList;
		}
		private set;
	}

	public XAP_DAO_SOQL_OrderingCollection add(XAP_DAO_SOQL_QuerySortOrdering ordering) {
		this.orderingList.add(ordering);
		return this;
	}

	public XAP_DAO_SOQL_OrderingCollection add(
			String fieldName,
			XAP_DAO_SOQL_QuerySortOrderEnum direction,
			Boolean nullsLast,
			Boolean enforceFLS
	) {
		this.orderingList.add(
				new XAP_DAO_SOQL_QuerySortOrdering(
						this.fieldHelper.getFieldPath(this.sObjectType, fieldName, enforceFLS),
						direction,
						nullsLast
				)
		);
		return this;
	}

	public XAP_DAO_SOQL_OrderingCollection add(
			SObjectField field,
			XAP_DAO_SOQL_QuerySortOrderEnum direction,
			Boolean nullsLast
	) {
		this.orderingList.add(
				new XAP_DAO_SOQL_QuerySortOrdering(
						this.fieldHelper.getFieldTokenPath(field),
						direction,
						nullsLast
				)
		);
		return this;
	}

	public XAP_DAO_SOQL_OrderingCollection add(
			String fieldName,
			XAP_DAO_SOQL_QuerySortOrderEnum direction,
			Boolean enforceFLS
	) {
		this.orderingList.add(
				new XAP_DAO_SOQL_QuerySortOrdering(
						this.fieldHelper.getFieldPath(this.sObjectType, fieldName, enforceFLS),
						direction
				)
		);
		return this;
	}

	public XAP_DAO_SOQL_OrderingCollection add(
			SObjectField field,
			XAP_DAO_SOQL_QuerySortOrderEnum direction
	) {
		this.orderingList.add(
				new XAP_DAO_SOQL_QuerySortOrdering(this.fieldHelper.getFieldTokenPath(field), direction)
		);
		return this;
	}

	public XAP_DAO_SOQL_OrderingCollection set(XAP_DAO_SOQL_QuerySortOrdering ordering) {
		return this.set(new List<XAP_DAO_SOQL_QuerySortOrdering>{ordering});
	}

	public XAP_DAO_SOQL_OrderingCollection set(
			String fieldName,
			XAP_DAO_SOQL_QuerySortOrderEnum direction,
			Boolean nullsLast,
			Boolean enforceFLS
	) {
		return this.set(new XAP_DAO_SOQL_QuerySortOrdering(
				this.fieldHelper.getFieldPath(this.sObjectType, fieldName, enforceFLS),
				direction,
				nullsLast
		));
	}

	public XAP_DAO_SOQL_OrderingCollection set(
			SObjectField field,
			XAP_DAO_SOQL_QuerySortOrderEnum direction,
			Boolean nullsLast
	) {
		return this.set(new XAP_DAO_SOQL_QuerySortOrdering(
				this.fieldHelper.getFieldTokenPath(field),
				direction,
				nullsLast
		));
	}

	public XAP_DAO_SOQL_OrderingCollection set(
			String fieldName,
			XAP_DAO_SOQL_QuerySortOrderEnum direction,
			Boolean enforceFLS
	) {
		return set(new XAP_DAO_SOQL_QuerySortOrdering(
				this.fieldHelper.getFieldPath(this.sObjectType, fieldName, enforceFLS),
				direction
		));
	}

	public XAP_DAO_SOQL_OrderingCollection set(SObjectField field, XAP_DAO_SOQL_QuerySortOrderEnum direction) {
		return set(new XAP_DAO_SOQL_QuerySortOrdering(
				this.fieldHelper.getFieldTokenPath(field),
				direction
		));
	}

	public XAP_DAO_SOQL_OrderingCollection set(List<XAP_DAO_SOQL_QuerySortOrdering> orderingList) {
		this.orderingList = orderingList;
		return this;
	}

	public Boolean isEmpty() {
		return this.orderingList.isEmpty();
	}

	public Boolean isNotEmpty() {
		return !this.isEmpty();
	}

	public List<XAP_DAO_SOQL_QuerySortOrdering> toList() {
		return this.orderingList;
	}
}