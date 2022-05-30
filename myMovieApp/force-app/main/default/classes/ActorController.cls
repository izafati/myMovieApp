public with sharing class ActorController {

    @AuraEnabled(cacheable=true)
    public static List<Actor__c> getActors() {
        return ActorService.getActors();
    }
}
