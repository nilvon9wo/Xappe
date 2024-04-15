public virtual with sharing class DAO_AccountSelector extends XAP_DAO_SOQL_SObjectSelectorAbs
        implements XAP_DAO_SOSL_SObjectFieldsProviderIntf {
    private final XAP_DAO_SOQL_AggregateResultMapConverter mapConverter;

    private DAO_AccountSelector(XAP_DAO_SOQL_AggregateResultMapConverter mapConverter) {
        this.mapConverter = mapConverter;
    }

    private DAO_AccountSelector() {
        this(XAP_DAO_SOQL_AggregateResultMapConverter.getInstance());
    }

    private static DAO_AccountSelector INSTANCE;
    public static DAO_AccountSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAO_AccountSelector();
        }
        return INSTANCE;
    }

    public SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Account.AnnualRevenue,
                Account.CreatedDate,
                Account.Industry,
                Account.Name,
                Account.Phone,
                Account.Type
        };
    }

    public List<Account> selectAll() {
        return this.createQueryFactory()
                .addOrdering(Account.Name, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
                .setSecurityEnforced()
                .query();
    }

    //noinspection ApexUnusedDeclaration
    public Integer getCount() {
        return [
                SELECT COUNT()
                FROM Account
        ];
    }

    //noinspection ApexUnusedDeclaration
    public Map<String, Integer> getIndustryCounts() {
        List<AggregateResult> results = [
                SELECT Industry, COUNT(Id) total
                FROM Account
                GROUP BY Industry
        ];
        return this.mapConverter.convertToIntegerByString(results, Account.Industry, 'total');
    }
}