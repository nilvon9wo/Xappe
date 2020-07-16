@IsTest
public class SXML_ListSimpleNodeUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest
	public static void testToXmlNodeShouldIncludeChildNodesAsDiscreteNodes() {
		// Arrange
		String testNode1Name = 'Test Node 1';
		String testContent1 = 'Test Content 1';
		SXML_TextSimpleNode testNode1 = new SXML_TextSimpleNode(testNode1Name, testContent1);
		String testNode2Name = 'Test Node 2';
		String testContent2 = 'Test Content 2';
		SXML_TextSimpleNode testNode2 = new SXML_TextSimpleNode(testNode2Name, testContent2);

		String testNodeListName = 'TestNodeList';
		List<SXML_SimpleNodeBuilderIntf> contentList = new List<SXML_SimpleNodeBuilderIntf>{
				testNode1, testNode2
		};
		SXML_ListSimpleNode nodeUnderTest = new SXML_ListSimpleNode(testNodeListName, contentList);

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
		System.assertEquals(2, resultNode.getChildElements().size());
		System.assertEquals(2, resultNode.getChildren().size());

		String resultXmlString = testDocument.toXmlString();
		System.assert(resultXmlString.contains('<Test Node 1>Test Content 1</Test Node 1>'));
		System.assert(resultXmlString.contains('<Test Node 2>Test Content 2</Test Node 2>'));
	}

	@IsTest
	public static void testToXmlNodeShouldIncludeChildNodesAsDiscreteNodesWhenTheyHaveTheSameName() {
		// Arrange
		String testNode1Name = 'Test Node 1';
		String testContent1 = 'Test Content 1';
		SXML_TextSimpleNode testNode1 = new SXML_TextSimpleNode(testNode1Name, testContent1);
		String testContent2 = 'Test Content 2';
		SXML_TextSimpleNode testNode2 = new SXML_TextSimpleNode(testNode1Name, testContent2);

		String testNodeListName = 'TestNodeList';
		List<SXML_SimpleNodeBuilderIntf> contentList = new List<SXML_SimpleNodeBuilderIntf>{
				testNode1, testNode2
		};
		SXML_ListSimpleNode nodeUnderTest = new SXML_ListSimpleNode(testNodeListName, contentList);

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
		System.assertEquals(2, resultNode.getChildElements().size());
		System.assertEquals(2, resultNode.getChildren().size());

		String resultXmlString = testDocument.toXmlString();
		System.assert(resultXmlString.contains('<Test Node 1>Test Content 1</Test Node 1>'));
		System.assert(resultXmlString.contains('<Test Node 1>Test Content 2</Test Node 1>'));
	}


	@IsTest
	public static void testToXmlDocumentShouldIncludeChildNodesAsDiscreteNodes() {
		// Arrange
		String testNode1Name = 'Test Node 1';
		String testContent1 = 'Test Content 1';
		SXML_TextSimpleNode testNode1 = new SXML_TextSimpleNode(testNode1Name, testContent1);
		String testNode2Name = 'Test Node 2';
		String testContent2 = 'Test Content 2';
		SXML_TextSimpleNode testNode2 = new SXML_TextSimpleNode(testNode2Name, testContent2);

		String testNodeListName = 'TestNodeList';
		List<SXML_SimpleNodeBuilderIntf> contentList = new List<SXML_SimpleNodeBuilderIntf>{
				testNode1, testNode2
		};
		SXML_ListSimpleNode nodeUnderTest = new SXML_ListSimpleNode(testNodeListName, contentList);

		// Act
		Dom.Document resultDocument;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultDocument = nodeUnderTest.toXmlDocument();
		}
		Test.stopTest();

		// Assert
		String resultXmlString = resultDocument.toXmlString();
		System.assert(resultXmlString.contains('<Test Node 1>Test Content 1</Test Node 1>'));
		System.assert(resultXmlString.contains('<Test Node 2>Test Content 2</Test Node 2>'));
	}

	@IsTest
	public static void testToXmlDocumentShouldIncludeGrandChildNodesAsDiscreteNodes() {
		// Arrange
		String testNode1Name = 'Test Node 1';
		String testContent1 = 'Test Content 1';
		SXML_TextSimpleNode testNode1 = new SXML_TextSimpleNode(testNode1Name, testContent1);
		String testNode2Name = 'Test Node 2';
		String testContent2 = 'Test Content 2';
		SXML_TextSimpleNode testNode2 = new SXML_TextSimpleNode(testNode2Name, testContent2);

		List<SXML_SimpleNodeBuilderIntf> contentChildList1 = new List<SXML_SimpleNodeBuilderIntf>{
				testNode1, testNode2
		};

		String testNode3Name = 'Test Node 3';
		String testContent3 = 'Test Content 3';
		SXML_TextSimpleNode testNode3 = new SXML_TextSimpleNode(testNode3Name, testContent3);
		String testNode4Name = 'Test Node 4';
		String testContent4 = 'Test Content 4';
		SXML_TextSimpleNode testNode4 = new SXML_TextSimpleNode(testNode4Name, testContent4);

		List<SXML_SimpleNodeBuilderIntf> contentChildList2 = new List<SXML_SimpleNodeBuilderIntf>{
				testNode3, testNode4
		};

		String nodeParentListName = 'Test Parent List';
		String nodeChildList1Name = 'Test Child List 1';
		String nodeChildList2Name = 'Test Child List 2';
		SXML_ListSimpleNode nodeUnderTest = new SXML_ListSimpleNode(nodeParentListName, new List<SXML_SimpleNodeBuilderIntf>{
				new SXML_ListSimpleNode(nodeChildList1Name, contentChildList1),
				new SXML_ListSimpleNode(nodeChildList2Name, contentChildList2)
		});

		// Act
		Dom.Document resultDocument;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultDocument = nodeUnderTest.toXmlDocument();
		}
		Test.stopTest();

		// Assert
		String resultXmlString = resultDocument.toXmlString();
		System.assert(resultXmlString.contains('<Test Child List 1><Test Node 1>Test Content 1</Test Node 1>'));
		System.assert(resultXmlString.contains('<Test Node 2>Test Content 2</Test Node 2></Test Child List 1>'));
		System.assert(resultXmlString.contains('<Test Child List 2><Test Node 3>Test Content 3</Test Node 3>'));
		System.assert(resultXmlString.contains('<Test Node 4>Test Content 4</Test Node 4></Test Child List 2>'));
	}

	// We can't test convertInnerContent because the SFDC implementation of Dom.XmlNode relies on side effects.  :-(
}