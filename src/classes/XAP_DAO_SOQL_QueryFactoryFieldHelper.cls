public class XAP_DAO_SOQL_QueryFactoryFieldHelper {
    XAP_DAO_SOQL_QueryFactoryRelationHelper relationshipHelper;
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    private XAP_DAO_SOQL_QueryFactoryFieldHelper(
            XAP_DAO_SOQL_QueryFactoryRelationHelper relationshipHelper,
            XAP_DAO_SOQL_SecurityUtils securityUtils
    ) {
        this.relationshipHelper = relationshipHelper;
        this.securityUtils = securityUtils;
    }

    private XAP_DAO_SOQL_QueryFactoryFieldHelper() {
        this(XAP_DAO_SOQL_QueryFactoryRelationHelper.getInstance(), XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    private static XAP_DAO_SOQL_QueryFactoryFieldHelper instance;

    public static XAP_DAO_SOQL_QueryFactoryFieldHelper getInstance() {
        instance = new XAP_DAO_SOQL_QueryFactoryFieldHelper();
        return instance;
    }

    public Set<String> addFields(XAP_DAO_SOQL_Query query, FieldSet fieldSet, Boolean allowCrossObject) {
        if (fieldSet.getSObjectType() != query.sObjectType) {
            throw new XAP_DAO_SOQL_InvalidFieldSetException(
                    'Field set "' + fieldSet.getName() + '" is not for SObject type "' + query.sObjectType + '"'
            );
        }

        for (FieldSetMember field : fieldSet.getFields()) {
            if (!allowCrossObject && field.getFieldPath().contains('.')) {
                throw new XAP_DAO_SOQL_InvalidFieldSetException(
                        'Cross-object query.fieldSet not allowed and field "'
                                + field.getFieldPath() + '"" is a cross-object field.'
                );
            }
            query.fieldSet.add(this.getFieldPath(query, field.getFieldPath()));
        }
        return query.fieldSet;
    }

    public Set<String> addFields(XAP_DAO_SOQL_Query query, Set<Schema.SObjectField> fieldSet) {
        for (Schema.SObjectField token : fieldSet) {
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException();
            }

            if (query.enforceFLS) {
                this.securityUtils.checkFieldIsReadable(query.sObjectType, token);
            }

            query.fieldSet.add(this.getFieldTokenPath(token));
        }
        return query.fieldSet;
    }

    public Set<String> addFields(XAP_DAO_SOQL_Query query, Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            query.fieldSet.add(this.getFieldPath(query, fieldName));
        }
        return query.fieldSet;
    }

    // ------------------------------------------------------------------------------------

    public String getFieldTokenPath(Schema.SObjectField field) {
        if (field == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException('Invalid field: null');
        }
        return field.getDescribe().getName();
    }

    public String getFieldPath(XAP_DAO_SOQL_Query query, String fieldName) {
        if (!fieldName.contains('.')) {
            Schema.SObjectField token = XAP_DESC_SObjectDescribe.getDescribe(query.sObjectType)
                    .getField(fieldName.toLowerCase());
            if (token == null) {
                throw new XAP_DAO_SOQL_InvalidFieldException(fieldName, query.sObjectType);
            }

            if (query.enforceFLS) {
                this.securityUtils.checkFieldIsReadable(query.sObjectType, token);
            }
            return token.getDescribe().getName();
        }

        return String.join(this.relationshipHelper.transverseRelationships(query, fieldName), '.');
    }

}