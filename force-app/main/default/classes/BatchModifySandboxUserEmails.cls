public class BatchModifySandboxUserEmails implements Database.Batchable<SObject> {

    public Database.QueryLocator start( Database.BatchableContext scope ) {

        // Get all active Admins
        return Database.getQueryLocator( 'SELECT Id, Email FROM User WHERE isActive = TRUE AND Profile.Name = \'System Administrator\'' );
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