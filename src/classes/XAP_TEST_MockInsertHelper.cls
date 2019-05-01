@IsTest
public class XAP_TEST_MockInsertHelper {
	private static final Integer LENGTH_OF_SFDC_ID = 15;
	 
    private static Integer fakeCount = 0;

    public static List<SObject> addIds(List<SObject> sObjectList) {
        for (SObject sObj : sObjectList) {
        	addId(sObj);
        }
        return sObjectList;
    }
    
    public static SObject addId(SObject sObj) {
    	SObjectType sObjectType = sObj.getSObjectType();
    	String prefix = sObjectType.getDescribe().getKeyPrefix();
    	
        String uniquifier = String.valueOf(++fakeCount);
        sObj.Id = (Id) (prefix + '3E000000nPxz'.left(LENGTH_OF_SFDC_ID - 3 - uniquifier.length()) + uniquifier);
        return sObj; 
    }
}
