public with sharing class XAP_TRG_TriggerStepFailure {
    private XAP_TRG_TriggerContext context;
    private Exception ex;

    public XAP_TRG_TriggerStepFailure(XAP_TRG_TriggerContext context, Exception ex) {
        this.context = context;
        this.ex = ex;
    }

    public XAP_TRG_TriggerContext getContext() {
        return this.context;
    }

    public Exception getException() {
        return this.ex;
    }

    public Boolean wasSuccess() {
        return false;
    }
}