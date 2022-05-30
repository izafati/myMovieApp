public with sharing class MovieIsReleasedCheckScheduler implements Schedulable{
    public MovieIsReleasedCheckScheduler() {

    }
    public void execute (SchedulableContext ctx) {
        MovieIsReleasedCheckBatch batch = new MovieIsReleasedCheckBatch();
        Id batchId = Database.executeBatch(batch, 10);
    }

}

