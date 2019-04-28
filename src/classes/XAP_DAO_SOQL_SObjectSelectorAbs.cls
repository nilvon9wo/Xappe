public abstract class XAP_DAO_SOQL_SObjectSelectorAbs implements XAP_DAO_SOQL_SObjectSelectorIntf {
	private static final Boolean DEFAULT_INCLUDE_FIELDSET_FIELDS = false;
	private static final Boolean DEFAULT_INCLUDE_SELECTOR_FIELDS = true;
	private static final Boolean DEFAULT_ENFORCE_CRUD = true;
	private static final Boolean DEFAULT_ENFORCE_FLS = false;
	private static final Boolean DEFAULT_SORT_SELECT_FIELDS = true;
	private static final String CURRENCY_ISO_FIELDNAME = 'CurrencyIsoCode';

    public XAP_DAO_SOQL_SObjectSelectorAbs(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS, Boolean sortSelectFields)
    {
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
            if(this.isCurrencyIsoCodeEnabled == null){
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
   	private String  orderBy;
  
   	private XAP_DESC_SObjectDescribe describeWrapper {
   		get {
   			if(this.describeWrapper == null) {
   				this.describeWrapper = XAP_DESC_SObjectDescribe.getDescribe(this.getSObjectType());
   			}
   			return this.describeWrapper;
   		}
   		set;
   	}
   	 
    public abstract Schema.SObjectType getSObjectType();
    abstract List<Schema.SObjectField> getSObjectFieldList();

    public virtual List<Schema.FieldSet> getSObjectFieldSetList() {
        return null;
    }
    
    public virtual String getOrderBy() {
        if(this.orderBy == null) {
	   		this.orderBy = 'CreatedDate';
	   		if(this.describeWrapper.getNameField() != null) {
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
    
    public List<SObject> selectSObjectsById(Set<Id> idSet) { 
        return Database.query(buildQuerySObjectById());
    }
        
    public Database.QueryLocator queryLocatorById(Set<Id> idSet) {
        return Database.getQueryLocator(buildQuerySObjectById());
    }
    
    public XAP_DAO_SOQL_QueryFactory newQueryFactory() {
        return this.newQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, DEFAULT_INCLUDE_SELECTOR_FIELDS);
    }
    
    public XAP_DAO_SOQL_QueryFactory newQueryFactory(Boolean includeSelectorFields) {
        return this.newQueryFactory(this.isEnforcingCRUD, this.isEnforcingFLS, includeSelectorFields);
    }

    public XAP_DAO_SOQL_QueryFactory newQueryFactory(Boolean assertCRUD, Boolean enforceFLS, Boolean includeSelectorFields) {
        return this.configureQueryFactory(
        	new XAP_DAO_SOQL_QueryFactory(this.getSObjectType()),
        	assertCRUD, 
        	enforceFLS, 
        	includeSelectorFields
        );
    }

	public void configureQueryFactoryFields(XAP_DAO_SOQL_QueryFactory queryFactory, String relationshipFieldPath) {
		for(SObjectField field : this.getSObjectFieldList()) {
			queryFactory.selectField(relationshipFieldPath + '.' + field.getDescribe().getName());
		}		
        	
        if(Userinfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
        	queryFactory.selectField(relationshipFieldPath + '.' + CURRENCY_ISO_FIELDNAME);
        }
	}
    
    public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(XAP_DAO_SOQL_QueryFactory parentQueryFactory) {
    	return this.addQueryFactorySubselect(parentQueryFactory, DEFAULT_INCLUDE_SELECTOR_FIELDS);
    }
        
    public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(XAP_DAO_SOQL_QueryFactory parentQueryFactory, Boolean includeSelectorFields) {
    	return this.configureQueryFactory(
    		parentQueryFactory.subselectQuery(getSObjectType()), 
    		this.isEnforcingCRUD, 
    		this.isEnforcingFLS, 
    		includeSelectorFields
    	); 
    }
        
	public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(XAP_DAO_SOQL_QueryFactory parentQueryFactory, String relationshipName) {
		return this.addQueryFactorySubselect(parentQueryFactory, relationshipName, DEFAULT_INCLUDE_SELECTOR_FIELDS);
	}

	public XAP_DAO_SOQL_QueryFactory addQueryFactorySubselect(
			XAP_DAO_SOQL_QueryFactory parentQueryFactory,
			String relationshipName, 
			Boolean includeSelectorFields
		) {
		return this.configureQueryFactory(
			parentQueryFactory.subselectQuery(relationshipName),  
			this.isEnforcingCRUD, 
			this.isEnforcingFLS, 
			includeSelectorFields
		);
	}

    private String buildQuerySObjectById() {   
        return this.newQueryFactory()
        	.setCondition(new XAP_DAO_SOQL_WHERE_ArbitraryStringClause('Id IN :idSet'))
        	.toSOQL(); 
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
    
    private XAP_DAO_SOQL_QueryFactory configureSelectorFields(XAP_DAO_SOQL_QueryFactory queryFactory, Boolean includeSelectorFields) {
        if(includeSelectorFields) {
            queryFactory.selectFields(this.getSObjectFieldList());

	        List<Schema.FieldSet> fieldSetList = this.getSObjectFieldSetList();
	        if(this.isIncludingFieldSetFields && fieldSetList != null) {
	            for(Schema.FieldSet fieldSet : fieldSetList) {
	            	queryFactory.selectFields(fieldSet);
	            }
	        } 
	
	        if(Userinfo.isMultiCurrencyOrganization() && this.isCurrencyIsoCodeEnabled) {
	        	queryFactory.selectField(CURRENCY_ISO_FIELDNAME);
	        }
        }
        return queryFactory; 
    }
    
    private XAP_DAO_SOQL_QueryFactory parseOrderBy(XAP_DAO_SOQL_QueryFactory queryFactory) {
        for(String orderBy : this.getOrderBy().split(',')) {
            List<String> orderByPartList = orderBy.trim().split(' ');
            
            String fieldNamePart = orderByPartList[0];
            String fieldSortOrderPart = orderByPartList.size() > 1 ? orderByPartList[1] : null;
            XAP_DAO_SOQL_QuerySortOrderEnum fieldSortOrder = XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING;
            
            fieldSortOrder = (!String.isBlank(fieldSortOrderPart) && fieldSortOrderPart.equalsIgnoreCase('DESC'))
            	? XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING
            	: XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING;
            
            queryFactory.addOrdering(fieldNamePart, fieldSortOrder, orderBy.containsIgnoreCase('NULLS LAST'));
        }
        return  queryFactory;          
    } 
}