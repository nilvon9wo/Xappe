public class SXML_DomHelper {
	private static SXML_DomHelper INSTANCE;

	private SXML_DomHelper() {
	}

	public static SXML_DomHelper getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new SXML_DomHelper();
		}
		return INSTANCE;
	}

	public DOM.XmlNode createInnerNode(DOM.XmlNode outerNode, String nodeName) {
		outerNode.addChildElement(nodeName, null, null);
		List<Dom.XmlNode> innerNodeList = outerNode.getChildren();
		return innerNodeList[innerNodeList.size() - 1];
	}
}