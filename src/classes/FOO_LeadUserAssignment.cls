public class FOO_LeadUserAssignment implements XAP_TRIG_TriggerEventHandlerIntf {
    DAO_FooSelector fooSelector;

    private FOO_LeadUserAssignment(DAO_FooSelector fooSelector) {
        this.fooSelector = fooSelector;
    }

    private FOO_LeadUserAssignment() {
        this(DAO_FooSelector.getInstance());
    }

    public XAP_TRIG_TriggerEventHandlerIntf handle(XAP_TRIG_TriggerProperties triggerProperties) {
        Set<String> customField1Set = triggerProperties.collectNonBlankStringSetForNew(Lead.Custom_Field_1__c);
        Set<String> customField2Set = triggerProperties.collectNonBlankStringSetForNew(Lead.Custom_Field_2__c);
        Set<String> customField3Set = triggerProperties.collectNonBlankStringSetForNew(Lead.Custom_Field_3__c);

        List<Foo__c> fooList = this.fooSelector.selectByCustomFields(customField1Set, customField2Set, customField3Set);
        Map<String, Foo__c> fooByKeyMap = this.buildFooByKeyMap(fooList);

        for (Lead lead : (List<Lead>) triggerProperties.newSObjectList) {
            lead.Foo_User__c = fooByKeyMap.get(this.makeKey(lead)).User__c;
        }

        return this;
    }

    private Map<String, Foo__c> buildFooByKeyMap(List<Foo__c> fooList) {
        Map<String, Foo__c> fooByKeyMap = new Map<String, Foo__c>();
        for (Foo__c foo : fooList) {
            fooByKeyMap.put(this.makeKey(foo), foo);
        }
        return fooByKeyMap;
    }

    private String makeKey(SObject sObj) {
        return '[[['
                + sObj.get('Custom_Field_1__c')
                + ':::' + sObj.get('Custom_Field_2__c')
                + ':::' + sObj.get('Custom_Field_3__c')
                + ']]]';
    }
}