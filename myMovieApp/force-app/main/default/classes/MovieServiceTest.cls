@IsTest
private class MovieServiceTest {
    
    @TestSetup
    private static void setupData() {
        Movie__c bond007 = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
            'Name' => 'bond007',
            'Category__c' => 'Action',
            'Release_date__c' => date.newInstance(2023, 7, 15)});

        Movie__c uncharted = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
            'Name' => 'uncharted',
            'Category__c' => 'Action',
            'Release_date__c' => date.newInstance(2022, 7, 15)});
    }

    @IsTest
    private static void shouldFetchAllMoviesWhenSearchTermIsEmpty() {

        Test.startTest();
        List<Movie__c> movies = MovieService.fetchMoviesBySearchTerm('');
        Test.stopTest();
        System.assertEquals(2, movies.size(), 'Movie Size List is incorrect');
        System.assertEquals('bond007', movies[0].Name, 'Name is incorrect');
        System.assertEquals('uncharted', movies[1].Name, 'Name is incorrect');

    }

    @IsTest
    private static void shouldFetchMoviesBySearchTerm() {

        String searchTerm = 'bond';

        Movie__c bond007 = [SELECT Id, Name 
        FROM Movie__c
        WHERE Name = 'bond007' ];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = bond007.Id;

        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<Movie__c> movies = MovieService.fetchMoviesBySearchTerm(searchTerm);
        Test.stopTest();
        System.assertEquals(1, movies.size(), 'Movie Size List is incorrect');
        System.assertEquals('bond007', movies[0].Name, 'Name is incorrect');
    }

    @IsTest
    private static void shouldReturnEmptyResults() {

        String searchTerm = 'top gun';
        Boolean exceptionOccurred = false;

        try{
        Test.startTest();
        List<Movie__c> movies = MovieService.fetchMoviesBySearchTerm(searchTerm);
        Test.stopTest();
        } catch(AuraHandledException ex) {
            exceptionOccurred = true;
        }
        System.assertEquals(true, exceptionOccurred, 'Exception was not thrown');
    }

    @IsTest
    private static void shouldCreateMovie() {
        Actor__c james= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'James',
            'Gender__c' => 'Male'});
        List<Id> actors = new List<Id>{james.Id};
        
        Movie__c spiderman = new Movie__c(
            Name = 'spiderman',
            Category__c = 'Action',
            Release_date__c = date.newInstance(2021, 7, 15)
        ); 

        Test.startTest();
        MovieService.createMovie(spiderman, actors);
        spiderman = [SELECT Id, Name, 
        Category__c, Release_date__c
        FROM Movie__c
        WHERE Name = 'spiderman' ];
        Test.stopTest();
        System.assertEquals('spiderman', spiderman.Name, 'Movie Name is incorrect');
        System.assertEquals('Action', spiderman.Category__c, 'Movie Category is incorrect');
        System.assertEquals(date.newInstance(2021, 7, 15), spiderman.Release_date__c, 'Movie Release date is incorrect');

    }

    @IsTest
    private static void shouldUpdateMovie() {
        Movie__c bond007 = [SELECT Id, Name, Category__c 
        FROM Movie__c
        WHERE Name = 'bond007' ];

        System.assertEquals('Action', bond007.Category__c, 'Movie Category Is incorrect');
        Test.startTest();
        bond007.Category__c = 'Adventure';
        MovieService.updateMovie(bond007);
        Test.stopTest();
        System.assertEquals('Adventure', bond007.Category__c, 'Movie Category Is incorrect');

    }

    @IsTest
    private static void shouldRemoveMovie() {
        Movie__c bond007 = [SELECT Id, Name
        FROM Movie__c
        WHERE Name = 'bond007' ];
        Boolean exceptionOccurred = false;

        Test.startTest();
        MovieService.deleteMovie(bond007);
        Test.stopTest();

        try{
            bond007 = [SELECT Id, Name
            FROM Movie__c
            WHERE Name = 'bond007' ];
        } catch(QueryException ex) {
            exceptionOccurred = true;
            System.assertEquals('List has no rows for assignment to SObject', ex.getMessage(), 'incorrect exception message');
        }
        
        System.assertEquals(true, exceptionOccurred, 'Should throw query exception');

    }
}
