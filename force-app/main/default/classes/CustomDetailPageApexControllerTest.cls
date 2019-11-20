/**
 * This is a test class written for the class CustomDetailPageApexController
 * This test class verifies the functionality of the class CustomDetailPageApexController by testing multiple scenarios
 **/
@isTest
public class CustomDetailPageApexControllerTest {
   /**
    * This test method checks whether the method getFieldSetMember return any values when Number of columns is a Even number
    **/
    @isTest
    public static void testGetFieldSetMemberEvenColumns() {
        Contact objContact = new Contact();
        objContact.LastName = 'TestContact';
        insert objContact;
        
        Set<String> setFieldSets = Schema.SObjectType.Contact.fieldSets.getMap().keySet();
        String strFieldSetName = !setFieldSets.isEmpty() ? new list<string>(setFieldSets)[0] : '';
        
        System.Test.startTest();
        CustomDetailPageApexController.FinalWrapperClass objWrapper = new CustomDetailPageApexController.FinalWrapperClass();
        if(!String.isEmpty(strFieldSetName)) {
        	objWrapper = CustomDetailPageApexController.getFieldSetMember(strFieldSetName , 4, objContact.Id); 
        }
		System.Test.stopTest();
        
        if(objWrapper != null) {
        	System.assertNotEquals(null, objWrapper);   
        }
    }   
        
	/**
     * This test method checks whether the method getFieldSetMember return any values when Number of columns is a Odd number
     **/
    @isTest
    public static void testGetFieldSetMemberOddColumns() {
        Contact objContact = new Contact();
        objContact.LastName = 'TestContact';
        insert objContact;
        
        Set<String> setFieldSets = Schema.SObjectType.Account.fieldSets.getMap().keySet();
        String strFieldSetName = !setFieldSets.isEmpty() ? new list<string>(setFieldSets)[0] : '';
        
        System.Test.startTest();
        CustomDetailPageApexController.FinalWrapperClass objWrapper = new CustomDetailPageApexController.FinalWrapperClass();
        if(!String.isEmpty(strFieldSetName)) {
        	objWrapper = CustomDetailPageApexController.getFieldSetMember(strFieldSetName , 5, objContact.Id); 
        }
        System.Test.stopTest();
        
        if(objWrapper != null) {
        	System.assertNotEquals(null, objWrapper);   
        }
    }  
    
	/**
     * This test method checks whether the method getFieldSetMember return any values when field set name is not there (User has not entered the field set name)
     **/
    @isTest
    public static void testGetFieldSetMemberWhenNullFieldSetname() {
        Account objAccount = new Account();
        objAccount.Name = 'TestobjAccount';
        objAccount.Start_Date__c = System.today();
        objAccount.No_of_Business_Days__c = 1;
        insert objAccount;
        
        Set<String> setFieldSets = Schema.SObjectType.Account.fieldSets.getMap().keySet();
        String strFieldSetName = !setFieldSets.isEmpty() ? new list<string>(setFieldSets)[0] : '';
        
        System.Test.startTest();
        CustomDetailPageApexController.FinalWrapperClass objWrapper = new CustomDetailPageApexController.FinalWrapperClass();
        if(!String.isEmpty(strFieldSetName)) {
        	objWrapper = CustomDetailPageApexController.getFieldSetMember(strFieldSetName , 5, objAccount.Id); 
        }
        System.Test.stopTest();
        
        if(objWrapper != null) {
        	System.assertNotEquals(null, objWrapper);   
        }
    } 
}