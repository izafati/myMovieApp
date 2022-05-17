public with sharing class MovieActorTriggerHelper {
    
    public static void updateNumberOfMovies(List<MovieActor__c> movieActorList) {
        List<Actor__c> actorsToUpdate = new List<Actor__c>();

        Set<Id> actorsIds = new Set<Id>();
        for(MovieActor__c movieActor : movieActorList) {
            actorsIds.add(movieActor.MD_to_Actors__c);
        }
        List<AggregateResult> movieActors = [SELECT MD_to_Actors__c, Count(MD_to_Movies__c) MoviesCount 
        FROM MovieActor__c 
        WHERE MD_to_Actors__c in: actorsIds
        WITH SECURITY_ENFORCED
        GROUP BY MD_to_Actors__c];

        if (Schema.sObjectType.Actor__c.fields.Number_of_movies__c.isUpdateable()) {
            for (AggregateResult movieActor : movieActors) {
                Actor__c actor = new Actor__c();
                actor.Id = (Id) movieActor.get('MD_to_Actors__c'); 
                actor.Number_of_movies__c = (Integer) movieActor.get('MoviesCount');
                actorsToUpdate.add(actor);
            }
            Database.SaveResult[] saveResults = Database.update(actorsToUpdate, false);
            Log.error(saveResults);
        }
    }

    public static void calculateGenderPercentage(List<MovieActor__c> movieActorList){
        List<Movie__c> movies = new List<Movie__c>();
        Set<Id> movieIds = new Set<Id>();
        for(MovieActor__c movieActor : movieActorList) {
            movieIds.add(movieActor.MD_to_Movies__c);
        }

        List<AggregateResult> movieActors = [SELECT Count(MD_to_Actors__c) actorCount, MD_to_Movies__c
        FROM MovieActor__c 
        WHERE MD_to_Movies__c in: movieIds
        WITH SECURITY_ENFORCED
        GROUP BY MD_to_Movies__c];
        
        if (Schema.sObjectType.Movie__c.fields.MaleActorsPercentage__c.isUpdateable() 
                && Schema.sObjectType.Movie__c.fields.FemaleActorsPercentage__c.isUpdateable() ) {
            for (AggregateResult movieActor : movieActors) {
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
    
                movies.add(movie);
            }
        Database.SaveResult[] saveResults = Database.update(movies, false);
        Log.error(saveResults);
        }
    }

}
