public virtual class XAP_DAO_DML_SecurityChecker {
    XAP_DAO_DML_SecurityUtils securityUtils;

    @TestVisible
    private XAP_DAO_DML_SecurityChecker(XAP_DAO_DML_SecurityUtils securityUtils) {
        this.securityUtils = securityUtils;
    }

    @TestVisible
    protected XAP_DAO_DML_SecurityChecker() {
        this(XAP_DAO_DML_SecurityUtils.getInstance());
    }

    private static XAP_DAO_DML_SecurityChecker instance;

    public static XAP_DAO_DML_SecurityChecker getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_DML_SecurityChecker();
        }
        return instance;
    }

    private XAP_DAO_DML_SecurityConfig securityConfig = new XAP_DAO_DML_SecurityConfig();
    public XAP_DAO_DML_SecurityChecker setSecurityConfig (XAP_DAO_DML_SecurityConfig securityConfig) {
        this.securityConfig = securityConfig;
        return this;
    }

    public Boolean check(
            List<SObject> sObjectList,
            Set<XAP_DAO_DML_OperationTypeEnum> operationTypeSet
    ) {
        // TODO
        return null;
    }
}