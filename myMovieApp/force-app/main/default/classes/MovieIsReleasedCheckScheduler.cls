public with sharing class MovieIsReleasedCheckScheduler implements Schedulable{
    public MovieIsReleasedCheckScheduler() {

    }
    public void execute (SchedulableContext ctx) {
        MovieIsReleasedCheckBatch batch = new MovieIsReleasedCheckBatch();
        Id batchId = Database.executeBatch(batch, 10);
    }

/*     SupplyQtyCheckScheduler scheduler = new SupplyQtyCheckScheduler();
    String cronExpression = '0 8 * * *';
    String jobId = System.schedule('Check and update isReleased field for movies', cronExpression, scheduler);
     */
}

