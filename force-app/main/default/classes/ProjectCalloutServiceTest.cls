@isTest
private class ProjectCalloutServiceTest {
    //Implement mock callout tests here
    @testSetup
    static void setup(){
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = 'ProjectServiceToken';
        token.Token__c = 'TestToken';
        insert token;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Test Opp';
        opp.Type = 'New Project';
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        opp.Amount = 100000;
        insert opp;
    }
    
    @isTest
    static void testSubmitted(){
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp'];
        for(Opportunity opp : opportunities){
            opp.StageName = 'Closed Won';
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        update opportunities;
        Test.stopTest();
        
        opportunities = [SELECT StageName FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals('Submitted Project', opportunities[0].StageName, 'Did not het submitted project');
    }
    @isTest
    static void testResubmit(){
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp'];
        for(Opportunity opp : opportunities){
            opp.StageName = 'Closed Won';
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        update opportunities;
        Test.stopTest();
        
        opportunities = [SELECT StageName FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals('Resubmit Project', opportunities[0].StageName, 'Did not het Resubmit project');
    }
}