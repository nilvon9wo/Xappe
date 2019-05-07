public class XAP_DESC_SObjectDescribe {
    private XAP_DESC_SObjectDescribe(Schema.SObjectType sObjectType) {
        if (sObjectType == null) {
            throw new XAP_DESC_InvalidDescribeException('Invalid SObject type: null');
        }

        if (INSTANCE_CACHE.containsKey(String.valueOf(sObjectType))) {
            throw new XAP_DESC_DuplicateDescribeException(sObjectType + ' is already in the this.describe cache');
        }

        this.sObjectType = sObjectType;
        INSTANCE_CACHE.put(String.valueOf(sObjectType).toLowerCase(), this);
    }

    private static final Boolean DEFAULT_IMPLY_NAMESPACE = true;

    private static Map<String, XAP_DESC_SObjectDescribe> INSTANCE_CACHE {
        get {
            if (INSTANCE_CACHE == null) {
                INSTANCE_CACHE = new Map<String, XAP_DESC_SObjectDescribe>();
            }

            return INSTANCE_CACHE;
        }
        set;
    }

    private static Map<String, Schema.SObjectType> RAW_GLOBAL_DESCRIBE {
        get {
            if (RAW_GLOBAL_DESCRIBE == null)
                RAW_GLOBAL_DESCRIBE = Schema.getGlobalDescribe();
            return RAW_GLOBAL_DESCRIBE;
        }
        set;
    }

    private static XAP_DESC_GlobalDescribeMap WRAPPED_GLOBAL_DESCRIBE {
        get {
            if (WRAPPED_GLOBAL_DESCRIBE == null) {
                WRAPPED_GLOBAL_DESCRIBE = new XAP_DESC_GlobalDescribeMap(RAW_GLOBAL_DESCRIBE);
            }
            return WRAPPED_GLOBAL_DESCRIBE;
        }
        set;
    }

    private Schema.SObjectType sObjectType;

    // describe -------------------------------------------------------------------------

    private Schema.DescribeSObjectResult describe {
        get {
            if (this.describe == null) {
                this.describe = this.sObjectType.getDescribe();
            }
            return this.describe;
        }
        set;
    }

    public static XAP_DESC_SObjectDescribe getDescribe(String sObjectName) {
        if (String.isBlank(sObjectName)) {
            return null;
        }

        XAP_DESC_SObjectDescribe result = INSTANCE_CACHE.get(sObjectName.toLowerCase());
        if (result == null) {
            Schema.SObjectType sObjectType = WRAPPED_GLOBAL_DESCRIBE.get(sObjectName.toLowerCase());
            if (sObjectType != null) {
                result = new XAP_DESC_SObjectDescribe(sObjectType);
            }
        }
        return result;
    }

    public static XAP_DESC_SObjectDescribe getDescribe(Schema.SObjectType sObjectType) {
        if (sObjectType == null) {
            return null;
        }

        XAP_DESC_SObjectDescribe result = INSTANCE_CACHE.get(String.valueOf(sObjectType).toLowerCase());
        if (result == null) {
            result = new XAP_DESC_SObjectDescribe(sObjectType);
        }

        return result;
    }
    public static XAP_DESC_SObjectDescribe getDescribe(Schema.DescribeSObjectResult nativeDescribe) {
        if (nativeDescribe == null) {
            return null;
        }

        XAP_DESC_SObjectDescribe result = INSTANCE_CACHE.get(nativeDescribe.getName().toLowerCase());
        if (result == null) {
            result = new XAP_DESC_SObjectDescribe(nativeDescribe.getSobjectType());
        }
        return result;
    }
    public static XAP_DESC_SObjectDescribe getDescribe(SObject instance) {
        if (instance == null) {
            return null;
        }

        return getDescribe(instance.getSobjectType());
    }

    public Schema.DescribeSObjectResult getDescribe() {
        return this.describe;
    }

    public Map<String, Schema.SObjectField> getFieldsMap() {
        return this.fieldByNameMap;
    }

    // nameField -------------------------------------------------------------------------

    private Schema.SObjectField nameField;

    public Schema.SObjectField getNameField() {
        if (this.nameField == null) {
            for (Schema.SObjectField field : this.wrappedFields.values()) {
                if (field.getDescribe().isNameField()) {
                    this.nameField = field;
                    break;
                }
            }
        }
        return this.nameField;
    }

    private XAP_DESC_FieldsMap wrappedFields {
        get {
            if (this.wrappedFields == null) {
                this.wrappedFields = new XAP_DESC_FieldsMap(this.fieldByNameMap);
            }
            return this.wrappedFields;
        }
        set;
    }

    private Map<String, Schema.SObjectField> fieldByNameMap {
        get {
            if (this.fieldByNameMap == null) {
                this.fieldByNameMap = this.describe.fields.getMap();
            }
            return this.fieldByNameMap;
        }
        set;
    }

    public Schema.SObjectField getField(String name) {
        return this.getField(name, DEFAULT_IMPLY_NAMESPACE);
    }

    public Schema.SObjectField getField(String fieldName, boolean implyNamespace) {
        Schema.SObjectField result = this.wrappedFields.get(
                (
                        fieldName.endsWithIgnoreCase('__r')
                                ? (fieldName.removeEndIgnoreCase('__r') + '__c')
                                : fieldName
                ),
                implyNamespace
        );

        if (result == null) {
            result = this.wrappedFields.get(fieldName + 'Id', implyNamespace);
        }

        return result;
    }


/*




	public static Map<String,SObjectType> getRawGlobalDescribe(){
		return RAW_GLOBAL_DESCRIBE;
	}

	public static XAP_DESC_GlobalDescribeMap getGlobalDescribe(){
		return WRAPPED_GLOBAL_DESCRIBE;
	}

	public static void flushCache(){
		RAW_GLOBAL_DESCRIBE = null;
		INSTANCE_CACHE = null;
	}

	
	private Map<String,Schema.FieldSet> fieldSetByNameMap {
		get{
			if(this.fieldSetByNameMap == null) {
				this.fieldSetByNameMap = this.describe.fieldSets.getMap();
			}
			return this.fieldSetByNameMap;
		}
		set;
	}
	
	public Schema.SObjectType getSObjectType(){
		return this.sObjectType;
	}


	public XAP_DESC_FieldsMap getFields(){
		return this.wrappedFields;
	}

	public Map<String,Schema.FieldSet> getFieldSetsMap(){
		return this.fieldSetByNameMap;
	}
*/
}