public virtual class XAP_UTIL_UserInfoWrapper {
	@TestVisible public Id id { get; private set; }
	@TestVisible public String sessionId { get; private set; }

	public XAP_UTIL_UserInfoWrapper() {
		this.id = UserInfo.getUserId();
		this.sessionId = UserInfo.getSessionId();
	}
}