trigger GeneratePythonCode on JIRA__c (after insert, after update) {
    // Create a list to store the user stories
    List <JIRA__c> userStories = new List<JIRA__c>();
    
    // Loop through the inserted/updated stories
    for (JIRA__c story : Trigger.new) {
        // Check if the story is valid for python code generation
        if (story.Python_Code_Generation__c == true) {
            // Add the story to the list
            userStories.add(story);
        }
    }
    
    // Generate the python code
    GeneratePythonCode.generateCode(userStories);
}