public virtual class XAP_ASYNC_Enqueuer {
    protected XAP_ASYNC_Enqueuer() {
    }

    private static XAP_ASYNC_Enqueuer instance;
    public static XAP_ASYNC_Enqueuer getInstance() {
        if (instance == null) {
            instance = new XAP_ASYNC_Enqueuer();
        }
        return instance;
    }

    public virtual Id enqueueJob(Queueable queueable) {
        return System.enqueueJob(queueable);
    }

    public virtual Id enqueueJob(String jobName, String cronExpression, Schedulable schedulable) {
        return System.schedule(jobName, cronExpression, schedulable);
    }
}