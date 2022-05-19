public with sharing class MovieController {
    static List<MovieActor__c> movieActors;

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> searchMovies(String searchTerm){
        List<Movie__c> movies = new List<Movie__c>();
        if (String.isNotBlank(searchTerm)) {
            List<List<SObject>> searchResults = [
                FIND :searchTerm
                RETURNING Movie__c(
                    Id, Name, 
                    Category__c, Release_date__c 
                    ORDER BY Name
                    LIMIT 10
                )
            ];
            movies = searchResults[0];
        } else {
            movies = [SELECT Id, Name, Category__c, Release_date__c FROM Movie__c WITH SECURITY_ENFORCED LIMIT 10];
        }
        if(movies.isEmpty()) {
            throw new AuraHandledException('empty results');
        }
        return movies;
    }

    @AuraEnabled
    public static void createMovie(Movie__c movie, List<Id> actorIds) {
        try{
            if(AuthorizationUtil.isCreateable(Movie__c.SObjectType)){
                insert movie;
                MovieActorController.addActorsToMovie(movie.Id, actorIds);
            } else {
                throw new AuraHandledException('no access');
            }
        }catch (exception e){
                Log.error(e.getMessage(), movie.Id);
                throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateMovie(Movie__c movie) {
        try{
            Update movie;
        }catch (exception e){
            Log.error(e.getMessage(), movie.Id);
        }
    }

    @AuraEnabled
    public static void deleteMovie(Movie__c movie) {
        try{
            Delete movie;
        }catch (exception e){
            Log.error(e.getMessage(), movie.Id);
        }
    }
}
