public class XAP_DAO_WHERE_ComparisonOpEnumHelper {
    private XAP_DAO_WHERE_ComparisonOpEnumHelper(){
    }
    private static XAP_DAO_WHERE_ComparisonOpEnumHelper INSTANCE;
    
    public static XAP_DAO_WHERE_ComparisonOpEnumHelper getInstance() {
    	if (INSTANCE == null) {
    		INSTANCE = new XAP_DAO_WHERE_ComparisonOpEnumHelper();
    	}
    	return INSTANCE;
    }
    
    private static final Map<XAP_DAO_WHERE_ComparisonOperatorEnum, String> OPERATOR_BY_ENUM_MAP = new Map<XAP_DAO_WHERE_ComparisonOperatorEnum, String>{
	    XAP_DAO_WHERE_ComparisonOperatorEnum.EQUALS => '=',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.NOT_EQUALS => '!=',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.LESS_THAN  => '<', 
	    XAP_DAO_WHERE_ComparisonOperatorEnum.LESS_THAN_OR_EQUAL => '<=',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.GREATER_THAN => '>',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.GREATER_THAN_OR_EQUAL => '>=',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.IS_LIKE => ' LIKE ',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.IS_IN => ' IN ',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.IS_NOT_IN => ' NOT IN ',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.INCLUDES => ' INCLUDES ',
	    XAP_DAO_WHERE_ComparisonOperatorEnum.EXCLUSES => ' EXCLUDES '
    };
    
    public String get(XAP_DAO_WHERE_ComparisonOperatorEnum value) {
    	return OPERATOR_BY_ENUM_MAP.get(value);
    } 
}