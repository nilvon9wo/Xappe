public class XAP_DAO_SOQL_WHERE_CompareOpEnumHelper {
	private static final Map<XAP_DAO_SOQL_WHERE_CompareOperatorEnum, String> OPERATOR_BY_ENUM_MAP
			= new Map<XAP_DAO_SOQL_WHERE_CompareOperatorEnum, String>{
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS => '=',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.NOT_EQUALS => '!=',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.LESS_THAN => '<',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.LESS_THAN_OR_EQUAL => '<=',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.GREATER_THAN => '>',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.GREATER_THAN_OR_EQUAL => '>=',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.IS_LIKE => ' LIKE ',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.IS_IN => ' IN ',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.IS_NOT_IN => ' NOT IN ',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.INCLUDES => ' INCLUDES ',
					XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EXCLUSES => ' EXCLUDES '
			};

	public static String get(XAP_DAO_SOQL_WHERE_CompareOperatorEnum value) {
		return OPERATOR_BY_ENUM_MAP.get(value);
	}
}
