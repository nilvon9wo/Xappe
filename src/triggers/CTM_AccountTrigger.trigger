trigger CTM_AccountTrigger on Account (before insert, before update) {
	(new TRIG_AccountTriggerHandler()).invoke();
}    