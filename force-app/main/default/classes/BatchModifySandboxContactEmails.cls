public class BatchModifySandboxContactEmails implements Database.Batchable<sObject> {
    
    Public Database.QueryLocator start(Database.BatchableContext batch) {

        // Exclude all contacts without email addresses and email addresses that are already modified
        String query = 'SELECT Id, Email FROM Contact WHERE Email != null AND (NOT Email LIKE \'%.invalid\') AND (NOT Email LIKE \'%.xyz\')';

        // Only run if the current instance is a sandbox or a test is running
        Boolean sandbox;
        for(Organization org : [SELECT isSandbox FROM Organization LIMIT 1]) {
            sandbox = org.isSandbox;
        }
        if(sandbox == TRUE){
        	return Database.getQueryLocator(query);
        } else if (Test.isRunningTest()){
        	return Database.getQueryLocator(query + ' limit 1');   
        } else {
            return Database.getQueryLocator(query + ' limit 0');
        }
    }

    Public void execute(Database.BatchableContext batch, List<sObject> scope){
        List<Contact> listContact = (List<Contact>) scope;
        List<Contact> listToUpdate = new List<Contact>();
        if(scope != null){
            for(Contact c : listContact) {
                c.Email = c.Email + '.invalid';
                listToUpdate.add(c);                    
            }
        }
        if(ListToUpdate.size() > 0) {
            //Update all eligible Contacts 
            database.update(listToUpdate,false);
        }
    }

    Public void finish(Database.BatchableContext batch) {
        system.debug('***** BatchModifySandboxContactEmails is complete.');
    }
}