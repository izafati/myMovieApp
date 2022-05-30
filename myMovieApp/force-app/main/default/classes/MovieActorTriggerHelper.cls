public with sharing class MovieActorTriggerHelper {

    private static String FEMALE = 'Female';
    private static String MALE = 'Male';

    
    public static void updateNumberOfMovies(List<MovieActor__c> movieActorList) {
        List<Actor__c> actorsToUpdate = new List<Actor__c>();

        Set<Id> actorsIds = new Set<Id>();
        for(MovieActor__c movieActor : movieActorList) {
            actorsIds.add(movieActor.MD_to_Actors__c);
        }

        for (Actor__c actor : [SELECT Id, Name, Number_of_movies__c, (Select Id FROM MovieActors__r) 
        FROM Actor__c
        WHERE Id IN :actorsIds
        WITH SECURITY_ENFORCED]){
                    actor.Number_of_movies__c = actor.MovieActors__r != null ? actor.MovieActors__r.size() : 0;
                    actorsToUpdate.add(actor);
            
        }
                Database.SaveResult[] saveResults = Database.update(actorsToUpdate, false);
                Log.error(saveResults);
    }

    public static void calculateGenderPercentage(List<MovieActor__c> movieActorList){
        List<Movie__c> movies = new List<Movie__c>();

        Set<Id> movieIds = new Set<Id>();
        for(MovieActor__c movieActor : movieActorList) {
            movieIds.add(movieActor.MD_to_Movies__c);
        }

        Map<Id,Integer> maleMoviesMap = new Map<Id,Integer>();
        Map<Id,Integer> femaleMoviesMap = new Map<Id,Integer>();

        List<AggregateResult> maleMovies = [SELECT   MD_to_Movies__c, Count(MD_to_Actors__c) actorCount
        FROM MovieActor__c
        WHERE MD_to_Movies__c in: movieIds 
        WITH SECURITY_ENFORCED
        GROUP By MD_to_Movies__c,MD_to_Actors__r.Gender__c
        HAVING MD_to_Actors__r.Gender__c =: MALE];
        convertToMap(maleMovies, maleMoviesMap);

        List<AggregateResult> femaleMovies = [SELECT   MD_to_Movies__c, Count(MD_to_Actors__c) actorCount
        FROM MovieActor__c
        WHERE MD_to_Movies__c in: movieIds 
        WITH SECURITY_ENFORCED
        GROUP By MD_to_Movies__c,MD_to_Actors__r.Gender__c
        HAVING MD_to_Actors__r.Gender__c =: FEMALE];
        convertToMap(femaleMovies, femaleMoviesMap);

        for(AggregateResult movieActor:[SELECT MD_to_Movies__c, Count(MD_to_Actors__c) actorCount
            FROM MovieActor__c
            WHERE MD_to_Movies__c in: movieIds 
            WITH SECURITY_ENFORCED
            GROUP By MD_to_Movies__c]) {
                Integer totalActorsInMovie = (Integer) movieActor.get('actorCount');
                if(totalActorsInMovie == null ){
                    totalActorsInMovie = 0;
                }
                Movie__c movie = new Movie__c();
                movie.Id = (Id) movieActor.get('MD_to_Movies__c');
                Decimal maleActorCount = (Decimal) maleMoviesMap.get(movie.Id);
                if(maleActorCount == null) {
                    maleActorCount = 0;
                }
                movie.MaleActorsPercentage__c = maleActorCount / totalActorsInMovie * 100;
                
                Decimal femaleActorCount = (Decimal) femaleMoviesMap.get(movie.Id);
                if( femaleActorCount == null ){
                    femaleActorCount = 0;
                }
                movie.FemaleActorsPercentage__c = femaleActorCount / totalActorsInMovie * 100;
                movies.add(movie);
            }

        Database.SaveResult[] saveResults = Database.update(movies, false);
        Log.error(saveResults);
        }

    private static void convertToMap(List<AggregateResult> movieActors , Map<Id, Integer> movieActorsMap) {
        for(AggregateResult movieActor : movieActors) {
            Integer movieCount = (Integer)movieActor.get('actorCount');
            if(movieCount == null ) {
                movieCount = 0;
            }
            movieActorsMap.put((Id) movieActor.get('MD_to_Movies__c') , movieCount);
        }
    }
   
}


