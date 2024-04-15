public with sharing class DAP_UserOutputDto {
    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public String firstName {get; set;}
    @AuraEnabled
    public String lastName {get; set;}
}