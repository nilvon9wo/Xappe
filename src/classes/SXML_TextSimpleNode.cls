public class SXML_TextSimpleNode implements SXML_SimpleNodeBuilderIntf, SXML_SimpleDocumentBuilderIntf {
	SXML_DomHelper xmlDomHelper;

	String nodeName;
	String content;

	public SXML_TextSimpleNode(String nodeName, String content, SXML_DomHelper xmlDomHelper) {
		this.nodeName = nodeName;
		this.content = content;
		this.xmlDomHelper = xmlDomHelper;
	}

	public SXML_TextSimpleNode(String nodeName, String content) {
		this(nodeName, content, SXML_DomHelper.getInstance());
	}

	public Dom.XmlNode toXmlNode(Dom.XmlNode outerNode) {
		Dom.XmlNode innerNode = this.xmlDomHelper.createInnerNode(outerNode, this.nodeName);
		innerNode.addTextNode(this.getContentForTextNode());
		return innerNode;
	}

	public Dom.Document toXmlDocument() {
		Dom.Document document = new Dom.Document();
		document.createRootElement(this.nodeName, null, null)
				.addTextNode(this.getContentForTextNode());
		return document;
	}

	@TestVisible
	private String getContentForTextNode() {
		return (this.content != null)
				? this.content
				: '';
	}
}