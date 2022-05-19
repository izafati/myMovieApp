public with sharing class ActorController {

    @AuraEnabled(cacheable=true)
    public static List<Actor__c> getActors() {
        return [SELECT Id, Name FROM Actor__c WITH SECURITY_ENFORCED LIMIT 10];
    }
}
