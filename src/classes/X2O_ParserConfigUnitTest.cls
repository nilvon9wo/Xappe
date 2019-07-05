@IsTest
public class X2O_ParserConfigUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final String SENDER_IDENTIFICATION = 'senderIdentification';

	@IsTest
	public static void testSetReplacementForNull() {
		// Arrange
		String testReplacementForNull = '!$!';

		//Act
		X2O_ParserConfig resultParserConfig;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultParserConfig = new X2O_ParserConfig(MainTag.class)
					.setReplacementForNull(testReplacementForNull);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(testReplacementForNull, resultParserConfig.replacementForNull);
	}

	@IsTest
	public static void testSetForcedStringElementNameList() {
		// Arrange
		// Nothing to do

		//Act
		X2O_ParserConfig resultParserConfig;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultParserConfig = new X2O_ParserConfig(MainTag.class)
					.setForcedStringElementNameList(new List<String>{
							SENDER_IDENTIFICATION
					});
		}
		Test.stopTest();

		// Assert
		System.assertEquals(SENDER_IDENTIFICATION, resultParserConfig.forcedStringElementNameList[0]);
	}

	@IsTest
	public static void testSetReplacementPropertyNameByElementNameMap() {
		// Arrange
		Map<String, String> testMap = new Map<String, String>{
				'KN' => 'ReceiptXML'
		};

		//Act
		X2O_ParserConfig resultParserConfig;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultParserConfig = new X2O_ParserConfig(MainTag.class)
					.setReplacementPropertyNameByElementNameMap(testMap);
		}
		Test.stopTest();

		// Assert
		System.assertEquals('ReceiptXML', resultParserConfig.replacementPropertyNameByElementNameMap.get('KN'));
	}

	@IsTest
	public static void testSetForcedCollectionElementNameList() {
		// Arrange
		// Nothing to do

		//Act
		X2O_ParserConfig resultParserConfig;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultParserConfig = new X2O_ParserConfig(MainTag.class)
					.setForcedCollectionElementNameList(new List<String>{
							SENDER_IDENTIFICATION
					});
		}
		Test.stopTest();

		// Assert
		System.assertEquals(SENDER_IDENTIFICATION, resultParserConfig.forcedCollectionElementNameList[0]);
	}

	class MainTag {
		Envelope envelope;
		Message message;
	}

	class Envelope {
		String senderIdentification;
	}

	class Message {
		String testMessage;
	}

}