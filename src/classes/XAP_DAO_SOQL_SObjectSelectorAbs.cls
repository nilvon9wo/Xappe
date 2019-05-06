public abstract class XAP_DAO_SOQL_SObjectSelectorAbs implements XAP_DAO_SOQL_SObjectSelectorIntf {
    public static final Boolean INCLUDE_SELECTOR_FIELDS = true;
    public static final Boolean EXCLUDE_SELECTOR_FIELDS = false;

    public static final Boolean INCLUDE_FIELDSET_FIELDS = true;
    public static final Boolean EXCLUDE_FIELDSET_FIELDS = false;

    public static final Boolean INCLUDE_ENFORCE_CRUD = true;
    public static final Boolean EXCLUDE_ENFORCE_CRUD = false;

    public static final Boolean INCLUDE_ENFORCE_FLS = true;
    public static final Boolean EXCLUDE_ENFORCE_FLS = false;

    public static final Boolean SORTTED_SELECT_FIELDS = true;
    public static final Boolean UNSORTTED_SELECT_FIELDS = false;


    private static final Boolean DEFAULT_INCLUDE_FIELDSET_FIELDS = EXCLUDE_FIELDSET_FIELDS;
    private static final Boolean DEFAULT_INCLUDE_SELECTOR_FIELDS = INCLUDE_SELECTOR_FIELDS;
    private static final Boolean DEFAULT_ENFORCE_CRUD = INCLUDE_ENFORCE_CRUD;
    private static final Boolean DEFAULT_ENFORCE_FLS = EXCLUDE_ENFORCE_FLS;
    private static final Boolean DEFAULT_SORT_SELECT_FIELDS = SORTTED_SELECT_FIELDS;
    private static final String CURRENCY_ISO_FIELDNAME = 'CurrencyIsoCode';

    public XAP_DAO_SOQL_SObjectSelectorAbs(
            Boolean includeFieldSetFields,
            Boolean enforceCRUD,
            Boolean enforceFLS,
            Boolean sortSelectFields
    ) {
        this.isIncludingFieldSetFields = includeFieldSetFields;
        this.isEnforcingCRUD = enforceCRUD;
        this.isEnforcingFLS = enforceFLS;
        this.isSortingSelectFields = sortSelectFields;
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS) {
        this(includeFieldSetFields, enforceCRUD, enforceFLS, DEFAULT_SORT_SELECT_FIELDS);
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs(Boolean includeFieldSetFields) {
        this(includeFieldSetFields, DEFAULT_ENFORCE_CRUD, DEFAULT_ENFORCE_FLS);
    }

    public XAP_DAO_SOQL_SObjectSelectorAbs() {
        this(DEFAULT_INCLUDE_FIELDSET_FIELDS);
    }

    private Boolean isCurrencyIsoCodeEnabled {
        get {
            if (this.isCurrencyIsoCodeEnabled == null) {
                this.isCurrencyIsoCodeEnabled = this.describeWrapper
                        .getFieldsMap()
                        .keySet()
                        .contains(CURRENCY_ISO_FIELDNAME.toLowerCase());
            }
            return this.isCurrencyIsoCodeEnabled;
        }
        set;
    }

    private Boolean isEnforcingCRUD;
    private Boolean isEnforcingFLS;
    private Boolean isIncludingFieldSetFields;
    private Boolean isSortingSelectFields;
    private String orderBy;

    private XAP_DESC_SObjectDescribe describeWrapper {
        get {
            if (this.describeWrapper == null) {
                this.describeWrapper = XAP_DESC_SObjectDescribe.getDescribe(this.getSObjectType());
            }
            return this.describeWrapper;
        }
        set;
    }

    public abstract Schema.SObjectType getSObjectType();
    private abstract List<Schema.SObjectField> getSObjectFieldList();

    public virtual List<Schema.FieldSet> getSObjectFieldSetList() {
        return null;
    }

    public virtual String getOrderBy() {
        if (this.orderBy == null) {
            this.orderBy = 'CreatedDate';
            if (this.describeWrapper.getNameField() != null) {
                this.orderBy = this.describeWrapper.getNameField().getDescribe().getName();
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
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }

    public Database.QueryLocator getQueryLocatorById(Set<Id> idSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .getQueryLocator();
    }

    public XAP_DAO_SOQL_QueryFactory newQueryFactory() {
        return this.newQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, DEFAULT_INCLUDE_SELECTOR_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory newQueryFactory(Boolean includeSelectorFields) {
        return this.newQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, includeSelectorFields);
    }

    public XAP_DAO_SOQL_QueryFactory newQueryFactory(
            Boolean assertCRUD,
            Boolean enforceFLS,
            Boolean includeSelectorFields
    ) {
        return this.configureQueryFactory(
                new XAP_DAO_SOQL_QueryFactory(this.getSObjectType()),
                assertCRUD,
                enforceFLS,
                includeSelectorFields
        );
    }

    public void configureQueryFactoryFields(XAP_DAO_SOQL_QueryFactory queryFactory, String relationshipFieldPath) {
        for (SObjectField field : this.getSObjectFieldList()) {
            queryFactory.selectField(relationshipFieldPath + '.' + field.getDescribe().getName());
        }

        if (UserInfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
            queryFactory.selectField(relationshipFieldPath + '.' + CURRENCY_ISO_FIELDNAME);
        }
    }

    public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(XAP_DAO_SOQL_QueryFactory parentQueryFactory) {
        return this.addQueryFactorySubselect(parentQueryFactory, DEFAULT_INCLUDE_SELECTOR_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(
            XAP_DAO_SOQL_QueryFactory parentQueryFactory,
            Boolean includeSelectorFields
    ) {
        return this.configureQueryFactory(
                parentQueryFactory.subSelectQuery(getSObjectType()),
                this.isEnforcingCRUD,
                this.isEnforcingFLS,
                includeSelectorFields
        );
    }

    public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(
            XAP_DAO_SOQL_QueryFactory parentQueryFactory,
            String relationshipName
    ) {
        return this.addQueryFactorySubselect(parentQueryFactory, relationshipName, DEFAULT_INCLUDE_SELECTOR_FIELDS);
    }

    public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(
            XAP_DAO_SOQL_QueryFactory parentQueryFactory,
            String relationshipName,
            Boolean includeSelectorFields
    ) {
        return this.configureQueryFactory(
                parentQueryFactory.subSelectQuery(relationshipName),
                this.isEnforcingCRUD,
                this.isEnforcingFLS,
                includeSelectorFields
        );
    }

    private String buildQuerySObjectById(Set<Id> idSet) {
        return this.newQueryFactory()
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
        queryFactory.setSortSelectFields(this.isSortingSelectFields);

        return queryFactory;
    }

    private XAP_DAO_SOQL_QueryFactory requireCrudSecurity(XAP_DAO_SOQL_QueryFactory queryFactory, Boolean assertCRUD) {
        if (assertCRUD) {
            try {
                queryFactory.assertIsAccessible();
            } catch (XAP_DAO_SOQL_SObjectReadException ex) {
                throw new XAP_DAO_SOQL_DomainSecurityException(
                        'Permission to access an ' + this.getSObjectType().getDescribe().getName() + ' denied.', ex
                );
            }
        }
        return queryFactory;
    }

    private XAP_DAO_SOQL_QueryFactory configureSelectorFields(
            XAP_DAO_SOQL_QueryFactory queryFactory,
            Boolean includeSelectorFields
    ) {
        if (includeSelectorFields) {
            queryFactory.selectFields(this.getSObjectFieldList());

            List<Schema.FieldSet> fieldSetList = this.getSObjectFieldSetList();
            if (this.isIncludingFieldSetFields && fieldSetList != null) {
                for (Schema.FieldSet fieldSet : fieldSetList) {
                    queryFactory.selectFields(fieldSet);
                }
            }

            if (UserInfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
                queryFactory.selectField(CURRENCY_ISO_FIELDNAME);
            }
        }
        return queryFactory;
    }

    private XAP_DAO_SOQL_QueryFactory parseOrderBy(XAP_DAO_SOQL_QueryFactory queryFactory) {
        for (String orderBy : this.getOrderBy().split(',')) {
            List<String> orderByPartList = orderBy.trim().split(' ');

            String fieldNamePart = orderByPartList[0];
            String fieldSortOrderPart = orderByPartList.size() > 1 ? orderByPartList[1] : null;
            XAP_DAO_SOQL_QuerySortOrderEnum fieldSortOrder = XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING;

            fieldSortOrder = (!String.isBlank(fieldSortOrderPart) && fieldSortOrderPart.equalsIgnoreCase('DESC'))
                    ? XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING
                    : XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING;

            queryFactory.addOrdering(fieldNamePart, fieldSortOrder, orderBy.containsIgnoreCase('NULLS LAST'));
        }
        return queryFactory;
    }
}