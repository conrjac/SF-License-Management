public class UserLicenseAllocationTriggerHelper {
    
    public UserLicenseAllocationTriggerHelper() {
      //  System.debug('Inside AccountTriggerHelper Constructor');
    }

    public void updateUserPoolAllocationField(List<UserLicenseAllocation__c> newUserLicenseAllocations)
    {
        Set<Id> usersInScope = new Set<Id>();
        
        For(UserLicenseAllocation__c allocation : newUserLicenseAllocations)
        {
            usersInScope.add(allocation.User__c);
        }
        
        Map<Id, Id> userToPoolMappingsForAllocations = userToPoolMappings(usersInScope);
        
        For(UserLicenseAllocation__c allocation : newUserLicenseAllocations)
        {
            allocation.AllocatedLicensePool__c = userToPoolMappingsForAllocations.get(allocation.User__c);
        }
    }
    
    private static Map<Id, Id> userToPoolMappings(Set<Id> usersInScope)
    {
        Map<Id, Id> userToPoolMappings = new Map<Id,Id>();

        List<UserPoolAllocation__c> allocations = [SELECT Id, User__c, LicensePool__c FROM UserPoolAllocation__c WHERE User__c IN :usersInScope];
        
        for(UserPoolAllocation__c allocation : allocations)
        {
            userToPoolMappings.put(allocation.User__c, allocation.LicensePool__c);
        }
        return userToPoolMappings;
    }
}