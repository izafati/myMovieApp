public with sharing class MovieService {
    public static List<Movie__c> fetchMoviesBySearchTerm(String searchTerm) {
        List<Movie__c> movies = new List<Movie__c>();
        if (String.isNotBlank(searchTerm)) {
            List<List<SObject>> searchResults = [
                FIND :searchTerm
                RETURNING Movie__c(
                    Id, Name, 
                    Category__c, Release_date__c, 
                    MaleActorsPercentage__c, FemaleActorsPercentage__c
                    ORDER BY Name
                    LIMIT 10
                )
            ];
            movies = searchResults[0];
        } else {
            movies = [SELECT Id, Name, Category__c, Release_date__c, MaleActorsPercentage__c, FemaleActorsPercentage__c
                    FROM Movie__c 
                    WITH SECURITY_ENFORCED LIMIT 10];
        }
        if(movies.isEmpty()) {
            throw new AuraHandledException('empty results');
        }
        return movies;
    }

    public static void createMovie(Movie__c movie, List<Id> actorIds) {
        try{
            if(AuthorizationUtil.isCreateable(Movie__c.SObjectType)){
                insert movie;
                MovieActorService.addActorsToMovie(movie.Id, actorIds);
            } else {
                System.debug('auth');
                throw new AuraHandledException('no access');
            }
        }catch (exception e){
            System.debug('no auth');
                Log.error(e.getMessage(), movie.Id);
                throw new AuraHandledException(e.getMessage());
        }
    }

    public static void updateMovie(Movie__c movie) {
        try{
            Update movie;
        }catch (exception e){
            Log.error(e.getMessage(), movie.Id);
        }
    }

    public static void deleteMovie(Movie__c movie) {
        try{
            Delete movie;
        }catch (exception e){
            Log.error(e.getMessage(), movie.Id);
        }
    }
}
