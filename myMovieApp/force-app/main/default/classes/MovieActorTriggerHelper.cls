public with sharing class MovieActorTriggerHelper {
    
    public static void updateNumberOfMovies(List<MovieActor__c> movieActorList) {
        List<Actor__c> actorsToUpdate = new List<Actor__c>();

        Set<Id> actorsIds = new Set<Id>();
        for(MovieActor__c movieActor : movieActorList) {
            actorsIds.add(movieActor.MD_to_Actors__c);
        }
       
        for (AggregateResult movieActor : [SELECT MD_to_Actors__c, Count(MD_to_Movies__c) MoviesCount 
        FROM MovieActor__c 
        WHERE MD_to_Actors__c in: actorsIds
        GROUP BY MD_to_Actors__c]) {
            Actor__c actor = new Actor__c();
            actor.Id = (Id) movieActor.get('MD_to_Actors__c'); 
            actor.Number_of_movies__c = (Integer) movieActor.get('MoviesCount');
            actorsToUpdate.add(actor);
        }

        try {
            update actorsToUpdate;
        } catch (DmlException e){
           System.debug('An execption was raised while updating actors ' + e.getMessage());
        }
    }

    public static void calculateGenderPercentage(List<MovieActor__c> movieActorList){
        List<Movie__c> movies = new List<Movie__c>();
        Set<Id> movieIds = new Set<Id>();
        for(MovieActor__c movieActor : movieActorList) {
            movieIds.add(movieActor.MD_to_Movies__c);
        }

        System.debug('movie ids calculate percent ' + movieIds);

        for (AggregateResult movieActor : [SELECT Count(MD_to_Actors__c) actorCount, MD_to_Movies__c
        FROM MovieActor__c 
        WHERE MD_to_Movies__c in: movieIds
        GROUP BY MD_to_Movies__c]) {

            Integer totalActorsInMovie = (Integer) movieActor.get('actorCount');
            Id movieId = (Id) movieActor.get('MD_to_Movies__c'); 

            AggregateResult maleActors = [Select Count(MD_to_Actors__c) actorCount
            FROM MovieActor__c 
            WHERE MD_to_Movies__c in: movieIds
            AND MD_to_Actors__r.Gender__c = 'Male'];

            AggregateResult femaleActors = [Select Count(MD_to_Actors__c) actorCount
            FROM MovieActor__c 
            WHERE MD_to_Movies__c in: movieIds
            AND MD_to_Actors__r.Gender__c = 'Female'];

            Movie__c movie = new Movie__c();
            movie.Id = movieId;
            movie.MaleActorsPercentage__c = (Decimal) maleActors.get('actorCount') / totalActorsInMovie * 100;
            movie.FemaleActorsPercentage__c = (Decimal) femaleActors.get('actorCount') / totalActorsInMovie * 100;

            System.debug(movie.MaleActorsPercentage__c);
            System.debug(movie.FemaleActorsPercentage__c);

            movies.add(movie);
        }
        try {
            update(movies);
        } catch (DmlException e){
            System.debug('An execption was raised while updating movies ' + e.getMessage());
         }
    }

}
