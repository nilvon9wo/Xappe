//@see: https://sfdcfox.blogspot.com/2016/01/converting-xml-to-native-objects.html
public virtual class X2O_XmlToApexObjectParser {
	private static final Pattern boolPat = Pattern.compile('^(true|false)$');
	private static final Pattern decPat = Pattern.compile('^[-+]?\\d+(\\.\\d+)?$');
	private static final Pattern datePat = Pattern.compile('^\\d{4}.\\d{2}.\\d{2}$');
	private static final Pattern timePat = Pattern.compile('^\\d{4}.\\d{2}.\\d{2} ' +
			'(\\d{2}:\\d{2}:\\d{2} ([-+]\\d{2}:\\d{2})?)?$');


	private static X2O_XmlToApexObjectParser INSTANCE;

	@TestVisible
	protected X2O_XmlToApexObjectParser() {
	}

	public static X2O_XmlToApexObjectParser getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new X2O_XmlToApexObjectParser();
		}
		return INSTANCE;
	}

	public Object parseDocumentToObject(Dom.Document doc, Type klass) {
		return parseDocumentToObject(new X2O_ParserConfig(klass), doc);
	}

	public virtual Object parseDocumentToObject(
			X2O_ParserConfig parserConfig,
			Dom.Document doc
	) {
		String jsonString = this.parseDocumentToJson(parserConfig, doc);
		for (String reservedWord : parserConfig.replacementPropertyNameByElementNameMap.keySet()) {
			jsonString = jsonString.replace(
					wrapPropertyName(reservedWord),
					wrapPropertyName(parserConfig.replacementPropertyNameByElementNameMap.get(reservedWord))
			);
		}
		return JSON.deserialize(jsonString, parserConfig.klass);
	}

	private String parseDocumentToJson(X2O_ParserConfig parserConfig, Dom.Document doc) {
		return JSON.serialize(this.parseDocumentToMap(parserConfig, doc));
	}

	private Map<Object, Object> parseDocumentToMap(X2O_ParserConfig parserConfig, Dom.Document doc) {
		return parseNode(parserConfig, doc.getRootElement(), new Map<Object, Object>());
	}

	private Map<Object, Object> parseNode(X2O_ParserConfig parserConfig, Dom.XmlNode node, Map<Object, Object> parent) {
		for (Dom.XmlNode child : node.getChildElements()) {
			String name = child.getName();
			Object value = this.toObject(name, child.getText().trim(), parserConfig);

			if (value != null) {
				parseContentNode(parent, name, value);
			} else if (child.getNodeType() == Dom.XmlNodeType.ELEMENT) {
				parseElementNode(parserConfig, child, parent, name);
			}
		}
		return parent;
	}

	private void parseContentNode(Map<Object, Object> parent, String name, Object value) {
		if (parent.containsKey(name)) {
			try {
				((List<Object>) parent.get(name)).add(value);
			} catch (Exception e) {
				parent.put(name, new List<Object>{
						parent.get(name), value
				});
			}
		} else {
			parent.put(name, value);
		}
	}

	private void parseElementNode(X2O_ParserConfig parserConfig, Dom.XmlNode child, Map<Object, Object> parent, String name) {
		Map<Object, Object> temp = parseNode(parserConfig, child, new Map<Object, Object>());
		if (!temp.isEmpty()) {
			putValueIntoJson(parserConfig, parent, name, temp);
		} else {
			putNullRepresentationIntoJson(parserConfig, parent, name);
		}
	}

	private void putValueIntoJson(X2O_ParserConfig parserConfig, Map<Object, Object> parent, String name, Map<Object, Object> temp) {
		if (parserConfig.forcedCollectionElementNameList.contains(name)) {
			putForcedCollectionIntoJson(parent, name, temp);
		} else if (parent.containsKey(name)) {
			putContainerIntoJson(parent, name, temp);
		} else {
			parent.put(name, temp);
		}
	}

	private void putForcedCollectionIntoJson(Map<Object, Object> parent, String name, Map<Object, Object> temp) {
		try {
			if (!parent.containsKey(name)) {
				parent.put(name, new List<Object>{});
			}
			((List<Object>) parent.get(name)).add(temp);
		} catch (Exception e) {
			parent.put(name, new List<Object>{
					parent.get(name), temp
			});
		}
	}

	private void putContainerIntoJson(Map<Object, Object> parent, String name, Map<Object, Object> temp) {
		try {
			((List<Object>) parent.get(name)).add(temp);
		} catch (Exception e) {
			parent.put(name, new List<Object>{
					parent.get(name), temp
			});
		}
	}

	private void putNullRepresentationIntoJson(X2O_ParserConfig parserConfig, Map<Object, Object> parent, String name) {
		if (parserConfig.replacementForNull != null) {
			parent.put(name, parserConfig.replacementForNull);
		}
	}

	private Object toObject(String nodeName, String nodeText, X2O_ParserConfig parserConfig) {
		return String.isBlank(nodeText)
				? null
				: parserConfig.forcedStringElementNameList.contains(nodeName)
						? (Object) nodeText
						: boolPat.matcher(nodeText).find()
								? (Object) Boolean.valueOf(nodeText)
								: decPat.matcher(nodeText).find()
										? (Object) Decimal.valueOf(nodeText)
										: datePat.matcher(nodeText).find()
												? (Object) Date.valueOf(nodeText)
												: timePat.matcher(nodeText).find()
														? (Object) Datetime.valueOf(nodeText)
														: (Object) nodeText;
	}

	private String wrapPropertyName(String value) {
		return '"' + value + '":';
	}
}