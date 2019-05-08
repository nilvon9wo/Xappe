public class XAP_DAO_SOQL_QueryInterpolation {
    public String template { get; private set; }
    public Map<String, Object> objectsByKeyMap { get; private set; }

    public XAP_DAO_SOQL_QueryInterpolation(String template, Map<String, Object> objectsByKeyMap) {
        this.template = template;
        this.objectsByKeyMap = objectsByKeyMap;
    }

    public XAP_DAO_SOQL_QueryInterpolation(String template) {
        this(template, null);
    }
}