public virtual class J2O_JsonToApexObjectParser {
    private J2O_JsonToApexObjectParser()
    {
    }

    private static J2O_JsonToApexObjectParser INSTANCE;
    public static J2O_JsonToApexObjectParser getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new J2O_JsonToApexObjectParser();
        }
        return INSTANCE;
    }

    public Object parseDocumentToObject(String json, Type klass) {
        return parseDocumentToObject(json, new J2O_ParserConfig(klass));
    }

    public virtual Object parseDocumentToObject(
            String json,
            J2O_ParserConfig parserConfig
    ) {
        for (String reservedWord : parserConfig.replacementPropertyNameByJsonPropertyMap.keySet()) {
            json = json.replace(
                    wrapPropertyName(reservedWord),
                    wrapPropertyName(parserConfig.replacementPropertyNameByJsonPropertyMap.get(reservedWord))
            );
        }
        return System.JSON.deserialize(json, parserConfig.klass);
    }

    //noinspection ApexMethodCanBeStatic
    private String wrapPropertyName(String value) {
        return '"' + value + '":';
    }
}