@IsTest
public class XAP_UTIL_RandomizerMock extends XAP_UTIL_Randomizer {
	public String returnedValue;
	public override String getRandomShortAlphaNumeric() {
		return this.returnedValue;
	}

}