public without sharing class UserLicenseAllocationTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public UserLicenseAllocationTriggerHelper helper;
    public UserLicenseAllocationTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new UserLicenseAllocationTriggerHelper();
    }
    public void beforeInsert(List<UserLicenseAllocation__c> newUserLicenseAllocations) {
        helper.updateUserPoolAllocationField(newUserLicenseAllocations);
    }
    public void beforeUpdate(List<UserLicenseAllocation__c> oldUserLicenseAllocations, List<UserLicenseAllocation__c> newUserLicenseAllocations, Map<ID, SObject> oldUserLicenseAllocationMap, Map<ID, SObject> newUserLicenseAllocationMap) {
        helper.updateUserPoolAllocationField(newUserLicenseAllocations);
 
    }
    public void beforeDelete(List<UserLicenseAllocation__c> oldUserLicenseAllocations, Map<ID, SObject> oldUserLicenseAllocationMap) {
        // helper.doTask5();
        // helper.doTask1();
    }
    public void afterInsert(List<UserLicenseAllocation__c> newUserLicenseAllocations, Map<ID, SObject> newUserLicenseAllocationMap) {
        // helper.doTask2();
        // helper.doTask3();
    }
    public void afterUpdate(List<UserLicenseAllocation__c> oldUserLicenseAllocations, List<UserLicenseAllocation__c> newUserLicenseAllocations, Map<ID, SObject> oldUserLicenseAllocationMap, Map<ID, SObject> newUserLicenseAllocationMap) {
        // helper.doTask4();
        // helper.doTask5();
    }
    public void afterDelete(List<UserLicenseAllocation__c> oldUserLicenseAllocations, Map<ID, SObject> oldUserLicenseAllocationMap) {
        // helper.doTask3();
        // helper.doTask1();
    }
    public void afterUndelete(List<UserLicenseAllocation__c> newUserLicenseAllocations, Map<ID, SObject> newUserLicenseAllocationMap) {
        // helper.doTask4();
        // helper.doTask2();
    }
}