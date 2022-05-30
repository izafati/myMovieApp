public with sharing class MovieIsReleasedCheckBatch implements Database.Batchable<sObject> {
    private Database.SaveResult [] updateResults;
    //start
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, IsReleased__c, Release_date__c FROM Movie__c]);
    }

    //execute
    public void execute(Database.BatchableContext bc, List<Movie__c> movieList) {
        if(movieList!=null && !movieList.isEmpty()) {
            for(Movie__c movie: movieList) {
                movie.IsReleased__c = movie.Release_date__c <= System.today();
            }
            updateResults = Database.update(movieList, false);
        }
    }

    //finish
    public void finish(Database.BatchableContext bc) {
        if(updateResults != null){
            Log.error(updateResults);
        }
    }
}
