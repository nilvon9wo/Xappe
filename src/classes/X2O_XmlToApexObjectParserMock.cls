@IsTest
public class X2O_XmlToApexObjectParserMock extends X2O_XmlToApexObjectParser {
	public X2O_ParserConfig receivedParserConfig;
	public Dom.Document receivedDocument;
	public Object returnedObject;
	public override Object parseDocumentToObject(X2O_ParserConfig parserConfig, Dom.Document document) {
		this.receivedParserConfig = parserConfig;
		this.receivedDocument = document;
		return this.returnedObject;
	}
}