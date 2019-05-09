/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_SObjectSelector.cls
 */
public abstract with sharing class XAP_DAO_SOQL_SObjectSelectorAbs implements XAP_DAO_SOQL_SObjectSelectorIntf {
    public static final Boolean INCLUDE_FIELDSET_FIELDS = true;
    public static final Boolean EXCLUDE_FIELDSET_FIELDS = false;

    public static final Boolean INCLUDE_ENFORCE_CRUD = true;
    public static final Boolean EXCLUDE_ENFORCE_CRUD = false;

    public static final Boolean INCLUDE_ENFORCE_FLS = true;
    public static final Boolean EXCLUDE_ENFORCE_FLS = false;

    public static final Boolean SORTTED_SELECT_FIELDS = true;
    public static final Boolean UNSORTTED_SELECT_FIELDS = false;

    public static final Boolean INCLUDE_SELECTOR_FIELDS = true;
    public static final Boolean EXCLUDE_SELECTOR_FIELDS = false;

    private static final String CURRENCY_CODE_FIELDNAME = 'CurrencyIsoCode';
    private static final String DEFAULT_ORDER_FIELDNAME = 'CreatedDate';
    private static final String DEFAULT_SORT_DIRECTION = 'DESC';
    private static final String DEFAULT_NULL_SORT_PLACE = 'NULLS LAST';

    private String orderBy;

    private Boolean isIncludingFieldSetFields;
    private Boolean isEnforcingFLS;
    private Boolean isEnforcingCRUD;
    private Boolean isSortingSelectedFields;

    public XAP_DAO_SOQL_SObjectSelectorAbs(
            Boolean includeFieldSetFields,
            Boolean enforceCRUD,
            Boolean enforceFLS,
            Boolean sortSelectFields
    ) {
        this.isIncludingFieldSetFields = includeFieldSetFields;
        this.isEnforcingCRUD = enforceCRUD;
        this.isEnforcingFLS = enforceFLS;
        this.isSortingSelectedFields = sortSelectFields;
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS) {
        this(includeFieldSetFields, enforceCRUD, enforceFLS, SORTTED_SELECT_FIELDS);
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs(Boolean includeFieldSetFields) {
        this(includeFieldSetFields, INCLUDE_ENFORCE_CRUD, EXCLUDE_ENFORCE_FLS);
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs() {
        this(EXCLUDE_FIELDSET_FIELDS);
    }

    private Boolean isCurrencyIsoCodeEnabled {
        get {
            if (this.isCurrencyIsoCodeEnabled == null) {
                this.isCurrencyIsoCodeEnabled = this.describeWrapper.getFieldsMap()
                        .keySet()
                        .contains(CURRENCY_CODE_FIELDNAME.toLowerCase());
            }
            return this.isCurrencyIsoCodeEnabled;
        }
        set;
    }

    private XAP_DESC_SObjectDescribe describeWrapper {
        get {
            if (this.describeWrapper == null) {
                this.describeWrapper = XAP_DESC_SObjectDescribe.getDescribe(this.getSObjectType());
            }
            return this.describeWrapper;
        }
        set;
    }

    abstract SObjectType getSObjectType();
    abstract List<Schema.SObjectField> getSObjectFieldList();

    public virtual List<FieldSet> getSObjectFieldSetList() {
        return null;
    }

    public virtual String getOrderBy() {
        if (String.isBlank(this.orderBy)) {
            this.orderBy = DEFAULT_ORDER_FIELDNAME;
            if (this.describeWrapper.getNameField() != null) {
                this.orderBy = this.describeWrapper.getNameField()
                        .getDescribe()
                        .getName();
            }
        }
        return this.orderBy;
    }

    public Boolean isIncludeFieldSetFields() {
        return this.isIncludingFieldSetFields;
    }

    public Boolean isEnforcingFLS() {
        return this.isEnforcingFLS;
    }

    public Boolean isEnforcingCRUD() {
        return this.isEnforcingCRUD;
    }

    public String getSObjectName() {
        return this.describeWrapper.getDescribe().getName();
    }

    public virtual List<SObject> selectById(Set<Id> idSet) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }

    public Database.QueryLocator getQueryLocatorById(Set<Id> idSet) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .getQueryLocator();
    }

    public XAP_DAO_SOQL_QueryFactory createQueryFactory() {
        return this.createQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, INCLUDE_SELECTOR_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory createQueryFactory(Boolean includeSelectorFields) {
        return this.createQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, includeSelectorFields);
    }

    public XAP_DAO_SOQL_QueryFactory createQueryFactory(Boolean assertCRUD, Boolean enforceFLS, Boolean includeSelectorFields) {
        return this.configureQueryFactory(
                new XAP_DAO_SOQL_QueryFactory(this.getSObjectType()),
                assertCRUD,
                enforceFLS,
                includeSelectorFields
        );
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs injectChildToSelectParentFields(
            XAP_DAO_SOQL_QueryFactory childQueryFactory,
            String relationshipFieldPath
    ) {
        for (SObjectField field : this.getSObjectFieldList()) {
            childQueryFactory.addField(relationshipFieldPath + '.' + field.getDescribe().getName());
        }

        if (UserInfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
            childQueryFactory.addField(relationshipFieldPath + '.' + CURRENCY_CODE_FIELDNAME);
        }
        return this;
    }

    public XAP_DAO_SOQL_QueryFactory injectParentToSelectChildFields(XAP_DAO_SOQL_QueryFactory parentQueryFactory) {
        return this.injectParentToSelectChildFields(parentQueryFactory, INCLUDE_SELECTOR_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory injectParentToSelectChildFields(
            XAP_DAO_SOQL_QueryFactory parentQueryFactory,
            Boolean includeSelectorFields
    ) {
        return this.configureQueryFactory(
                parentQueryFactory.subselectQuery(getSObjectType()),
                isEnforcingCRUD,
                isEnforcingFLS,
                includeSelectorFields
        );
    }

    public XAP_DAO_SOQL_QueryFactory injectParentToSelectChildFields(
            XAP_DAO_SOQL_QueryFactory parentQueryFactory,
            String relationshipName
    ) {
        return this.injectParentToSelectChildFields(parentQueryFactory, relationshipName, INCLUDE_SELECTOR_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory injectParentToSelectChildFields(
            XAP_DAO_SOQL_QueryFactory parentQueryFactory,
            String relationshipName,
            Boolean includeSelectorFields
    ) {
        XAP_DAO_SOQL_QueryFactory subSelectQueryFactory = parentQueryFactory.subselectQuery(relationshipName);
        return this.configureQueryFactory(subSelectQueryFactory, isEnforcingCRUD, isEnforcingFLS, includeSelectorFields);
    }

    private String buildQuerySObjectById(Set<Id> idSet) {
        return this.createQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .toSoql();
    }

    private XAP_DAO_SOQL_QueryFactory configureQueryFactory(
            XAP_DAO_SOQL_QueryFactory queryFactory,
            Boolean assertCRUD,
            Boolean enforceFLS,
            Boolean includeSelectorFields
    ) {
        this.requireCrudSecurity(queryFactory, assertCRUD);
        queryFactory.setEnforceFLS(enforceFLS);

        this.configureSelectorFields(queryFactory, includeSelectorFields);
        this.parseOrderBy(queryFactory);
        queryFactory.setSortSelectFields(this.isSortingSelectedFields);

        return queryFactory;
    }

    private XAP_DAO_SOQL_QueryFactory requireCrudSecurity(XAP_DAO_SOQL_QueryFactory queryFactory, Boolean assertCRUD) {
        if (assertCRUD) {
            try {
                queryFactory.assertIsAccessible();
            } catch (XAP_DAO_SOQL_SObjectReadException ex) {
                throw new XAP_DAO_SOQL_DomainSecurityException(ex, this.getSObjectType());
            }
        }
        return queryFactory;
    }

    private XAP_DAO_SOQL_QueryFactory configureSelectorFields(
            XAP_DAO_SOQL_QueryFactory queryFactory,
            Boolean includeSelectorFields
    ) {
        if (includeSelectorFields) {
            queryFactory.addFields(this.getSObjectFieldList());

            List<FieldSet> fieldSetList = this.getSObjectFieldSetList();
            if (this.isIncludingFieldSetFields && fieldSetList != null) {
                for (FieldSet fieldSet : fieldSetList) {
                    queryFactory.addFields(fieldSet);
                }
            }

            if (UserInfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
                queryFactory.addField(CURRENCY_CODE_FIELDNAME);
            }
        }
        return queryFactory;
    }

    private XAP_DAO_SOQL_QueryFactory parseOrderBy(XAP_DAO_SOQL_QueryFactory queryFactory) {
        for (String orderBy : this.getOrderBy().split(',')) {
            List<String> orderByPartList = orderBy.trim()
                    .split(' ');

            String fieldNamePart = orderByPartList[0];
            String fieldSortOrderPart = orderByPartList.size() > 1
                    ? orderByPartList[1]
                    : null;

            XAP_DAO_SOQL_QuerySortOrderEnum fieldSortOrder = (
                    !String.isBlank(fieldSortOrderPart)
                            && fieldSortOrderPart.equalsIgnoreCase(DEFAULT_SORT_DIRECTION)
            )
                    ? XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING
                    : XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING;

            queryFactory.addOrdering(fieldNamePart, fieldSortOrder, orderBy.containsIgnoreCase(DEFAULT_NULL_SORT_PLACE));
        }
        return queryFactory;
    }
}