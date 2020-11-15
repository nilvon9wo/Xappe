public with sharing class XAP_DTM_DateTimeWrapper {
    @TestVisible
    public transient Datetime now {
        get {
            if (this.now == null) {
                this.now = Datetime.now();
            }
            return this.now;
        }
        private set;
    }

    @TestVisible
    public transient Datetime dateGmt {
        get {
            if (this.dateGmt == null) {
                this.dateGmt = this.now.dateGmt();
            }
            return this.dateGmt;
        }
        private set;
    }

    @TestVisible
    public transient Date today {
        get {
            if (this.today == null) {
                this.today = this.now.date();
            }
            return this.today;
        }
        private set;
    }
}