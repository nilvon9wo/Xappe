@IsTest
public class DAO_Product2SelectorIntTest {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final DAO_Product2Selector SELECTOR_UNDER_TEST = new DAO_Product2Selector();

    @IsTest public static void testSelectByIdShouldReturnValuesPerExampleFieldSet() {
        // Arrange
        String testName = 'CoolItem';
        String testDescription = 'Something cool';
        String testCode = 'PC235';
        Boolean testIsActive = true;
        Product2 testProduct = (Product2) new XFTY_DummySObjectSupplier(Product2.SObjectType)
                .setOverrideTemplate(new Product2(
                        Name = testName,
                        Description = testDescription,
                        ProductCode = testCode,
                        IsActive = testIsActive
                ))
                .setInsertMode(XFTY_InsertModeEnum.NOW)
                .supply();

        // Act
        List<Product2> resultList;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultList = SELECTOR_UNDER_TEST.selectById(new Set<Id>{
                    testProduct.Id
            });
        }
        Test.stopTest();

        // Assert
        System.assertEquals(1, resultList.size());

        Product2 resultProduct = resultList[0];
        System.assertEquals(testName, resultProduct.Name);
        System.assertEquals(testDescription, resultProduct.Description);
        System.assertEquals(testCode, resultProduct.ProductCode);
        System.assertEquals(testIsActive, resultProduct.IsActive);
    }

}