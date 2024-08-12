@IsTest
private class UserLicenseAllocationTiggerHelperTest {
@IsTest
    private static void instantiateClass()
    {
        UserLicenseAllocationTriggerHelper ulath = new UserLicenseAllocationTriggerHelper();
        Assert.isNotNull(ulath, 'Instantiating class should not return null');
    }
}