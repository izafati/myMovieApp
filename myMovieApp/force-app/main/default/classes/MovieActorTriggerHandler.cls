public with sharing class MovieActorTriggerHandler extends TriggerHandler{
    private List<MovieActor__c> oldMovieActorList;
    private List<MovieActor__c>  newMovieActorList;
    private Map<Id, MovieActor__c> oldMovieActorMap;
    private Map<Id, MovieActor__c> newMovieActorMap;
  
   public MovieActorTriggerHandler() {
        oldMovieActorList = (List<MovieActor__c>) Trigger.old;
        newMovieActorList = (List<MovieActor__c>) Trigger.new;
        oldMovieActorMap = (Map<Id, MovieActor__c>) Trigger.oldMap;
        newMovieActorMap = (Map<Id, MovieActor__c>) Trigger.newMap;
   }
  
    protected override void afterInsert() {
        MovieActorTriggerHelper.updateNumberOfMovies(newMovieActorList);
        MovieActorTriggerHelper.calculateGenderPercentage(newMovieActorList);
   }

    
    protected override void afterDelete() {
        MovieActorTriggerHelper.updateNumberOfMovies(oldMovieActorList);
      } 
}
