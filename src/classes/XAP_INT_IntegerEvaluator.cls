public with sharing class XAP_INT_IntegerEvaluator {
    private XAP_INT_IntegerEvaluator() {
    }

    private static XAP_INT_IntegerEvaluator instance;
    public static XAP_INT_IntegerEvaluator getInstance() {
        if (instance == null) {
            instance = new XAP_INT_IntegerEvaluator();
        }
        return instance;
    }

    private static Map<Type, XAP_INT_2IntegersToIntegerInterpIntf> INTERPRETER_BY_TYPE_MAP
            = new Map<Type, XAP_INT_2IntegersToIntegerInterpIntf>();

    public Integer evaluate(Type functionType, List<Integer> integerList, Integer initialValue) {
        if (integerList.isEmpty()) {
            return null;
        }

        XAP_INT_2IntegersToIntegerInterpIntf interpreter = this.get(functionType);
        Integer result = initialValue;
        for (Integer value : integerList) {
            result = interpreter.interpret(value, result);
        }
        return result;
    }

    private XAP_INT_2IntegersToIntegerInterpIntf get(Type interpreterType) {
        XAP_INT_2IntegersToIntegerInterpIntf interpreter = INTERPRETER_BY_TYPE_MAP.get(interpreterType);
        if (interpreter == null) {
            interpreter = (XAP_INT_2IntegersToIntegerInterpIntf) interpreterType.newInstance();
        }
        return interpreter;
    }
}