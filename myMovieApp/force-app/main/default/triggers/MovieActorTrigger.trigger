trigger MovieActorTrigger on MovieActor__c (
    after insert
   , after update
   , after delete) {
new MovieActorTriggerHandler().run();
}