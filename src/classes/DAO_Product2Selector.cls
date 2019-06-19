public virtual class DAO_Product2Selector extends XAP_DAO_SOQL_SObjectSelectorAbs {
	public DAO_Product2Selector(Boolean includeFieldSetFields) {
		super(includeFieldSetFields);
	}

	public DAO_Product2Selector() {
		super(XAP_DAO_SOQL_SObjectSelectorAbs.INCLUDE_FIELDSET_FIELDS);
	}

	public static DAO_Product2Selector getInstance() {
		return new DAO_Product2Selector();
	}

	public SObjectType getSObjectType() {
		return Product2.SObjectType;
	}

	public override List<FieldSet> getSObjectFieldSetList() {
		return new List<FieldSet>{
				SObjectType.Product2.fieldSets.getMap()
						.get('example_field_set')
		};
	}

	private List<SObjectField> getSObjectFieldList() {
		return new List<SObjectField>{
				Product2.Description,
				Product2.Id,
				Product2.IsActive,
				Product2.Name,
				Product2.ProductCode
		};
	}

	public List<Product2> selectById(Set<Id> idSet, FieldSet fieldSet) {
		return this.createQueryFactory()
				.addFields(fieldSet)
				.setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
				.query();
	}

	public List<Product2> selectRecentlyUpdated(Integer recordLimit) {
		return this.createQueryFactory()
				.setCondition(new XAP_DAO_SOQL_WHERE_StringCompareClause(
						Product2.SystemModstamp,
						XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS,
						'LAST_N_DAYS:30'
				))
				.setLimit(recordLimit)
				.query();
	}
}