public class XAP_DAO_SOQL_SObjectFieldCollection {
    SObjectType sObjectType;
    XAP_DAO_SOQL_SObjectFieldHelper fieldHelper;
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    private XAP_DAO_SOQL_SObjectFieldCollection(
            SObjectType sObjectType,
            XAP_DAO_SOQL_SObjectFieldHelper fieldHelper,
            XAP_DAO_SOQL_SecurityUtils securityUtils
    ) {
        this.sObjectType = sObjectType;
        this.fieldHelper = fieldHelper;
        this.securityUtils = securityUtils;
    }

    public XAP_DAO_SOQL_SObjectFieldCollection(SObjectType sObjectType) {
        this(sObjectType, XAP_DAO_SOQL_SObjectFieldHelper.getInstance(), XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    public static final Boolean ALLOW_CROSS_OBJECTS = true;
    public static final Boolean PROHIBIT_CROSS_OBJECTS = false;

    private Set<String> fieldSet {
        get {
            if (this.fieldSet == null) {
                this.fieldSet = new Set<String>();
            }
            return this.fieldSet;
        }
        private set;
    }

    public Set<String> toSet() {
        return this.fieldSet;
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(String fieldName, Boolean enforceFLS) {
        this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, enforceFLS));
        return this;
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(SObjectField field, Boolean enforceFLS) {
        if (field == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException(null, this.sObjectType);
        }
        if (enforceFLS) {
            this.securityUtils.checkFieldIsReadable(sObjectType, field);
        }
        this.fieldSet.add(this.fieldHelper.getFieldTokenPath(field));
        return this;
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(Set<String> fieldNames, Boolean enforceFLS) {
        for (String fieldName : fieldNames) {
            this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, fieldName, enforceFLS));
        }
        return this;
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(List<String> fieldNames, Boolean enforceFLS) {
        return this.add(new Set<String>(fieldNames), enforceFLS);
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(Set<SObjectField> fields, Boolean enforceFLS) {
        for (SObjectField token : fields) {
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException();
            }
            if (enforceFLS) {
                this.securityUtils.checkFieldIsReadable(sObjectType, token);
            }
            this.fieldSet.add(this.fieldHelper.getFieldTokenPath(token));
        }
        return this;
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(List<SObjectField> fields, Boolean enforceFLS) {
        return this.add(new Set<SObjectField>(fields), enforceFLS);
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(FieldSet fieldSet, Boolean enforceFLS) {
        return this.add(fieldSet, enforceFLS, ALLOW_CROSS_OBJECTS);
    }

    public XAP_DAO_SOQL_SObjectFieldCollection add(FieldSet fieldSet, Boolean enforceFLS, Boolean allowCrossObject) {
        if (fieldSet.getSObjectType() != this.sObjectType) {
            throw new XAP_DAO_SOQL_InvalidFieldSetException(
                    'Field set "' + fieldSet.getName() + '" is not for SObject type "' + this.sObjectType + '"'
            );
        }
        for (FieldSetMember field : fieldSet.getFields()) {
            if (!allowCrossObject && field.getFieldPath().contains('.')) {
                throw new XAP_DAO_SOQL_InvalidFieldSetException(
                        'Cross-object fields not allowed and field "'
                                + field.getFieldPath() + '"" is a cross-object field.'
                );
            }
            this.fieldSet.add(this.fieldHelper.getFieldPath(this.sObjectType, field.getFieldPath(), enforceFLS));
        }
        return this;
    }


}