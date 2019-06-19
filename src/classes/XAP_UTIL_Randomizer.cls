public virtual class XAP_UTIL_Randomizer {
	@TestVisible
	protected XAP_UTIL_Randomizer() {
	}

	private static XAP_UTIL_Randomizer instance;

	public static XAP_UTIL_Randomizer getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_Randomizer();
		}
		return instance;
	}

	private static final String CHARACTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	private static final Integer NUMBER_OF_POSSIBIITIES = CHARACTERS.length();

	// @see: http://www.codebycody.com/2012/02/sfdc-randomizer.html
	public virtual Integer getRandomNumber(Integer maxValue) {
		Integer size = maxValue + 1;
		Double randomDouble = Math.random() * size;
		return randomDouble.intValue();
	}

	// @see: // @see: http://www.codebycody.com/2012/02/sfdc-randomizer.html
	public virtual String getRandomString(Integer length) {
		String result = '';
		for (Integer i = 0; i < length; i++) {
			Integer random = this.getRandomNumber(NUMBER_OF_POSSIBIITIES - 1);
			result += CHARACTERS.substring(random, random + 1);
		}
		return result;
	}

	public virtual String getRandomShortAlphaNumeric() {
		Integer letterQuantity = 1;
		Integer maxValue = 999;
		return this.getRandomString(letterQuantity)
				+ this.getRandomNumber(maxValue);
	}
}