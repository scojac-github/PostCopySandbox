public class BatchModifySandboxUserEmails implements Database.Batchable<SObject> {

    public Database.QueryLocator start( Database.BatchableContext scope ) {

        // Get Public Group
        Id sandboxUsersGroupId = [SELECT Id FROM Group WHERE Name = 'Sandbox Users'].Id;

        // Get all active users who are members of the Sandbox Users Public Group
        return Database.getQueryLocator([SELECT Id, Email FROM User WHERE IsActive = TRUE AND Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :sandboxUsersGroupId)]);
    }

    public void execute( Database.BatchableContext scope, List<User> users ) {

        // Remove '.invalid' from queried users email addresses
        for ( User u : users ) {
            u.Email = u.Email.replace('@example.com', '').replace('=', '@').removeEndIgnoreCase( '.invalid' );
        }
        update users;
    }

    public void finish( Database.BatchableContext scope ) {
        system.debug('***** BatchModifySandboxUserEmails is complete.');
    }
}