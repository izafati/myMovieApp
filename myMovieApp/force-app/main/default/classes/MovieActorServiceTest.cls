@IsTest
private class MovieActorServiceTest {
    
    @IsTest
    private static void shouldAddActorsToMovies(){
        
        Actor__c james= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'James',
            'Gender__c' => 'Male'});
        
        Actor__c tom= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'Tom',
            'Gender__c' => 'Male'});

        List<Id> actors = new List<Id>();
        actors.add(james.Id);
        actors.add(tom.Id);

        Movie__c bond007 = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
            'Name' => 'bond007',
            'Category__c' => 'Action',
            'Release_date__c' => date.newInstance(2023, 7, 15)});
        
        Test.startTest();
        MovieActorService.addActorsToMovie(bond007.Id, actors);
        List<MovieActor__c> movieActors = [SELECT Id, MD_to_Actors__c, MD_to_Movies__c FROM MovieActor__c];
        Test.stopTest();
        
        System.assertEquals(2, movieActors.size(), 'size is incorrect');
        System.assertEquals(james.Id, movieActors[0].MD_to_Actors__c, 'incorrect actor');
        System.assertEquals(tom.Id, movieActors[1].MD_to_Actors__c, 'incorrect actor');
        System.assertEquals(bond007.Id, movieActors[0].MD_to_Movies__c, 'incorrect movie');
        System.assertEquals(bond007.Id, movieActors[1].MD_to_Movies__c, 'incorrect movie');

    }

}
