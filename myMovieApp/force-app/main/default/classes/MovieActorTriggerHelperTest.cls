@IsTest
private class MovieActorTriggerHelperTest {
    
    @TestSetup
    private static void setupData() {

        Actor__c james= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'James',
            'Gender__c' => 'Male'});
        
        Actor__c tom= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
                'Name' => 'Tom',
                'Gender__c' => 'Male'});
        
        Actor__c jess = (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
                'Name' => 'Jess',
                'Gender__c' => 'Female'});

        Movie__c bond007 = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
            'Name' => 'bond007',
            'Category__c' => 'Action',
            'Release_date__c' => date.newInstance(2023, 7, 15)});

        Movie__c uncharted = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
                'Name' => 'uncharted',
                'Category__c' => 'Action',
                'Release_date__c' => date.newInstance(2022, 7, 15)});


        MovieActor__c bond007Tom = (MovieActor__c)TestDataFactory.createSObject('MovieActor__c', new Map<String,Object>{
            'MD_to_Actors__c' => tom.Id,
            'MD_to_Movies__c' => bond007.Id});

         MovieActor__c unchartedTom = (MovieActor__c)TestDataFactory.createSObject('MovieActor__c', new Map<String,Object>{
                'MD_to_Actors__c' => tom.Id,
                'MD_to_Movies__c' => uncharted.Id});
    }
    
    @IsTest
	private static void shouldUpdateNumberOfMovies() {
        
        Actor__c james = [SELECT Id, Number_of_movies__c FROM Actor__c WHERE Name = 'James' LIMIT 1];
        Actor__c tom = [SELECT Id, Number_of_movies__c FROM Actor__c WHERE Name = 'Tom' LIMIT 1];
        Movie__c bond007 = [SELECT Id FROM Movie__c WHERE Name = 'bond007' LIMIT 1];

   
        System.assertNotEquals(null, james, 'We do not have a valid actor for the test context.');
        System.assertNotEquals(null, tom, 'We do not have a valid actor for the test context.');
   
        System.assertNotEquals(null, bond007, 'We do not have a valid movie for the test context.');

        System.assertEquals(null, james.Number_of_movies__c, 'The number of movies is incorrect');
        System.assertEquals(2, tom.Number_of_movies__c, 'The number of movies is incorrect'); 

		Test.startTest();
        MovieActor__c bond007James = (MovieActor__c)TestDataFactory.createSObject('MovieActor__c', new Map<String,Object>{
                'MD_to_Actors__c' => james.Id,
                'MD_to_Movies__c' => bond007.Id});
        Test.stopTest();
        james = [SELECT Id, Number_of_movies__c FROM Actor__c WHERE Name = 'James' LIMIT 1];
		System.assertEquals(1, james.Number_of_movies__c, 'The number of movies is incorrect');
        System.assertEquals(2, tom.Number_of_movies__c, 'The number of movies is incorrect'); 
	}

    @IsTest
	private static void shouldCalculateGenderPercentage() {
        
        Actor__c jess = [SELECT Id, Gender__c FROM Actor__c WHERE Name = 'Jess' LIMIT 1];

        Movie__c uncharted = [SELECT Id, MaleActorsPercentage__c, FemaleActorsPercentage__c   FROM Movie__c WHERE Name = 'uncharted' LIMIT 1];

        System.assertNotEquals(null, jess, 'We do not have a valid actor for the test context.');
        System.assertNotEquals(null, uncharted, 'We do not have a valid movie for the test context.');

        System.assertEquals(100.0, uncharted.MaleActorsPercentage__c, 'The percentage of male actors is incorrect');
        System.assertEquals(0.0, uncharted.FemaleActorsPercentage__c, 'The percentage of female actors is incorrect');

		Test.startTest();
        MovieActor__c unchartedJess = new MovieActor__c(
                MD_to_Actors__c = jess.Id,
                MD_to_Movies__c = uncharted.Id
        );
        insert unchartedJess;
        Test.stopTest();

        uncharted = [SELECT Id, Name, MaleActorsPercentage__c, FemaleActorsPercentage__c  FROM Movie__c WHERE Name = 'uncharted' LIMIT 1];
        System.assertEquals(50.0, uncharted.MaleActorsPercentage__c, 'The percentage of male actors is incorrect');
        System.assertEquals(50.0, uncharted.FemaleActorsPercentage__c, 'The percentage of female actors is incorrect');

	}
}
