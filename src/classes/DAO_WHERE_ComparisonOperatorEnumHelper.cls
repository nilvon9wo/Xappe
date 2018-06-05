public class DAO_WHERE_ComparisonOperatorEnumHelper {
    private DAO_WHERE_ComparisonOperatorEnumHelper(){
    }
    private static DAO_WHERE_ComparisonOperatorEnumHelper INSTANCE;
    
    public static DAO_WHERE_ComparisonOperatorEnumHelper getInstance() {
    	if (INSTANCE == null) {
    		INSTANCE = new DAO_WHERE_ComparisonOperatorEnumHelper();
    	}
    	return INSTANCE;
    }
    
    private static final Map<DAO_WHERE_ComparisonOperatorEnum, String> OPERATOR_BY_ENUM_MAP = new Map<DAO_WHERE_ComparisonOperatorEnum, String>{
	    DAO_WHERE_ComparisonOperatorEnum.EQUALS => ' = ',
	    DAO_WHERE_ComparisonOperatorEnum.NOT_EQUALS => ' != ',
	    DAO_WHERE_ComparisonOperatorEnum.LESS_THAN  => ' < ', 
	    DAO_WHERE_ComparisonOperatorEnum.LESS_THAN_OR_EQUAL => ' <= ',
	    DAO_WHERE_ComparisonOperatorEnum.GREATER_THAN => ' > ',
	    DAO_WHERE_ComparisonOperatorEnum.GREATER_THAN_OR_EQUAL => ' >= ',
	    DAO_WHERE_ComparisonOperatorEnum.IS_LIKE => ' LIKE ',
	    DAO_WHERE_ComparisonOperatorEnum.IS_IN => ' IN ',
	    DAO_WHERE_ComparisonOperatorEnum.IS_NOT_IN => ' NOT IN ',
	    DAO_WHERE_ComparisonOperatorEnum.INCLUDES => ' INCLUDES ',
	    DAO_WHERE_ComparisonOperatorEnum.EXCLUSES => ' EXCLUDES '
    };
    
    public String get(DAO_WHERE_ComparisonOperatorEnum value) {
    	return OPERATOR_BY_ENUM_MAP.get(value);
    } 
}