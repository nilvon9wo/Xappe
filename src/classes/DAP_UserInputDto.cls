//noinspection ApexUnusedDeclaration
public with sharing class DAP_UserInputDto {
    public String id { get; set; }
    public String title { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String picture { get; set; }

    public DAP_UserOutputDto toOutputDto() {
        DAP_UserOutputDto outputDto = new DAP_UserOutputDto();
        outputDto.id = id;
        outputDto.firstName = firstName;
        outputDto.lastName = lastName;
        return outputDto;
    }
}