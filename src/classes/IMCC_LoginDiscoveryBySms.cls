public class IMCC_LoginDiscoveryBySms extends IMCC_LoginDiscoveryAbs {
    private static final String SMS_PATTERN = '^(\\+?\\d{1,2}?[\\s-])?(\\(?\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{4})$';

    public override IMCC_UserWrapper searchForUser(String value) {
        String formattedSms = this.getFormattedSms(value);
        return (!String.isBlank(formattedSms))
                ? super.searchForUser(formattedSms)
                : null;
    }

    private String getFormattedSms(String identifier) {
        Matcher smsMatcher = Pattern.compile(SMS_PATTERN)
                .matcher(identifier);

        String smsNumber;
        if (smsMatcher.matches()) {
            try {
                String countryCode = String.isBlank(smsMatcher.group(1))
                        ? '+1'
                        : smsMatcher.group(1);
                smsNumber = System.UserManagement.formatPhoneNumber(countryCode, smsMatcher.group(2));
            } catch (System.InvalidParameterValueException e) {
                // Deliberately swallowing exceptions; we will try some other strategy later;
            }
        }

        return smsNumber;
    }


    public override List<User> selectUsers(Set<String> valueSet) {
        return super.userSelector.selectByMobilePhone(valueSet);
    }

    public override Auth.VerificationMethod getVerificationMethod() {
        return Auth.VerificationMethod.SMS;
    }


}