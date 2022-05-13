public with sharing class MovieIsReleasedCheckBatch implements Database.Batchable<sObject> {
    //start
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, IsReleased__c, Release_date__c FROM Movie__c]);
    }

    //execute
    public void execute(Database.BatchableContext bc, List<Movie__c> movieList) {
        if(movieList.size() > 0) {
            for(Movie__c movie: movieList) {
                movie.IsReleased__c = movie.Release_date__c <= System.today();
            }
        }
    }

    //finish
    public void finish(Database.BatchableContext bc) {
        System.debug('finished batch operations for movie isReleased field');
    }
}
