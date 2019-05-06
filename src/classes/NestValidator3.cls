public class NestValidator3 {
    List<CharacterHandlerIntf> characterHandlerList;

    public NestValidator3(List<CharacterHandlerIntf> characterHandlerList) {
        this.characterHandlerList = characterHandlerList;
    }

    public NestValidator3() {
        this(new List<CharacterHandlerIntf>{
                new OpenerHandler(), new CloserHandler()
        });
    }

    private static final String OPEN_BRACE = '{';
    private static final String CLOSE_BRACE = '}';
    private static final String OPEN_BRACKET = '[';
    private static final String CLOSE_BRACKET = ']';
    private static final String OPEN_PARENTHESIS = '(';
    private static final String CLOSE_PARENTHESIS = ')';

    private static final Map<String, String> CLOSER_BY_OPENER_MAP = new Map<String, String>{
            OPEN_BRACE => CLOSE_BRACE,
            OPEN_BRACKET => CLOSE_BRACKET,
            OPEN_PARENTHESIS => CLOSE_PARENTHESIS
    };

    public Boolean isValid(String inputString) {
        List<String> unclosedOpenerList = new List<String>();
        for (String character : inputString.split('')) {
            for (CharacterHandlerIntf handler : this.characterHandlerList) {
                try {
                    unclosedOpenerList = handler.handle(character, unclosedOpenerList);
                } catch (UnexpectedCloserException ex) {
                    return false;
                }
            }
        }
        return unclosedOpenerList.isEmpty();
    }

    public interface CharacterHandlerIntf {
        List<String> handle(String character, List<String> unclosedOpenerList);
    }

    private class OpenerHandler implements CharacterHandlerIntf {
        public List<String> handle(String character, List<String> unclosedOpenerList) {
            if (CLOSER_BY_OPENER_MAP.keySet().contains(character)) {
                unclosedOpenerList.add(character);
            }
            return unclosedOpenerList;
        }
    }

    private class CloserHandler implements CharacterHandlerIntf {

        public List<String> handle(String character, List<String> unclosedOpenerList) {
            return (CLOSER_BY_OPENER_MAP.values().contains(character))
                    ? handleCloser(character, unclosedOpenerList)
                    : unclosedOpenerList;
        }

        private List<String> handleCloser(String closer, List<String> unclosedOpenerList) {
            if (unclosedOpenerList.isEmpty()) {
                throw new UnexpectedCloserException('Found ' + closer + ', No closers expected.');
            }

            Integer lastOpenerIndex = unclosedOpenerList.size() - 1;
            String nextExpectedCloser = CLOSER_BY_OPENER_MAP.get(unclosedOpenerList[lastOpenerIndex]);

            if (!closer.equals(nextExpectedCloser)) {
                throw new UnexpectedCloserException('Found ' + closer + ', Next expected closer: ' + nextExpectedCloser);
            }

            unclosedOpenerList.remove(lastOpenerIndex);
            return unclosedOpenerList;
        }
    }

    private class UnexpectedCloserException extends Exception {
    }
}