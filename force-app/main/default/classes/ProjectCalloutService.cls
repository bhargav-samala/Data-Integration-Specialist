public without sharing class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Post Opportunity To PMS')
	public static void postOpportunityToPMS(List<String> strId){
        Id oppId = strId[0];
        String st = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;

        Opportunity opp = [
            SELECT ID, Name, CloseDate, Amount, Account.Name, StageName  
            FROM opportunity 
            WHERE ID = :oppId
            WITH SECURITY_ENFORCED
        ];

        String jsonInput = '{\n' +
        ' "opportunityId" : "'+opp.Id+'",\n'+
        ' "opportunityName" : "'+opp.Name+'",\n'+
        ' "accountName" : "'+opp.Account.Name+'",\n'+
        ' "closeDate" : "'+String.ValueOf(opp.CloseDate).mid(0,10)+'",\n'+   
        ' "amount" : "'+opp.Amount+'"\n}';         
        
        System.enqueueJob(new QueueablePMSCall(st, jsonInput, opp));
    }
    class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private String st;
        private String jsonInput;
        private Opportunity opp;
        public QueueablePMSCall(String st, String jsonInput, Opportunity opp){
            this.st = st;
            this.jsonInput = jsonInput;
            this.opp = opp;
        }
        
        public void execute (QueueableContext context) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('token', this.st);
            request.setBody(this.jsonInput);
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 201){
                this.opp.StageName = 'Submitted Project';
            }
            else {
                this.opp.StageName = 'Resubmit Project';
            }
            update opp;
        }
    }
}