public abstract with sharing class A00_SObjectSelectorAbs implements A00_SObjectSelectorIntf {
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

    private String orderBy;

    private Boolean isIncludingFieldSetFields;
    private Boolean isEnforcingFLS;
    private Boolean isEnforcingCRUD;
    private Boolean isSortingSelectedFields;

    public A00_SObjectSelectorAbs(
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

    public A00_SObjectSelectorAbs(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS) {
        this(includeFieldSetFields, enforceCRUD, enforceFLS, SORTTED_SELECT_FIELDS);
    }


    public A00_SObjectSelectorAbs(Boolean includeFieldSetFields) {
        this(includeFieldSetFields, INCLUDE_ENFORCE_CRUD, EXCLUDE_ENFORCE_FLS);
    }

    public A00_SObjectSelectorAbs() {
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

    abstract Schema.SObjectType getSObjectType();
    abstract List<Schema.SObjectField> getSObjectFieldList();

    public virtual List<Schema.FieldSet> getSObjectFieldSetList() {
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

    /*
    public virtual List<SObject> selectById(Set<Id> idSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }
     */
    public List<SObject> selectById(Set<Id> idSet) {
        return Database.query(this.buildQuerySObjectById());
    }

    /*
    public Database.QueryLocator getQueryLocatorById(Set<Id> idSet) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .getQueryLocator();
    }
     */
    public Database.QueryLocator queryLocatorById(Set<Id> idSet) {
        return Database.getQueryLocator(this.buildQuerySObjectById());
    }

    public A00_QueryFactory createQueryFactory() {
        return this.createQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, INCLUDE_SELECTOR_FIELDS);
    }

    public A00_QueryFactory createQueryFactory(Boolean includeSelectorFields) {
        return this.createQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, includeSelectorFields);
    }

    public A00_QueryFactory createQueryFactory(Boolean assertCRUD, Boolean enforceFLS, Boolean includeSelectorFields) {
        return this.configureQueryFactory(
                new A00_QueryFactory(getSObjectType()),
                assertCRUD,
                enforceFLS,
                includeSelectorFields
        );
    }

    public void injectChildFactoryFor(A00_QueryFactory queryFactory, String relationshipFieldPath) {
        for (SObjectField field : this.getSObjectFieldList()) {
            queryFactory.addField(relationshipFieldPath + '.' + field.getDescribe().getName());
        }

        if (UserInfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
            queryFactory.addField(relationshipFieldPath + '.' + CURRENCY_CODE_FIELDNAME);
        }
    }

    public A00_QueryFactory injectParentFactoryFor(A00_QueryFactory parentQueryFactory) {
        return this.injectParentFactoryFor(parentQueryFactory, INCLUDE_SELECTOR_FIELDS);
    }

    public A00_QueryFactory injectParentFactoryFor(A00_QueryFactory parentQueryFactory, Boolean includeSelectorFields) {
        return this.configureQueryFactory(
                parentQueryFactory.subselectQuery(getSObjectType()),
                isEnforcingCRUD,
                isEnforcingFLS,
                includeSelectorFields);
    }

    public A00_QueryFactory injectParentFactoryFor(A00_QueryFactory parentQueryFactory, String relationshipName) {
        return this.injectParentFactoryFor(parentQueryFactory, relationshipName, INCLUDE_SELECTOR_FIELDS);
    }

    public A00_QueryFactory injectParentFactoryFor(
            A00_QueryFactory parentQueryFactory,
            String relationshipName,
            Boolean includeSelectorFields
    ) {
        A00_QueryFactory subSelectQueryFactory = parentQueryFactory.subselectQuery(relationshipName);
        return this.configureQueryFactory(subSelectQueryFactory, isEnforcingCRUD, isEnforcingFLS, includeSelectorFields);
    }

    private String buildQuerySObjectById() {
        return this.createQueryFactory()
                .setCondition('id in :idSet')
                .toSOQL();
    }

    private A00_QueryFactory configureQueryFactory(
            A00_QueryFactory queryFactory,
            Boolean assertCRUD,
            Boolean enforceFLS,
            Boolean includeSelectorFields
    ) {
        if (assertCRUD) {
            try {
                queryFactory.assertIsAccessible();
            } catch (A00_SecurityUtils.CrudException e) {
                throw new A00_SObjectDomain.DomainException(
                        'Permission to access an ' + getSObjectType().getDescribe().getName() + ' denied.'
                );
            }
        }
        queryFactory.setEnforceFLS(enforceFLS);

        if (includeSelectorFields) {
            queryFactory.selectFields(this.getSObjectFieldList());

            List<Schema.FieldSet> fieldSetList = this.getSObjectFieldSetList();
            if (this.isIncludingFieldSetFields && fieldSetList != null) {
                for (Schema.FieldSet fieldSet : fieldSetList) {
                    queryFactory.addFields(fieldSet);
                }
            }

            if (UserInfo.isMultiCurrencyOrganization() && isCurrencyIsoCodeEnabled) {
                queryFactory.addField(CURRENCY_CODE_FIELDNAME);
            }
        }

        for (String orderBy : this.getOrderBy().split(',')) {
            List<String> orderByParts = orderBy.trim().split(' ');
            String fieldNamePart = orderByParts[0];
            String fieldSortOrderPart = orderByParts.size() > 1
                    ? orderByParts[1]
                    : null;

            A00_QueryFactory.SortOrder fieldSortOrder = A00_QueryFactory.SortOrder.ASCENDING;
            if (fieldSortOrderPart == null) {
                fieldSortOrder = A00_QueryFactory.SortOrder.ASCENDING;
            } else if (fieldSortOrderPart.equalsIgnoreCase('DESC')) {
                fieldSortOrder = A00_QueryFactory.SortOrder.DESCENDING;
            } else if (fieldSortOrderPart.equalsIgnoreCase('ASC')) {
                fieldSortOrder = A00_QueryFactory.SortOrder.ASCENDING;
            }

            queryFactory.addOrdering(fieldNamePart, fieldSortOrder, orderBy.containsIgnoreCase('NULLS LAST'));
        }

        queryFactory.setSortSelectFields(isSortingSelectedFields);
        return queryFactory;
    }
}