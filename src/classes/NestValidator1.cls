public class NestValidator1 {
    private static final Map<String, String> CLOSER_BY_OPENER_MAP = new Map<String, String>{
            '(' => ')',
            '[' => ']',
            '{' => '}'
    };

    private final List<String> unclosedOpenerList = new List<String>();

    public Boolean isValid(String inputString) {
        for (String character : inputString.split('')) {
            if (CLOSER_BY_OPENER_MAP.keySet().contains(character)) {
                this.handleOpener(character);
            } else if (CLOSER_BY_OPENER_MAP.values().contains(character)) {
                try {
                    this.handleCloser(character);
                } catch (UnexpectedCloserException ex) {
                    return false;
                }
            }
        }
        return this.unclosedOpenerList.isEmpty();
    }

    private NestValidator1 handleOpener(String character) {
        unclosedOpenerList.add(character);
        return this;
    }

    private NestValidator1 handleCloser(String character) {
        if (this.unclosedOpenerList.isEmpty()) {
            throw new UnexpectedCloserException('Found ' + character + ', No closers expected.');
        }

        Integer lastOpenerIndex = this.unclosedOpenerList.size() - 1;
        String nextExpectedCloser = CLOSER_BY_OPENER_MAP.get(this.unclosedOpenerList[lastOpenerIndex]);

        if (!character.equals(nextExpectedCloser)) {
            throw new UnexpectedCloserException('Found ' + character + ', Next expected closer: ' + nextExpectedCloser);
        }

        this.unclosedOpenerList.remove(lastOpenerIndex);
        return this;
    }

    private class UnexpectedCloserException extends Exception {
    }
}