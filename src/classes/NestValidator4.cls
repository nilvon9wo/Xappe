public class NestValidator4 {
    Map<String, CharacterHandlerIntf> handlerByCharacterMap;

    public NestValidator4(Map<String, CharacterHandlerIntf> handlerByCharacterMap) {
        this.handlerByCharacterMap = handlerByCharacterMap;
    }

    public NestValidator4() {
        this(DEFAULT_HANDLER_BY_CHARACTER_MAP);
    }

    private static final String OPEN_BRACE = '{';
    private static final String CLOSE_BRACE = '}';
    private static final String OPEN_BRACKET = '[';
    private static final String CLOSE_BRACKET = ']';
    private static final String OPEN_PARENTHESIS = '(';
    private static final String CLOSE_PARENTHESIS = ')';

    private static Map<String, CharacterHandlerIntf> DEFAULT_HANDLER_BY_CHARACTER_MAP {
        get {
            if (DEFAULT_HANDLER_BY_CHARACTER_MAP == null) {
                CharacterHandlerIntf openHandler = new OpenerHandler();
                CharacterHandlerIntf closeHandler = new CloserHandler();
                DEFAULT_HANDLER_BY_CHARACTER_MAP = new Map<String, CharacterHandlerIntf>{
                        OPEN_BRACE => openHandler,
                        OPEN_BRACKET => openHandler,
                        OPEN_PARENTHESIS => openHandler,
                        CLOSE_BRACE => closeHandler,
                        CLOSE_BRACKET => closeHandler,
                        CLOSE_PARENTHESIS => closeHandler
                };
            }
            return DEFAULT_HANDLER_BY_CHARACTER_MAP;
        }
        private set;
    }

    public Boolean isValid(String inputString) {
        List<String> unclosedOpenerList = new List<String>();
        for (String character : inputString.split('')) {
            CharacterHandlerIntf handler = this.handlerByCharacterMap.get(character);
            if (handler != null) {
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
            unclosedOpenerList.add(character);
            return unclosedOpenerList;
        }
    }

    private class CloserHandler implements CharacterHandlerIntf {
        private final Map<String, String> CLOSER_BY_OPENER_MAP = new Map<String, String>{
                OPEN_BRACE => CLOSE_BRACE,
                OPEN_BRACKET => CLOSE_BRACKET,
                OPEN_PARENTHESIS => CLOSE_PARENTHESIS
        };

        public List<String> handle(String character, List<String> unclosedOpenerList) {
            if (unclosedOpenerList.isEmpty()) {
                throw new UnexpectedCloserException('Found ' + character + ', No closers expected.');
            }

            Integer lastOpenerIndex = unclosedOpenerList.size() - 1;
            String nextExpectedCloser = this.CLOSER_BY_OPENER_MAP.get(unclosedOpenerList[lastOpenerIndex]);

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