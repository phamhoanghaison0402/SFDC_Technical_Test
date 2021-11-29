trigger TriggerContactTest on Contact (after insert, after update, after delete) {
    if ( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        for (Contact c: Trigger.new) {

    		Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest(); 
    	    approvalRequest.setComments('Request submitted for approval'); 
    	    approvalRequest.setObjectId(c.Id); 

    	    Approval.ProcessResult approvalResult = Approval.process(approvalRequest);

    		List<Account> updatedAccountList=new List<Account>();

            if (c.Active__c == true){
                   for (Account a : [SELECT Id,Name,TotalContacts__c FROM Account
                                    WHERE Id=: c.AccountId]) {
        
                     if (a.TotalContacts__c == null){
                         a.TotalContacts__c = 0;
                     }    
                     a.TotalContacts__c = a.TotalContacts__c + 1;
                     updatedAccountList.add(a);
                }

                if(updatedAccountList.size() > 0){
                    Update updatedAccountList;
                } 
            }     
    	} 
    }
    
    if (Trigger.isDelete && Trigger.isAfter){
        for (Contact c: Trigger.old){
            if (c.Active__c == true){
                List<Account> updatedAccountList=new List<Account>();

                for (Account a : [SELECT Id,Name,TotalContacts__c FROM Account
                                 WHERE Id=: c.AccountId]) {
    
                    if (a.TotalContacts__c == null){
                         a.TotalContacts__c = 0;
                    }    

                    a.TotalContacts__c = a.TotalContacts__c - 1;
                    updatedAccountList.add(a);
                }

                if(updatedAccountList.size() > 0){
                    Update updatedAccountList;
                } 
                
            }    
        }
    }	
}