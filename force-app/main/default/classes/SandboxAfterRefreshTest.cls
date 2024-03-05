@isTest
class SandboxAfterRefreshTest {

    @isTest
    static void testSandboxAfterRefresh() {

        Account testAcct = new Account(name = 'Test Account', Website = 'https://www.WEESandboxRefresh.com');
        insert testAcct;
        Contact testCon = new Contact(FirstName = 'Willy', LastName = 'Wonka', email = 'willy@wonka.org', accountId = testAcct.Id);
        insert testCon;

        List<Organization> org = ([SELECT Id FROM Organization LIMIT 1]);

        Test.startTest();
            Test.testSandboxPostCopyScript(new SandboxAfterRefresh(), org[0].Id, org[0].Id, 'TestSandbox');
        Test.stopTest();

        Contact c = [SELECT Email FROM Contact LIMIT 1];

        System.assert(c.Email.endsWith('.invalid'));
    }
}