public with sharing class ActorService {
    public static List<Actor__c> getActors() {
        return [SELECT Id, Name, Gender__c FROM Actor__c WITH SECURITY_ENFORCED LIMIT 10];
    }
}
