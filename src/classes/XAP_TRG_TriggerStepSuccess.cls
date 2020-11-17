public with sharing class XAP_TRG_TriggerStepSuccess implements XAP_TRG_TriggerStepResultable {
    private XAP_TRG_TriggerContext context;

    public XAP_TRG_TriggerStepSuccess(XAP_TRG_TriggerContext context) {
        this.context = context;
    }

    public XAP_TRG_TriggerContext getContext() {
        return this.context;
    }

    public Boolean wasSuccess() {
        return true;
    }
}