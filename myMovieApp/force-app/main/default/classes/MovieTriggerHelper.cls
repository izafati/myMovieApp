public with sharing class MovieTriggerHelper {
    
    public static void updateNumberOfMovies(Map<Id, Movie__c> movieMap) {
        List<Actor__c> actorsToUpdate = new List<Actor__c>();
        Set<Id> movieIds = movieMap.keySet();

        for (AggregateResult movieActor : [SELECT MD_to_Actors__c, Count(MD_to_Movies__c) MoviesCount 
        FROM MovieActor__c 
        WHERE MD_to_Movies__c in: movieIds
        GROUP BY MD_to_Actors__c]) {
            Actor__c actor = new Actor__c();
            actor.Id = (Id) movieActor.get('MD_to_Actors__c'); 
            actor.Number_of_movies__c = (Integer) movieActor.get('MoviesCount');
            actorsToUpdate.add(actor);
        }

        try {
            update actorsToUpdate;
        } catch (DmlException e){
           Log.error('An execption was raised during updating actors ' + e.getMessage());
        }
    }

    public static void calculateGenderPercentage(Map<Id, Movie__c> movieMap){
        List<Movie__c> movies = new List<Movie__c>();
        Set<Id> movieIds = movieMap.keySet();

        for (AggregateResult movieActor : [SELECT Count(MD_to_Actors__c) actorCount, MD_to_Movies__c
        FROM MovieActor__c 
        WHERE MD_to_Movies__c in: movieIds
        GROUP BY MD_to_Movies__c]) {

            Integer totalActorsInMovie = (Integer) movieActor.get('actorCount');
            Id movieId = (Id) movieActor.get('MD_to_Movies__c'); 

            List<AggregateResult> maleActors = [Select Count(MD_to_Actors__c) actorCount
            FROM MovieActor__c 
            WHERE MD_to_Movies__c = :movieId
            AND MD_to_Actors__r.Gender__c = 'Male'];

            List<AggregateResult> femaleActors = [Select Count(MD_to_Actors__c) actorCount
            FROM MovieActor__c 
            WHERE MD_to_Movies__c = :movieId
            AND MD_to_Actors__r.Gender__c = 'Female'];

            Movie__c movie = new Movie__c();
            movie.Id = movieId;
            movie.MaleActorsPercentage__c = (Decimal) maleActors.get(0).get('actorCount') / totalActorsInMovie;
            movie.FemaleActorsPercentage__c = (Decimal) femaleActors.get(0).get('actorCount') / totalActorsInMovie;

            movies.add(movie);
        }
        try {
            update(movies);
        } catch (DmlException e){
            Log.error('An execption was raised during updating actors ' + e.getMessage());
         }
    }
}
