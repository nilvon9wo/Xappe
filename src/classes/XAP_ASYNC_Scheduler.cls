public virtual class XAP_ASYNC_Scheduler {
    public virtual Id schedule(Schedulable schedulable, String jobName, String cronExpression) {
    	return System.schedule(jobName, cronExpression, schedulable);
    }
}