public class SXML_ListSimpleNode implements SXML_SimpleNodeBuilderIntf, SXML_SimpleDocumentBuilderIntf {
	SXML_DomHelper xmlDomHelper;

	String nodeName;
	@TestVisible List<SXML_SimpleNodeBuilderIntf> contentList;

	public SXML_ListSimpleNode(String nodeName, List<SXML_SimpleNodeBuilderIntf> contentList, SXML_DomHelper xmlDomHelper) {
		this.nodeName = nodeName;
		this.contentList = contentList;
		this.xmlDomHelper = xmlDomHelper;
	}

	public SXML_ListSimpleNode(String nodeName, List<SXML_SimpleNodeBuilderIntf> contentList) {
		this(nodeName, contentList, SXML_DomHelper.getInstance());
	}

	public Dom.XmlNode toXmlNode(Dom.XmlNode outerNode) {
		Dom.XmlNode innerNode = this.xmlDomHelper.createInnerNode(outerNode, this.nodeName);
		convertInnerContent(innerNode);
		return innerNode;
	}

	public Dom.Document toXmlDocument() {
		Dom.Document document = new Dom.Document();
		Dom.XmlNode rootNode = document.createRootElement(this.nodeName, null, null);
		rootNode.setNamespace('xsd', 'http://www.w3.org/2001/XMLSchema');
		convertInnerContent(rootNode);
		return document;
	}

	private void convertInnerContent(Dom.XmlNode innerNode) {
		for (SXML_SimpleNodeBuilderIntf content : this.contentList) {
			content.toXmlNode(innerNode);
		}
	}
}