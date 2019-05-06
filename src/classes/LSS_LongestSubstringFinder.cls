public class LSS_LongestSubstringFinder {
    private LSS_LongestSubstringFinder() {
    }

    private static LSS_LongestSubstringFinder instance;

    public static LSS_LongestSubstringFinder getInstance() {
        if (instance == null) {
            instance = new LSS_LongestSubstringFinder();
        }
        return instance;
    }


    public static String findSubstring(String inputString) {
        return getInstance().findLongestSubstring(inputString);
    }

    private String findLongestSubstring(String inputString) {
        Set<String> characterSet = new Set<String>();
        String longestOverAll = '';
        String longestTilNow = '';

        for (Integer inputCharacterIndex = 0; inputCharacterIndex < inputString.length(); inputCharacterIndex++) {
            String character = this.extractCharacterAt(inputString, inputCharacterIndex);

            if (characterSet.contains(character)) {
                longestTilNow = '';
                characterSet.clear();
            }

            longestTilNow += character;
            characterSet.add(character);
            if (longestTilNow.length() > longestOverAll.length()) {
                longestOverAll = longestTilNow;
            }
        }

        return longestOverAll;
    }

    public static Integer findLength(String inputString) {
        return getInstance().findLengthOfLongestSubstring(inputString);
    }

    private Integer findLengthOfLongestSubstring(String inputString) {
        Integer inputStringLength = inputString.length();
        Set<String> characterSet = new Set<String>();

        Integer subStringLength = 0;
        Integer leftCharacterIndex = 0;
        Integer rightCharacterIndex = 0;
        while (
                leftCharacterIndex < inputStringLength
                        && rightCharacterIndex < inputStringLength
                ) {
            String character = this.extractCharacterAt(inputString, rightCharacterIndex);
            if (!characterSet.contains(character)) {
                String nextCharacter = this.extractCharacterAt(inputString, rightCharacterIndex++);
                characterSet.add(nextCharacter);
                subStringLength = Math.max(subStringLength, rightCharacterIndex - leftCharacterIndex);
            } else {
                String earlierCharacter = this.extractCharacterAt(inputString, leftCharacterIndex++);
                characterSet.remove(earlierCharacter);
            }
        }
        return subStringLength;
    }

    private String extractCharacterAt(String inputString, Integer inputCharacterIndex) {
        return inputString.substring(inputCharacterIndex - 1, inputCharacterIndex);
    }
}