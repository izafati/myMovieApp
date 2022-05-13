trigger MovieTrigger on Movie__c (
        after insert
       , after update
       , after delete
       , after undelete) {
   new MovieTriggerHandler().run();
}