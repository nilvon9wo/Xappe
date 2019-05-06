@IsTest
private class TrailshredControllerTest {

    @IsTest
    static void test_get_settings() {

        TrailshredController.mockSettings = new List<Trailshred_Setting__mdt>{
            (Trailshred_Setting__mdt) getMetadata( Trailshred_Setting__mdt.SObjectType, new Map<String, Object>{
                'Active__c' => true,
                'Audio_Static_Resource_Path__c' => 'sounds/example.mp3',
                'Object_Name__c' => 'Account',
                'Field_Name__c' => 'Rating',
                'Field_Value__c' => 'Hot'
            })
        };

        Test.startTest();

        List<Trailshred_Setting__mdt> settings = TrailshredController.getSettings( 'Account' );
        System.assertEquals( 1, settings.size() );

        System.assertEquals( true, settings[0].Active__c );
        System.assertEquals( 'sounds/example.mp3', settings[0].Audio_Static_Resource_Path__c );
        System.assertEquals( 'Account', settings[0].Object_Name__c );
        System.assertEquals( 'Rating', settings[0].Field_Name__c );
        System.assertEquals( 'Hot', settings[0].Field_Value__c );

        Test.stopTest();

    }

    private static SObject getMetadata( SObjectType objType, Map<String, Object> fields ) {
        Map<String, Object> jsonFields = new Map<String, Object> {
            'attributes' => new Map<String, Object> {
                'type' => objType.getDescribe().getName()
            }
        };
        if ( fields != null ) {
            jsonFields.putAll( fields );
        }
        return (SObject) JSON.deserialize( JSON.serialize( jsonFields ), SObject.class );
    }

}