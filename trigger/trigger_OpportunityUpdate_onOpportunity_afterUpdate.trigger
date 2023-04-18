trigger OpportunityUpdate on Opportunity (after update) {
 
  // Get a list of accounts related to the updated opportunity
  Set<Id> accountIds = new Set<Id>();
  for (Opportunity opp : Trigger.new) {
    accountIds.add(opp.AccountId);
  }
 
  // Query for all opportunities related to the accounts
  List<Opportunity> opps = [SELECT Id, AccountId, CreatedDate, StageName FROM Opportunity
                           WHERE AccountId IN :accountIds];
 
  // Loop through each opportunity and check if it needs to be updated
  List<Opportunity> oppsToUpdate = new List<Opportunity>();
  Datetime thirtyDaysAgo = System.now().addDays(-30); 
  for (Opportunity opp : opps) {
    // Check if the opportunity is older than 30 days and not in Close Won
    if (opp.CreatedDate < thirtyDaysAgo && opp.StageName != 'Close Won') {
      opp.StageName = 'Close Lost';
      oppsToUpdate.add(opp);
    }
  }
 
  // Update the opportunities and log the changes in the system
  if (oppsToUpdate.size() > 0) {
    update oppsToUpdate;
    for (Opportunity opp : oppsToUpdate) {
      System.debug('Opportunity ' + opp.Id + ' was updated from ' + 
                   Trigger.oldMap.get(opp.Id).StageName + ' to ' + opp.StageName +
                   ' on ' + System.now());
    }
  }
}