public class XAP_DAO_DatabaseResultWrapper {
	@testVisible public Boolean isSuccess {get; private set;} 
	@testVisible public List<Database.Error> errorList {get; private set;}
	@testVisible public List<String> errorMessageList {get; private set;}
	
    public XAP_DAO_DatabaseResultWrapper(Database.SaveResult saveResult) {
    	this(saveResult.isSuccess(), saveResult.getErrors());
    }

    public XAP_DAO_DatabaseResultWrapper(Database.DeleteResult deleteResult) {
    	this(deleteResult.isSuccess(), deleteResult.getErrors());
    }

    public XAP_DAO_DatabaseResultWrapper(Database.UpsertResult upsertResult) {
    	this(upsertResult.isSuccess(), upsertResult.getErrors());
    }

    @testVisible
    private XAP_DAO_DatabaseResultWrapper(Boolean isSuccess, List<Database.Error> errorList) {
    	this.isSuccess = isSuccess;
    	this.errorList = errorList;
    	this.errorMessageList = this.convert(errorList);
    } 
    
    @testVisible
    private XAP_DAO_DatabaseResultWrapper(Boolean isSuccess, List<String> errorMessageList) {
    	this.isSuccess = isSuccess;
    	this.errorMessageList = errorMessageList;
    } 
    
    @testVisible 
    private List<String> convert(List<Database.Error> errorList) {
    	List<String> errorMessageList = new List<String>();
		for (Database.Error error : errorList) {
	  		String errorMessage = (error instanceof Database.DuplicateError) 
	               ? ((Database.DuplicateError) error).getDuplicateResult().getErrorMessage()
	               : error.getMessage();
			errorMessageList.add(errorMessage);
		}
    	return errorMessageList;
    }
}