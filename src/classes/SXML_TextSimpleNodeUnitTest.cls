@IsTest
public class SXML_TextSimpleNodeUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final String TEST_NODE_NAME = 'TestNode';
	private static final String TEST_CONTENT = 'Test content';

	@IsTest
	public static void testToXmlNodeShouldCreateExpectedNode() {
		// Arrange
		SXML_TextSimpleNode nodeUnderTest = new SXML_TextSimpleNode(TEST_NODE_NAME, TEST_CONTENT);

		Dom.Document testDocument = new Dom.Document();
		Dom.XmlNode testRootNode = testDocument.createRootElement('root', null, null);
		testRootNode.setNamespace('xsd', 'http://www.w3.org/2001/XMLSchema');

		// Act
		Dom.XmlNode resultNode;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultNode = nodeUnderTest.toXmlNode(testRootNode);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_CONTENT, resultNode.getText());
		System.assertEquals(0, resultNode.getChildElements().size());
		System.assertEquals(1, resultNode.getChildren().size());

		String resultString = testDocument.toXmlString();
		System.assert(resultString.contains('<' + TEST_NODE_NAME + '>' + TEST_CONTENT + '</' + TEST_NODE_NAME + '>') );
	}

	@IsTest
	public static void testToXmlDocumentShouldCreateExpectedDocument() {
		// Arrange
		SXML_TextSimpleNode nodeUnderTest = new SXML_TextSimpleNode(TEST_NODE_NAME, TEST_CONTENT);

		// Act
		Dom.Document resultDocument;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultDocument = nodeUnderTest.toXmlDocument();
		}
		Test.stopTest();

		// Assert
		String resultString = resultDocument.toXmlString();
		System.assert(resultString.contains('<' + TEST_NODE_NAME + '>' + TEST_CONTENT + '</' + TEST_NODE_NAME + '>') );
	}

	@IsTest
	public static void testGetContentForTextNodeShouldReturnSuppliedContent() {
		// Arrange
		SXML_TextSimpleNode nodeUnderTest = new SXML_TextSimpleNode(TEST_NODE_NAME, TEST_CONTENT);

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = nodeUnderTest.getContentForTextNode();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_CONTENT, result);
	}

	@IsTest
	public static void testGetContentForTextNodeShouldReturnEmptyStringIfNoSuppliedContent() {
		// Arrange
		SXML_TextSimpleNode nodeUnderTest = new SXML_TextSimpleNode(TEST_NODE_NAME, null);

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = nodeUnderTest.getContentForTextNode();
		}
		Test.stopTest();

		// Assert
		System.assertEquals('', result);
	}
}