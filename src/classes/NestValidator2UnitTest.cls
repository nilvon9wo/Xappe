@IsTest
public with sharing class NestValidator2UnitTest {
    private static final NestValidator2 VALIDATOR_UNDER_TEST = new NestValidator2();

    @IsTest
    public static void testIsValid0() {
        Boolean isExpected = true;
        testIsValid('', isExpected);
    }

    @IsTest
    public static void testIsValid1() {
        Boolean isExpected = true;
        testIsValid('{}', isExpected);
    }
    @IsTest
    public static void testIsValid2() {
        Boolean isExpected = true;
        testIsValid('[]', isExpected);
    }
    @IsTest
    public static void testIsValid3() {
        Boolean isExpected = true;
        testIsValid('()', isExpected);
    }
    @IsTest
    public static void testIsValid4() {
        Boolean isExpected = true;
        testIsValid('{[()]}', isExpected);
    }

    @IsTest
    public static void testIsValid5() {
        Boolean isExpected = true;
        testIsValid('{()[]}', isExpected);
    }

    @IsTest
    public static void testIsValid6() {
        Boolean isExpected = true;
        testIsValid('{()[()]}', isExpected);
    }

    @IsTest
    public static void testIsValid7() {
        Boolean isExpected = true;
        testIsValid('(){()[]}', isExpected);
    }

    @IsTest
    public static void testIsValid8() {
        Boolean isExpected = true;
        testIsValid('{[()]}a', isExpected);
    }

    @IsTest
    public static void testIsInValid1() {
        Boolean isExpected = false;
        testIsValid(')', isExpected);
    }

    @IsTest
    public static void testIsInValid2() {
        Boolean isExpected = false;
        testIsValid('[)', isExpected);
    }


    @IsTest
    public static void testIsInValid3() {
        Boolean isExpected = false;
        testIsValid('{[()]]', isExpected);
    }

    @IsTest
    public static void testIsInvalid4() {
        Boolean isExpected = false;
        testIsValid('{[()]}(', isExpected);
    }

    private static void testIsValid(String input, Boolean isExpected) {
        System.assertEquals(isExpected, VALIDATOR_UNDER_TEST.isValid(input));
    }
}