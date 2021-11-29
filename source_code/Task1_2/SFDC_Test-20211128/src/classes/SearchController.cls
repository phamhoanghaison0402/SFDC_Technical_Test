public class SearchController {

    public SearchController() {
    }

    public String searchText { get;set; }

    public List<Account> accounts {get;set;}
    public List<Contact> contacts {get;set;}
    
    public class RecordResult 
    {
        public String RecordId { get;set; }
        public String RecordName { get;set; }
        public String RecordType { get;set; }
    }

    public List<RecordResult> recordResults {get;set;}
    public RecordResult currentRecord {get;set;}

    public void searchRecord(){
        accounts = new List<Account>();
        contacts = new List<Contact>();
        recordResults = new List<RecordResult>();

        if(String.isNotBlank(searchText)){
            String likeCondition = '%'+searchText+'%';

            accounts = [SELECT Id, Name 
                        FROM Account 
                        WHERE Name LIKE :likeCondition];

            for (Account a : accounts) {
                RecordResult res = new RecordResult();
                res.RecordId = a.Id;
                res.RecordName = a.Name;
                res.RecordType = 'Account';

                recordResults.add(res);
            }

            contacts = [SELECT Id, Name 
                        FROM Contact 
                        WHERE Name LIKE :likeCondition];

            for (Contact c : contacts) {
                RecordResult res = new RecordResult();
                res.RecordId = c.Id;
                res.RecordName = c.Name;
                res.RecordType = 'Contact';

                recordResults.add(res);
            }
        }
    }       

    public void getRecordById(){
        String recordId = Apexpages.currentPage().getParameters().get('id');
        String recordType = Apexpages.currentPage().getParameters().get('type');

        currentRecord = new RecordResult();

        if (recordType == 'Account'){
                Account a = new Account();
                a = [SELECT Id, Name FROM Account WHERE Id = :recordId];

                currentRecord.RecordId = a.Id;
                currentRecord.RecordName = a.Name;
                currentRecord.RecordType = 'Account';
        }
        else if (recordType == 'Contact') {
                Contact c = new Contact();
                c = [SELECT Id, Name FROM Contact WHERE Id = :recordId];

                currentRecord.RecordId = c.Id;
                currentRecord.RecordName = c.Name;
                currentRecord.RecordType = 'Contact';
        }
    }
}