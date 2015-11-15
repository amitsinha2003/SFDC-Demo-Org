/************************************************************************
 * Name  : ContactHandler
 * Author : Deloitte Consulting
 * Desc  : This is the handler class for Contact trigger    
 *
 * Modification Log:
 * ----------------------------------------------------------------------
 * Developer                    Date            Description
 * ----------------------------------------------------------------------
 * NSebastian@Deloitte         11/12/2015             Original Version
 * 
 *************************************************************************/

public with sharing class ContactHandler {
    // private Boolean isExecuting = false;
 //    private integer batchSize= 0;
        
//      /* Method Name: ContactHandler
//       * Author Name: NSebastian@Deloitte
//       * Description: This is the Constructor
//       * Parameters: 
//       * Returns:   NA
//       */
    // public ContactHandler(boolean isExecuting,integer batchSize) {
 //        this.isExecuting = isExecuting;
 //        this.batchSize = batchSize;
 //    }

//      /* Method Name: ContactHandler
//       * Author Name: NSebastian@Deloitte
//       * Description: This is the Constructor
//       * Parameters: 
//       * Returns:   NA
//       */
    // public ContactHandler() {        
 //    }
 
      /* Method Name: OnBeforeInsert
       * Author Name: NSebastian@Deloitte
       * Description: EXECUTE BEFORE INSERT LOGIC
       * Parameters: newcontactList
       * Returns:   void
       */
     public void OnBeforeInsert(Contact[] newcontactList) {
       	checkDuplicates(newcontactList[0]);

       
     }

 //     /* Method Name: OnAfterInsert
//       * Author Name: NSebastian@Deloitte
//       * Description: EXECUTE AFTER INSERT LOGIC
//       * Parameters: newcontactList, contactMap
//       * Returns:   void
//       */  
 //    public void OnAfterInsert(List<Contact> newcontactList, Map<ID, Contact> contactMap) {
        
 //    }    

//      /* Method Name: OnBeforeUpdate
//       * Author Name: NSebastian@Deloitte
//       * Description: EXECUTE BEFORE UPDATE LOGIC
//       * Parameters: oldcontactList, oldcontactMap, updatedcontactList, newcontactMap
//       * Returns:   void
//       */
 //    public void OnBeforeUpdate(List<Contact> oldcontactList,List<Contact> updatedcontactList, Map<ID, Contact> oldcontactMap, Map<ID, Contact> newcontactMap) {
 //    }
     
//      /* Method Name: OnAfterUpdate
//       * Author Name: NSebastian@Deloitte
//       * Description: EXECUTE AFTER UPDATE LOGIC
//       * Parameters: oldcontactList, updatedcontactList
//       * Returns:   void
//       */
 //    public void OnAfterUpdate(List<Contact> oldcontactList,List<Contact> updatedcontactList,  Map<ID, Contact> contactMap){
          
 //    }
    
//      /* Method Name: OnBeforeDelete
//       * Author Name: NSebastian@Deloitte
//       * Description: EXECUTE BEFORE DELETE LOGIC
//       * Parameters: contactsToDelete, contactMap
//       * Returns:   void
//       */
 //    public void OnBeforeDelete(List<Contact> contactsToDelete, Map<ID, Contact> contactMap) {
    
 //    }
     
//      /* Method Name: OnAfterDelete
//       * Author Name: NSebastian@Deloitte
//       * Description: EXECUTE AFTER DELETE LOGIC
//       * Parameters: deletedcontacts list, contactMap
//       * Returns:   void
//       */
 //    public void OnAfterDelete(List<Contact> deletedcontacts, Map<ID, Contact> contactMap){
    
 //    }
     
//      /* Method Name: OnUndelete
//       * Author Name: NSebastian@Deloitte
//       * Description: EXECUTE On UNDELETE LOGIC
//       * Parameters: restoredcontacts
//       * Returns:   void
//       */
 //    public void OnUndelete(List<Contact> restoredcontacts){
        
 //    }
    
    // ================================================
    //Methods

    /* Method Name: checkDuplicates
     * Author Name: NSebastian@Deloitte
     * Description: Check for duplicate Contact
     * Parameters: 
     * Returns:    void
     */
    public void checkDuplicates(Contact con) {
    	List<Contact> matchList = new List<Contact>();
    	List<CS_Duplicate_Check_Fields__c> cslist = [SELECT Source_Field__c, Target_Field__c FROM CS_Duplicate_Check_Fields__c WHERE
                                                        Source_Object__c = 'Contact' AND Target_Object__c = 'Contact' LIMIT 100];
        String query = 'select ';
        for(Schema.FieldSetMember fld: SObjectType.Contact.FieldSets.Duplicate_Record_fields_to_display.getFields()) {
            query += fld.getFieldPath() + ',';
        }

        query = query.removeEnd(',');
        System.debug('Check:query'+query);
        query += ' from Contact where ';
        for(CS_Duplicate_Check_Fields__c cs: cslist) {
            query += cs.Target_Field__c + '= :con.' + cs.Source_Field__c + ' and ';
        }
        query = query.removeEnd('and ');
        System.debug('Check:query'+query);
        System.debug('Check:con'+con);
        matchList = Database.query(query);
    	if(!matchList.isEmpty() && !con.Check_Error__c) {
       		con.Check_Error__c = true;
       	}
       	else {
       		con.Check_Error__c = false;
       	}
       	showWarning(con,matchList);
    }


    /* Method Name: showWarning
     * Author Name: NSebastian@Deloitte
     * Description: This method shows warning on the page when there is duplicate
     * Parameters: 
     * Returns:    void
     */
    public void showWarning(Contact con, List<Contact> matchList) {
    	if(con.Check_Error__c) {
    		con.addError('There are '+matchList.size()+' contact records matching your entry.');
    	}
    	//return
    }
    

    
}