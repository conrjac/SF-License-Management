@IsTest
private class ObjectSyncTest {

@IsTest
private static void instantiateClass()
{
    ObjectSyncTest os = new ObjectSyncTest();
    Assert.isNotNull(os, 'Instantiating class should not return null');
}


}