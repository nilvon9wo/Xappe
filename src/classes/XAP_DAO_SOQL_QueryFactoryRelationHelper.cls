public class XAP_DAO_SOQL_QueryFactoryRelationHelper {
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    private XAP_DAO_SOQL_QueryFactoryRelationHelper(XAP_DAO_SOQL_SecurityUtils securityUtils) {
        this.securityUtils = securityUtils;
    }

    private XAP_DAO_SOQL_QueryFactoryRelationHelper() {
        this(XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    private static XAP_DAO_SOQL_QueryFactoryRelationHelper instance;

    public static XAP_DAO_SOQL_QueryFactoryRelationHelper getInstance() {
        instance = new XAP_DAO_SOQL_QueryFactoryRelationHelper();
        return instance;
    }

    // getChildRelationship --------------------------------------------------------------------------------------

    public Schema.ChildRelationship getChildRelationship(XAP_DAO_SOQL_Query query, SObjectType thatSObjectType) {
        for (Schema.ChildRelationship childRow : query.sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getChildSObject() == thatSObjectType && childRow.getRelationshipName() != null) {
                return childRow;
            }
        }
        throw new XAP_DAO_SOQL_InvalidSubqueryException(
                'Invalid call to subselectQuery.  Invalid relationship for sObjectType ' + query.sObjectType
                        + ' and sObjectType =' + thatSObjectType
        );
    }

    public Schema.ChildRelationship getChildRelationship(XAP_DAO_SOQL_Query query, String relationshipName) {
        for (Schema.ChildRelationship childRow : query.sObjectType.getDescribe().getChildRelationships()) {
            if (childRow.getRelationshipName() == relationshipName) {
                return childRow;
            }
        }
        return null;
    }

    // transverseRelationships  -------------------------------------------------------------------------------------

    public List<String> transverseRelationships(XAP_DAO_SOQL_Query query, String fieldName) {
        List<String> fieldPath = new List<String>();
        Schema.SObjectType lastSObjectType = query.sObjectType;
        Iterator<String> fieldIterator = fieldName.split('\\.').iterator();
        while (fieldIterator.hasNext()) {
            String field = fieldIterator.next();
            SObjectField sObjectFieldToken = getsObjectFieldToken(lastSObjectType, field);
            DescribeFieldResult sObjectFieldDescription = getTokenDescription(sObjectFieldToken);
            this.enforceFL5(sObjectFieldToken, query, lastSObjectType);

            if (
                    sObjectFieldToken != null
                            && fieldIterator.hasNext()
                            && sObjectFieldDescription.getSoapType() == Schema.SoapType.ID
                    ) {
                lastSObjectType = sObjectFieldDescription.getReferenceTo()[0];
                fieldPath.add(sObjectFieldDescription.getRelationshipName());
            } else if (
                    sObjectFieldToken != null
                            && !fieldIterator.hasNext()
                    ) {
                fieldPath.add(sObjectFieldDescription.getName());
            } else {
                throw this.createException(sObjectFieldToken, field, lastSObjectType);
            }
        }
        return fieldPath;
    }

    private Exception createException(SObjectField sObjectFieldToken, String field, SObjectType lastSObjectType) {
        return (sObjectFieldToken == null)
                ? (Exception) new XAP_DAO_SOQL_InvalidFieldException(field, lastSObjectType)
                : (Exception) new XAP_DAO_SOQL_NonReferenceFieldException(
                        lastSObjectType + '.' + field
                                + ' is not a lookup or master-detail field'
                                + ' but is used in a cross-object query field.'
                );
    }

    private SObjectField getsObjectFieldToken(SObjectType lastSObjectType, String field) {
        Schema.SObjectField sObjectFieldToken = XAP_DESC_SObjectDescribe.getDescribe(lastSObjectType)
                .getField(field.toLowerCase());
        return sObjectFieldToken;
    }

    private DescribeFieldResult getTokenDescription(SObjectField sObjectFieldToken) {
        DescribeFieldResult tokenDescribe = sObjectFieldToken != null
                ? sObjectFieldToken.getDescribe()
                : null;
        return tokenDescribe;
    }

    private XAP_DAO_SOQL_QueryFactoryRelationHelper enforceFL5(
            SObjectField token,
            XAP_DAO_SOQL_Query query,
            SObjectType lastSObjectType
    ) {
        if (
                token != null
                        && query.enforceFLS
                ) {
            this.securityUtils.checkFieldIsReadable(lastSObjectType, token);
        }
        return this;
    }
}