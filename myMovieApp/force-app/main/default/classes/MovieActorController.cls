public with sharing class MovieActorController {
    
    public static void addActorsToMovie(Id movieId, Set<Id> actorIds) {
        MovieActorService.addActorsToMovie(movieId, actorIds);
    }
}
