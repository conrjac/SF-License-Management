public with sharing class ObjectSync {
    
    public static void all()
    {
        // sync license, and assignment details
        license();
        licenseAssignment();
    }
    
    
    public static void license()
    {
        List<SalesforceLicense__c> SalesforceLicenses = new List<SalesforceLicense__c>();
        
        List<UserLicense> userlicenses = [SELECT Id, LicenseDefinitionKey, TotalLicenses, Status, UsedLicenses, UsedLicensesLastUpdated, Name, MasterLabel, MonthlyLoginsUsed, MonthlyLoginsEntitlement, CreatedDate, LastModifiedDate, SystemModstamp 
                                          FROM UserLicense];
        
        for(UserLicense ul : userLicenses)
        {
            SalesforceLicense__c sfLicense = new SalesforceLicense__c();
            sfLicense.Name = ul.Name;    
            sfLicense.SalesforceLicenseKey__c = ul.LicenseDefinitionKey;
            sfLicense.Type__c = 'User License';
            sfLicense.Status__c = ul.Status;
            sfLicense.TotalLicenses__c = ul.TotalLicenses;
            sfLicense.UsedLicenses__c = ul.UsedLicenses;
            sfLicense.SalesforceRecordId__c = ul.Id;
            
            SalesforceLicenses.add(sfLicense); 
        }
        
        List<PermissionSetLicense> permissionsetLicenses = [SELECT Id, UsedLicenses, IsSupplementLicense, LicenseExpirationPolicy, IsAvailableForIntegrations, MigratableLicenses, TotalLicenses, PermissionSetLicenseKey, Status, IsDeleted, DeveloperName, MasterLabel 
                                                            FROM PermissionSetLicense];
        
        for (PermissionSetLicense psl : permissionsetLicenses)
        {
            SalesforceLicense__c sfLicense = new SalesforceLicense__c();
            sfLicense.Name = psl.DeveloperName;    
            sfLicense.SalesforceLicenseKey__c = psl.PermissionSetLicenseKey;
            sfLicense.Type__c = 'Permission Set License';
            sfLicense.Status__c = psl.Status;
            sfLicense.TotalLicenses__c = psl.TotalLicenses;
            sfLicense.UsedLicenses__c = psl.UsedLicenses;
            sfLicense.SalesforceRecordId__c = psl.Id;
            
            SalesforceLicenses.add(sfLicense); 
        }
        upsert SalesforceLicenses SalesforceLicenseKey__c;
    }
    
    private static Map<String, String> allocatedLicenseIdToSalesforceLicenseIds(Set<String> allocatedLicenseIds )
    {
        Map<String, String> allocatedLicenseIdToSalesforceLicenseId = new Map<String, String>();
        List<SalesforceLicense__c> salesforceLicenses = [SELECT Id, SalesforceRecordId__c FROM SalesforceLicense__c WHERE SalesforceRecordId__c IN :allocatedLicenseIds];

        For(SalesforceLicense__c salesforceLicense : salesforceLicenses) allocatedLicenseIdToSalesforceLicenseId.put(salesforceLicense.SalesforceRecordId__c, salesforceLicense.Id);
        
        return allocatedLicenseIdToSalesforceLicenseId;
    }
    
    public static void licenseAssignment()
    {
        //     List<PermissionSetLicenseAssigment
        List<PermissionSetLicenseAssign> pslAssignments = [SELECT Id, AssigneeId, PermissionSetLicenseId FROM PermissionSetLicenseAssign WHERE AssigneeId IN (SELECT User__c FROM UserPoolAllocation__c)];
        List<User> users = [Select Id, Name, Profile.UserLicenseId From User WHERE isActive = True AND Id IN (SELECT User__c FROM UserPoolAllocation__c)];
        List<UserLicenseAllocation__c> ulas = new List<UserLicenseAllocation__c>();
        
        Set<string> allocatedLicenseIds = new Set<string>();
        For(PermissionSetLicenseAssign pslAssignment : pslAssignments)
        {
            allocatedLicenseIds.add(pslAssignment.PermissionSetLicenseId);
        }
        
        For(User u : users)
        {
            allocatedLicenseIds.add(u.Profile.UserLicenseId); 
        }
        
		Map<String, String> allocatedLicenseIdToSalesforceLicenseIdMap =  allocatedLicenseIdToSalesforceLicenseIds(allocatedLicenseIds);      

        For(PermissionSetLicenseAssign pslAssignment : pslAssignments)
        {
            UserLicenseAllocation__c ula = new UserLicenseAllocation__c();
            ula.UserLicenseAllocationKey__c =  pslAssignment.AssigneeId + '' + pslAssignment.PermissionSetLicenseId;
            
            ulas.add(ula);
        }
        
        For(User u : users)
        {
            // For all the users
            allocatedLicenseIds.add(u.Profile.UserLicenseId); 
            UserLicenseAllocation__c ula = new UserLicenseAllocation__c();

            string userAllocatedLicense = u.Profile.UserLicenseId;
            ula.UserLicenseAllocationKey__c =  u.Id + '' + userAllocatedLicense;
            ula.User__c = u.Id;
            ula.License__c = allocatedLicenseIdToSalesforceLicenseIdMap.get(userAllocatedLicense);
            
            ulas.add(ula);
        }
        
        upsert ulas UserLicenseAllocationKey__c;
    }
}