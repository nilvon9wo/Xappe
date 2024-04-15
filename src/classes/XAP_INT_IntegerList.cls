public with sharing class XAP_INT_IntegerList {
    private final List<Integer> integerList;
    private final XAP_INT_IntegerEvaluator integerEvaluator;

    public XAP_INT_IntegerList(List<Integer> integerList, XAP_INT_IntegerEvaluator integerEvaluator) {
        this.integerList = integerList;
        this.integerEvaluator = integerEvaluator;
    }

    public XAP_INT_IntegerList(List<Integer> integerList) {
        this(integerList, XAP_INT_IntegerEvaluator.getInstance());
    }

    public XAP_INT_IntegerList(Set<Integer> integerSet) {
        this(new List<Integer>(integerSet));
    }

    public XAP_INT_IntegerList() {
        this(new List<Integer>());
    }

    public XAP_INT_IntegerList add(Integer value) {
        this.integerList.add(value);
        return this;
    }

    public XAP_INT_IntegerList add(XAP_INT_IntegerList that) {
        this.integerList.addAll(that.integerList);
        return this;
    }

    public Integer max(){
        Integer initialValue = 0;
        return this.integerEvaluator.evaluate(XAP_INT_MaximumCalculator.class, this.integerList, initialValue);
    }

    public Integer product() {
        Integer initialValue = 1;
        return this.integerEvaluator.evaluate(XAP_INT_ProductCalculator.class, this.integerList, initialValue);
    }

    public Integer sum() {
        Integer initialValue = 0;
        return this.integerEvaluator.evaluate(XAP_INT_SumCalculator.class, this.integerList, initialValue);
    }
}