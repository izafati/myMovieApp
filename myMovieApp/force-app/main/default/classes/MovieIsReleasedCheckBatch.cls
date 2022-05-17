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
        for (Database.SaveResult updateResult : updateResults) {
            if (updateResult.isSuccess()) {
                System.debug('Successfully update movie. Movie ID: ' + updateResult.getId());
            }
            else {
                for(Database.Error err : updateResult.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Movie fields that affected this error: ' + err.getFields());
                }
            }
        System.debug('finished batch operations for movie isReleased field');
        }
    }
}
