public abstract class XAP_DAO_SOQL_WHERE_AbsConjunctionClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    List<XAP_DAO_SOQL_WHERE_ClauseIntf> clauseList;
    String conjunction;

    public XAP_DAO_SOQL_WHERE_AbsConjunctionClause(List<XAP_DAO_SOQL_WHERE_ClauseIntf> clauseList, String conjunction) {
        this.clauseList = clauseList;
        this.conjunction = conjunction;
    }

    private static Integer NEXT_KEY_MODIFIER = 0;

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        List<String> templateList = new List<String>();
        Map<String, Object> objectsByKeyMap = new Map<String, Object>();
        for (XAP_DAO_SOQL_WHERE_ClauseIntf clause : clauseList) {
            XAP_DAO_SOQL_QueryInterpolation queryInterpolation = (objectsByKeyMap.isEmpty())
                    ? clause.toQueryInterpolation()
                    : this.uniquifyKeys(clause.toQueryInterpolation(), objectsByKeyMap);

            templateList.add(queryInterpolation.template);
            objectsByKeyMap.putAll(queryInterpolation.objectsByKeyMap);
        }

        String combinedTemplate = '(' + String.join(templateList, ') ' + this.conjunction + ' (') + ')';
        return new XAP_DAO_SOQL_QueryInterpolation(combinedTemplate, objectsByKeyMap);
    }

    private XAP_DAO_SOQL_QueryInterpolation uniquifyKeys(
            XAP_DAO_SOQL_QueryInterpolation queryInterpolation,
            Map<String, Object> existingObjectsByKeyMap
    ) {
        String template = queryInterpolation.template;
        Map<String, Object> objectsByKeyMap = queryInterpolation.objectsByKeyMap;
        for (String oldKey : objectsByKeyMap.keySet()) {
            if (existingObjectsByKeyMap.containsKey(oldKey)) {
                String newKey = oldKey + ':::' + NEXT_KEY_MODIFIER++;
                template = template.replace('${' + oldKey + '}', ':${' + newKey + '}');
                objectsByKeyMap.put(newKey, objectsByKeyMap.remove(oldKey));
            }
        }
        return new XAP_DAO_SOQL_QueryInterpolation(template, objectsByKeyMap);
    }
}