//noinspection ApexUnusedDeclaration
public with sharing class DAP_UserDataEnvelope {
    public List<DAP_UserInputDto> users { get; set; }
    public Integer countAtSource { get; set; }
    public Integer pageNumber { get; set; }
    public Integer maxRecordsOnPage { get; set; }
}