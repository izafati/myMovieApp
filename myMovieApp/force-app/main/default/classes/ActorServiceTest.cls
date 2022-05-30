@IsTest 
private class ActorServiceTest {
    
    @IsTest
    private static void shouldFetchActorsList(){
        Actor__c james= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'James',
            'Gender__c' => 'Male'});
        
        Actor__c tom= (Actor__c)TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
                'Name' => 'Tom',
                'Gender__c' => 'Male'});
        
        Test.startTest();
           List<Actor__c> actors = ActorService.getActors();
           System.assertEquals(2, actors.size(), 'list of actors size is incorrect');
           System.assertEquals('James', actors[0].Name, 'Name is incorrect');
           System.assertEquals('Male', actors[0].Gender__c, 'Gender is incorrect');
           System.assertEquals('Tom', actors[1].Name, 'Name is incorrect');
           System.assertEquals('Male', actors[1].Gender__c, 'Gender is incorrect');
        Test.stopTest();
    }
}
