public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Post Opportunity To PMS')
	public static void postOpportunityToPMS(List<String> strId){
        Id oppId = strId[0];
        Opportunity oppty = [
            SELECT ID, Name, CloseDate, Amount, Account.Name 
            FROM opportunity 
            WHERE ID = oppId
            WITH SECURITY_ENFORCED
        ];
        ({
            "opportunityId": "00641000004EKmFAAW",
            "opportunityName": "Super-Duper Big Deal",
            "accountName": "ACME Corp, Inc.",
            "closeDate": "2016-10-30",
            "amount": 150000
        });
        
    }
}