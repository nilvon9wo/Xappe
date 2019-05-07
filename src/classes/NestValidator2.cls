public class NestValidator2 {
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

    private static Map<String, CharacterHandlerIntf> HANDLER_BY_CHARACTER_MAP {
        get {
            if (HANDLER_BY_CHARACTER_MAP == null) {
                CharacterHandlerIntf openHandler = new OpenerHandler();
                CharacterHandlerIntf closeHandler = new CloserHandler();
                HANDLER_BY_CHARACTER_MAP = new Map<String, CharacterHandlerIntf>{
                        OPEN_BRACE => openHandler,
                        OPEN_BRACKET => openHandler,
                        OPEN_PARENTHESIS => openHandler,
                        CLOSE_BRACE => closeHandler,
                        CLOSE_BRACKET => closeHandler,
                        CLOSE_PARENTHESIS => closeHandler
                };
            }
            return HANDLER_BY_CHARACTER_MAP;
        }
        private set;
    }

    public Boolean isValid(String inputString) {
        List<String> unclosedOpenerList = new List<String>();
        for (String character : inputString.split('')) {
            CharacterHandlerIntf handler = HANDLER_BY_CHARACTER_MAP.get(character);
            if (handler != null) {
                try {
                    handler.handle(character, unclosedOpenerList);
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
            unclosedOpenerList.add(character);
            return unclosedOpenerList;
        }
    }

    private class CloserHandler implements CharacterHandlerIntf {
        public List<String> handle(String character, List<String> unclosedOpenerList) {
            if (unclosedOpenerList.isEmpty()) {
                throw new UnexpectedCloserException('Found ' + character + ', No closers expected.');
            }

            Integer lastOpenerIndex = unclosedOpenerList.size() - 1;
            String nextExpectedCloser = CLOSER_BY_OPENER_MAP.get(unclosedOpenerList[lastOpenerIndex]);

            if (!character.equals(nextExpectedCloser)) {
                throw new UnexpectedCloserException('Found ' + character + ', Next expected closer: ' + nextExpectedCloser);
            }

            unclosedOpenerList.remove(lastOpenerIndex);
            return unclosedOpenerList;
        }
    }

    private class UnexpectedCloserException extends Exception {
    }
}