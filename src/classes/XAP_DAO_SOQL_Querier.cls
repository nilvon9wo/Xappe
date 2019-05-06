public virtual class XAP_DAO_SOQL_Querier {
    private XAP_DAO_SOQL_Querier() {
    }

    private static XAP_DAO_SOQL_Querier instance;
    public static XAP_DAO_SOQL_Querier getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_SOQL_Querier();
        }
        return instance;
    }

    private static Object object0;
    private static Object object1;
    private static Object object2;
    private static Object object3;
    private static Object object4;
    private static Object object5;
    private static Object object6;
    private static Object object7;
    private static Object object8;
    private static Object object9;
    private static final Integer LAST_OBJECT_NUMBER = 9;

    public List<SObject> selectFor(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
        return Database.query(
                this.toSoql(queryInterpolation)
        );
    }

    public Database.QueryLocator getQueryLocatorFor(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
        return Database.getQueryLocator(
                this.toSoql(queryInterpolation)
        );
    }

    public String toSoql(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
        Integer requiredBindingSize = queryInterpolation.objectsByKeyMap.keySet().size();
        if (requiredBindingSize > LAST_OBJECT_NUMBER) {
            throw new RebindObjectsLimitException(
                    'XAP_DAO_SOQL_Querier currently only supports ' + LAST_OBJECT_NUMBER + ' bindings.'
                            + '  Attempted query requires ' + requiredBindingSize + ' bindings'
            );
        }

        String localizedTemplate = queryInterpolation.template;
        Integer counter = 0;
        for (String key : queryInterpolation.objectsByKeyMap.keySet()) {
            localizedTemplate = this.rebind(
                    localizedTemplate,
                    key,
                    queryInterpolation.objectsByKeyMap.get(key),
                    counter++
            );
        }
        return localizedTemplate;
    }

    private String rebind(String localizedTemplate, String key, Object value, Integer index) {
        Type rebinderType = Type.forName('XAP_DAO_SOQL_Querier.ObjectRebinder' + index);
        ObjectRebinderAbs rebinder = (ObjectRebinderAbs) rebinderType.newInstance();
        return rebinder.rebind(localizedTemplate, key, value);
    }

    private abstract class ObjectRebinderAbs {
        public abstract String rebind(String localizedTemplate, String key, Object value);

        protected String rebind(String localizedTemplate, String oldKey, String newKey) {
            return localizedTemplate.replace('${' + oldKey + '}', newKey);
        }
    }

    public class ObjectRebinder0 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object0 = value;
            return super.rebind(localizedTemplate, key, 'object0');
        }
    }

    public class ObjectRebinder1 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object1 = value;
            return super.rebind(localizedTemplate, key, 'object1');
        }
    }

    public class ObjectRebinder2 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object2 = value;
            return super.rebind(localizedTemplate, key, 'object2');
        }
    }

    public class ObjectRebinder3 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object3 = value;
            return super.rebind(localizedTemplate, key, 'object3');
        }
    }

    public class ObjectRebinder4 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object4 = value;
            return super.rebind(localizedTemplate, key, 'object4');
        }
    }

    public class ObjectRebinder5 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object5 = value;
            return super.rebind(localizedTemplate, key, 'object5');
        }
    }

    private class ObjectRebinder6 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object6 = value;
            return super.rebind(localizedTemplate, key, 'object6');
        }
    }

    public class ObjectRebinder7 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object7 = value;
            return super.rebind(localizedTemplate, key, 'object7');
        }
    }

    public class ObjectRebinder8 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object8 = value;
            return super.rebind(localizedTemplate, key, 'object8');
        }
    }

    public class ObjectRebinder9 extends ObjectRebinderAbs {
        public override String rebind(String localizedTemplate, String key, Object value) {
            object9 = value;
            return super.rebind(localizedTemplate, key, 'object9');
        }
    }

    private class RebindObjectsLimitException extends Exception {
    }
}