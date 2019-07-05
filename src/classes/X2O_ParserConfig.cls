public class X2O_ParserConfig {
	public Type klass { get; private set; }

	public X2O_ParserConfig(Type klass) {
		this.klass = klass;
	}

	public Map<String, String> replacementPropertyNameByElementNameMap {
		get {
			if (this.replacementPropertyNameByElementNameMap == null) {
				this.replacementPropertyNameByElementNameMap = new Map<String, String>();
			}
			return this.replacementPropertyNameByElementNameMap;
		}
		private set;
	}

	public List<String> forcedStringElementNameList {
		get {
			if (this.forcedStringElementNameList == null) {
				this.forcedStringElementNameList = new List<String>();
			}
			return this.forcedStringElementNameList;
		}
		private set;
	}

	public List<String> forcedCollectionElementNameList {
		get {
			if (this.forcedCollectionElementNameList == null) {
				this.forcedCollectionElementNameList = new List<String>();
			}
			return this.forcedCollectionElementNameList;
		}
		private set;
	}


	public String replacementForNull {get; private set;}

	public X2O_ParserConfig setReplacementPropertyNameByElementNameMap(
			Map<String, String> replacementPropertyNameByElementNameMap
	) {
		this.replacementPropertyNameByElementNameMap = replacementPropertyNameByElementNameMap;
		return this;
	}

	public X2O_ParserConfig setForcedStringElementNameList(
			List<String> forcedStringElementNameList
	) {
		this.forcedStringElementNameList = forcedStringElementNameList;
		return this;
	}

	public X2O_ParserConfig setForcedCollectionElementNameList(
			List<String> forcedCollectionElementNameList
	) {
		this.forcedCollectionElementNameList = forcedCollectionElementNameList;
		return this;
	}

	public X2O_ParserConfig setReplacementForNull(
			String replacementForNull
	) {
		this.replacementForNull = replacementForNull;
		return this;
	}
}