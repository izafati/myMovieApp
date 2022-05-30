@IsTest
private class MovieReleasedCheckSchedulerTest {
    @IsTest
    private static void shouldExecuteMovieReleasedScheduler() {
        Test.startTest();
        Movie__c bond007 = new Movie__c();
        bond007.Name = 'bond007';
        bond007.Category__c = 'Action';
        bond007.Release_date__c = System.Date.Today()+1;
        insert bond007;
        
        String CRON_EXP = '0 0 0 30 5 ? 2023';
        String jobId = System.schedule('MovieReleasedCheckSchedulerTest', CRON_EXP, new MovieIsReleasedCheckScheduler());
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        
        System.assertEquals(0, cronTrigger.TimesTriggered, 'Scheduler should not trigger'); 
        System.assertEquals('2023-05-30 00:00:00', String.valueOf(cronTrigger.NextFireTime), 'The next scheduled triggerd time for job is incorrect');   
        Test.stopTest();        

    }
}

