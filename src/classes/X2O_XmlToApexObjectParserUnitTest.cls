//@see: Converting XML To Native Objects, https://sfdcfox.blogspot.com/2016/01/converting-xml-to-native-objects.html
@IsTest
class X2O_XmlToApexObjectParserUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final X2O_XmlToApexObjectParser PARSER_UNDER_TEST = X2O_XmlToApexObjectParser.getInstance();

	private static final String TEST_SENDER_IDENTIFICATION = '007';
	private static final Integer TEST_RECEIVER_IDENTIFICATION = 111;
	private static final String TEST_MESSAGE_TYPE = 'OAR';
	private static final Decimal TEST_MESSAGE_VERSION = 1.0;

	private static final List<String> TEST_FORCE_COLLECTION_ELEMENT_LIST = new List<String>{
			'FreeTextInformation',
			'Line',
			'PartyInformation',
			'SubtotalsInformation'
	};

	private static final List<String> TEST_FORCE_STRING_VALUE_ELEMENT_LIST = new List<String>{
			'ClientOrderReference',
			'InstructionLine',
			'MessageVersion',
			'OrderPricePerQuantity',
			'SenderIdentification',
			'ServiceLevel'
	};

	private static final String HELLO_WORLD_XML = '<a>'
			+ '<b><c>Hello World</c><d>2016-05-01</d><e>2016-05-01 '
			+ '11:29:00 +03:00</e><f>true</f><g>3.1415</g><h>Two</h><h>Parts</h></b>'
			+ '<b><c>Hello World</c><d>2016-05-01</d><e>2016-05-01 '
			+ '11:29:00 +03:00</e><f>true</f><g>3.1415</g><h>Two</h><h>Parts</h></b>'
			+ '</a>';

	private static final String MAIN_TAG_XML = '<MainTag>'
			+ '	<Envelope>'
			+ '		<senderIdentification>' + TEST_SENDER_IDENTIFICATION + '</senderIdentification>'
			+ '		<receiverIdentification>' + TEST_RECEIVER_IDENTIFICATION + '</receiverIdentification>'
			+ '		<messageType>' + TEST_MESSAGE_TYPE + '</messageType>'
			+ '		<messageVersion>' + TEST_MESSAGE_VERSION + '</messageVersion>'
			+ '		<envelopeIdentification></envelopeIdentification>'
			+ '	</Envelope>'
			+ '	<Message>'
			+ '		<Header>'
			+ '			<testHeader>TestHead</testHeader>'
			+ '		</Header>'
			+ '		<Line>'
			+ '			<testLine>Test Line</testLine>'
			+ '		</Line>'
			+ '	</Message>'
			+ '</MainTag>';


	@IsTest
	public static void testParseDocumentToObjectShouldBeAbleToParseElementsToCorrectTypes() {
		// Arrange
		Dom.Document doc = new Dom.Document();
		doc.load(HELLO_WORLD_XML);

		// Act
		A result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = (A) PARSER_UNDER_TEST.parseDocumentToObject(doc, A.class);
		}
		Test.stopTest();

		// Assert
		System.assertNotEquals(null, result);
		System.assertNotEquals(null, result.b);
		for (Integer i = 0; i != 2; i++) {
			System.assertNotEquals(null, result.b[i].c);
			System.assertNotEquals(null, result.b[i].d);
			System.assertNotEquals(null, result.b[i].e);
			System.assertNotEquals(null, result.b[i].f);
			System.assertNotEquals(null, result.b[i].g);
			System.assertNotEquals(null, result.b[i].h);
		}
	}

	@IsTest
	public static void testParseDocumentToObjectCanBeControlledToForceMemberElementsToStrings() {
		// Arrange
		Dom.Document doc = new Dom.Document();
		doc.load(MAIN_TAG_XML);
		String testReplacementForNull = '!$!';

		X2O_ParserConfig testParserConfig = new X2O_ParserConfig(MainTag.class)
				.setForcedStringElementNameList(new List<String>{
						'senderIdentification'
				})
				.setReplacementForNull(testReplacementForNull);

		// Act
		MainTag result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = (MainTag) PARSER_UNDER_TEST.parseDocumentToObject(testParserConfig, doc);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_SENDER_IDENTIFICATION, result.envelope.senderIdentification);
		System.assertEquals(TEST_RECEIVER_IDENTIFICATION, result.envelope.receiverIdentification);
		System.assertEquals(TEST_MESSAGE_TYPE, result.envelope.messageType);
		System.assertEquals(TEST_MESSAGE_VERSION, result.envelope.messageVersion);
		System.assertEquals(testReplacementForNull, result.envelope.envelopeIdentification);
	}

	@IsTest
	public static void testParseShouldPopulateReceiptConfirmationModelCorrectly() {
		// Arrange
		Dom.Document testDocument = new Dom.Document();
		testDocument.load(KN_ReceiptConfirmationExtDocumentMock.SAMPLE_DOCUMENT);

		X2O_ParserConfig testParserConfig
				= new X2O_ParserConfig(KN_RC_ReceiptConfirmationExt.class)
						.setForcedCollectionElementNameList(TEST_FORCE_COLLECTION_ELEMENT_LIST)
						.setForcedStringElementNameList(TEST_FORCE_STRING_VALUE_ELEMENT_LIST);

		// Act
		KN_RC_ReceiptConfirmationExt resultModel;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultModel = (KN_RC_ReceiptConfirmationExt) PARSER_UNDER_TEST.parseDocumentToObject (testParserConfig, testDocument);
		}
		Test.stopTest();

		// Assert
		List<String> eanCodeList = new List<String>(resultModel.eanCodeSet);
		String eanCode = eanCodeList[0];
		System.assertEquals(KN_ReceiptConfirmationExtDocumentMock.TEST_MESSAGE_HEADER_ORDER_INFORMATION_CLIENT_ORDER_REFERENCE, resultModel.clientOrderReference);
		System.assertEquals(KN_ReceiptConfirmationExtDocumentMock.TEST_MESSAGE_LINE_INFORMATION_ARTICLE_DESCRIPTION_2, eanCode);
	}

	class A {
		public B[] b;
	}

	class B {
		public String c;
		public Date d;
		public Datetime e;
		public Boolean f;
		public Decimal g;
		public String[] h;
	}

	class MainTag {
		Envelope envelope;
	}

	class Envelope {
		String senderIdentification;
		Integer receiverIdentification;
		String messageType;
		Decimal messageVersion;
		String envelopeIdentification;
	}
}