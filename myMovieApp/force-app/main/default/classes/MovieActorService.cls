public with sharing class MovieActorService {
    public static void addActorsToMovie(Id movieId, List<Id> actorIds) {
        if(actorIds !=null && !actorIds.isEmpty()){
            List<MovieActor__c> movieActors = new List<MovieActor__c>();
            for(Id actorId: actorIds){
                MovieActor__c movieActor = new MovieActor__c();
                movieActor.MD_to_Movies__c = movieId;
                movieActor.MD_to_Actors__c = actorId;
                movieActors.add(movieActor);
            }
            Database.SaveResult[] saveResults = Database.insert(movieActors, false);
            Log.error(saveResults); 
        }
    }

    
}
