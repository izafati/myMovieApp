@IsTest
private class MovieReleasedCheckBatchTest {
    @TestSetup
    private static void setupData() {

        Movie__c bond007 = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
            'Name' => 'bond007',
            'Category__c' => 'Action',
            'Release_date__c' => date.today().addYears(2)});

        Movie__c uncharted = (Movie__c)TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
                'Name' => 'uncharted',
                'Category__c' => 'Action',
                'Release_date__c' => date.today().addYears(-2)});

    }

    @IsTest
    private static void shouldUpdateIsReleasedField(){
        Test.startTest();
        MovieIsReleasedCheckBatch movieIsReleasedCheckBatch = new MovieIsReleasedCheckBatch();
        Database.executeBatch(movieIsReleasedCheckBatch, 2);
        Test.stopTest();
        List<Movie__c> movies = [SELECT Id, Name, IsReleased__c FROM Movie__c WITH SECURITY_ENFORCED];
        System.assertEquals(False, movies[0].IsReleased__c, 'Is Released is correct');
        System.assertEquals(True, movies[1].IsReleased__c, 'Is Released is correct');
    }

}
