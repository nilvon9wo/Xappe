public class J2O_ParserConfig {
    public Type klass { get; private set; }

    public J2O_ParserConfig(Type klass) {
        this.klass = klass;
    }

    public Map<String, String> replacementPropertyNameByJsonPropertyMap {
        get {
            if (this.replacementPropertyNameByJsonPropertyMap == null) {
                this.replacementPropertyNameByJsonPropertyMap = new Map<String, String>();
            }
            return this.replacementPropertyNameByJsonPropertyMap;
        }
        private set;
    }

    public J2O_ParserConfig setReplacementPropertyNameByJsonPropertyMap(
            Map<String, String> replacementPropertyNameByJsonPropertyMap
    ) {
        this.replacementPropertyNameByJsonPropertyMap = replacementPropertyNameByJsonPropertyMap;
        return this;
    }
}