public with sharing class MovieController {

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> searchMovies(String searchTerm){
       return MovieService.fetchMoviesBySearchTerm(searchTerm);
    }

    @AuraEnabled
    public static void createMovie(Movie__c movie, List<Id> actorIds) {
        MovieService.createMovie(movie, actorIds);
    }

    @AuraEnabled
    public static void updateMovie(Movie__c movie) {
        MovieService.updateMovie(movie);
    }

    @AuraEnabled
    public static void deleteMovie(Movie__c movie) {
        MovieService.deleteMovie(movie);
    }
}
