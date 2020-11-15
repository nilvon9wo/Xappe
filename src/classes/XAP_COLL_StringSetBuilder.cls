public with sharing class XAP_COLL_StringSetBuilder {
    private Set<String> stringSet = new Set<String>();

    public XAP_COLL_StringSetBuilder add(String value) {
        this.stringSet.add(value);
        return this;
    }

    public XAP_COLL_StringSetBuilder generate(String prefix, String suffix, Integer maxValue) {
        for (Integer i = 1; i <= maxValue; i++){
            this.add(prefix + i + suffix);
        }
        return this;
    }

    public Set<String> toSet() {
        return this.stringSet.clone();
    }
}