public with sharing class MovieTriggerHandler extends TriggerHandler {
    private List<Movie__c> oldMovieList, newMovieList;
    private Map<Id, Movie__c> oldMovieMap, newMovieMap;
  
   public MovieTriggerHandler() {
        oldMovieList = (List<Movie__c>) Trigger.old;
        newMovieList = (List<Movie__c>) Trigger.new;
        oldMovieMap = (Map<Id, Movie__c>) Trigger.oldMap;
        newMovieMap = (Map<Id, Movie__c>) Trigger.newMap;
   }
  
   protected override void afterInsert() {
        MovieTriggerHelper.updateNumberOfMovies(newMovieMap);
        MovieTriggerHelper.calculateGenderPercentage(newMovieMap);
   }

   protected override void afterUpdate() {
        MovieTriggerHelper.updateNumberOfMovies(newMovieMap);
        MovieTriggerHelper.calculateGenderPercentage(newMovieMap);
      }
    
    protected override void afterDelete() {
        MovieTriggerHelper.updateNumberOfMovies(newMovieMap);
        MovieTriggerHelper.calculateGenderPercentage(newMovieMap);
      }
}
