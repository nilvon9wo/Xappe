public virtual class UTIL_GenericValueHelper {
    public Object notNullOrDefault(Object newValue, Object defaultValue) {
    	return (newValue != null)
    		? newValue
    		: defaultValue;
    }
}