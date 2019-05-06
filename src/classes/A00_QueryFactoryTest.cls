/**
 * Copyright (c) 2014, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@isTest
private class A00_QueryFactoryTest {

	@isTest
	static void fieldSelections(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('firstName');
		qf.addField(Schema.Contact.SObjectType.fields.lastName);
		qf.selectFields( new Set<String>{'acCounTId', 'account.name'} );
		qf.selectFields( new List<String>{'homePhonE','fAX'} );
		qf.selectFields( new List<Schema.SObjectField>{ Contact.Email, Contact.Title } );
		System.assertEquals(new Set<String>{
			'FirstName',
			'LastName',
			'AccountId',
			'Account.Name',
			'HomePhone',
			'Fax',
			'Email',
			'Title'},
			qf.getSelectedFields());
	}

	@isTest
	static void simpleFieldSelection() {
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('NAMe').selectFields( new Set<String>{'naMe', 'email'});
		String query = qf.toSOQL();
		System.assert( Pattern.matches('SELECT.*Name.*FROM.*',query), 'Expected Name field in query, got '+query);
		System.assert( Pattern.matches('SELECT.*Email.*FROM.*',query), 'Expected Name field in query, got '+query);
		qf.setLimit(100);
		System.assertEquals(100,qf.getLimit());
		System.assert( qf.toSOQL().endsWithIgnoreCase('LIMIT '+qf.getLimit()), 'Failed to respect limit clause:'+qf.toSOQL() );
	}

	@isTest
	static void simpleFieldCondition(){
		String whereClause = 'name = \'test\'';
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		qf.addField('email');
		qf.setCondition( whereClause );
		System.assertEquals(whereClause,qf.getCondition()); 
		String query = qf.toSOQL();
		System.assert(query.endsWith('WHERE name = \'test\''),'Query should have ended with a filter on name, got: '+query);
	}

	@isTest
	static void duplicateFieldSelection() {
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('NAMe').selectFields( new Set<String>{'naMe', 'email'});
		String query = qf.toSOQL();
		System.assertEquals(1, query.countMatches('Name'), 'Expected one name field in query: '+query );
	}

	@isTest
	static void equalityCheck(){
		A00_QueryFactory qf1 = new A00_QueryFactory(Contact.SObjectType);
		A00_QueryFactory qf2 = new A00_QueryFactory(Contact.SObjectType);
		System.assertEquals(qf1,qf2);
		qf1.addField('name');
		System.assertNotEquals(qf1,qf2);
		qf2.addField('NAmE');
		System.assertEquals(qf1,qf2);
		qf1.addField('name').selectFields( new Set<String>{ 'NAME', 'name' }).selectFields( new Set<Schema.SObjectField>{ Contact.Name, Contact.Name} );
		System.assertEquals(qf1,qf2);
	}

	@isTest
	static void nonReferenceField(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		A00_QueryFactory.NonReferenceFieldException e;
		try{
			qf.addField('name.title');
		}catch(A00_QueryFactory.NonReferenceFieldException ex){
			e = ex;
		}
		System.assertNotEquals(null,e,'Cross-object notation on a non-reference field should throw NonReferenceFieldException.');
	}

	@isTest
	static void invalidCrossObjectField(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		A00_QueryFactory.InvalidFieldException e;
		try{
			qf.addField('account.NOT_A_REAL_FIELD');
		}catch(A00_QueryFactory.InvalidFieldException ex){
			e = ex;
		}
		System.assertNotEquals(null,e,'Cross-object notation on a non-reference field should throw NonReferenceFieldException.');
	}

	@isTest
	static void invalidFieldTests(){
		List<A00_QueryFactory.InvalidFieldException> exceptions = new List<A00_QueryFactory.InvalidFieldException>();
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		try{
			qf.addField('Not_a_field');
		}catch(A00_QueryFactory.InvalidFieldException e){
			exceptions.add(e);
		}
		try{
			qf.selectFields( new Set<String>{ 'Not_a_field','alsoNotreal'});
		}catch(A00_QueryFactory.InvalidFieldException e){
			exceptions.add(e);
		}
		try{
			qf.selectFields( new Set<Schema.SObjectField>{ null });
		}catch(A00_QueryFactory.InvalidFieldException e){
			exceptions.add(e);
		}
		try{
			qf.selectFields( new List<Schema.SObjectField>{ null, Contact.title });
		}catch(A00_QueryFactory.InvalidFieldException e){
			exceptions.add(e);
		}
		System.assertEquals(4,exceptions.size());
	}

	@isTest
	static void ordering(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		qf.addField('email');
		qf.setCondition( 'name = \'test\'' );
		qf.addOrdering( new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) ).addOrdering( new A00_QueryFactory.Ordering('Contact','CreatedDATE', A00_QueryFactory.SortOrder.DESCENDING) );
		String query = qf.toSOQL();

		System.assertEquals(2,qf.getOrderings().size());
		System.assertEquals('Name',qf.getOrderings()[0].getField() );
		System.assertEquals(A00_QueryFactory.SortOrder.DESCENDING,qf.getOrderings()[1].getDirection() );

		
		System.assert( Pattern.matches('SELECT.*Name.*FROM.*',query), 'Expected Name field in query, got '+query);
		System.assert( Pattern.matches('SELECT.*Email.*FROM.*',query), 'Expected Name field in query, got '+query);
	}

	@isTest
	static void setOrdering_ReplacesPreviousOrderingsWithExpectedOrdering(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		qf.addField('email');
		qf.setCondition( 'name = \'test\'' );

		//test base method with ordeting by OwnerId Descending
		qf.setOrdering( new A00_QueryFactory.Ordering('Contact','OwnerId', A00_QueryFactory.SortOrder.DESCENDING) );

		System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace default Orderings');
		System.assertEquals(Contact.OwnerId.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field OwnerId');
		System.assertEquals(A00_QueryFactory.SortOrder.DESCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

		//test method overload with ordering by LastModifiedDate Ascending
		qf.setOrdering('LastModifiedDate', A00_QueryFactory.SortOrder.ASCENDING, true);

		System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
		System.assertEquals(Contact.LastModifiedDate.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field LastModifiedDate');
		System.assertEquals(A00_QueryFactory.SortOrder.ASCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

		//test method overload with ordering by CreatedDate Descending
		qf.setOrdering(Contact.CreatedDate, A00_QueryFactory.SortOrder.DESCENDING, true);

		System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
		System.assertEquals(Contact.CreatedDate.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field CreatedDate');
		System.assertEquals(A00_QueryFactory.SortOrder.DESCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

		//test method overload with ordering by CreatedBy.Name Descending
		qf.setOrdering('CreatedBy.Name', A00_QueryFactory.SortOrder.DESCENDING);

		System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
		System.assertEquals(A00_QueryFactory.SortOrder.DESCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

		//test method overload with ordering by Birthdate Ascending
		qf.setOrdering(Contact.Birthdate, A00_QueryFactory.SortOrder.ASCENDING);

		System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
		System.assertEquals(Contact.Birthdate.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field Birthdate');
		System.assertEquals(A00_QueryFactory.SortOrder.ASCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

		String query = qf.toSOQL();
	}

	@isTest
	static void invalidField_string(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		Exception e;
		try{
			qf.addField('not_a__field');
		}catch(A00_QueryFactory.InvalidFieldException ex){
			e = ex;
		}
		System.assertNotEquals(null,e);
	}

	@isTest
	static void invalidFields_string(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		Exception e; 
		try{
			qf.selectFields( new List<String>{'not_a__field'} );
		}catch(A00_QueryFactory.InvalidFieldException ex){
			e = ex;
		}
		System.assertNotEquals(null,e);
	}

	@isTest
	static void invalidField_nullToken(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		Exception e;
		Schema.SObjectField token = null;
		try{
			qf.addField( token );
		}catch(A00_QueryFactory.InvalidFieldException ex){
			e = ex;
		}
		System.assertNotEquals(null,e);
	}

	@isTest
	static void invalidFields_nullToken(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		Exception e;
		List<Schema.SObjectField> token = new List<Schema.SObjectField>{
			null
		};
		try{
			qf.selectFields( token );
		}catch(A00_QueryFactory.InvalidFieldException ex){
			e = ex;
		}
		System.assertNotEquals(null,e);
	}

	@isTest
	static void invalidFields_noQueryField(){
		try {
			String path = A00_QueryFactory.getFieldTokenPath(null);
			System.assert(false,'Expected InvalidFieldException; none was thrown');
		} 
		catch (A00_QueryFactory.InvalidFieldException ife) {
			//Expected
		}
		catch (Exception e){
			System.assert(false,'Expected InvalidFieldException; ' + e.getTypeName() + ' was thrown instead: ' + e);
		}
	}

	@isTest
	static void queryFieldsNotEquals(){
		String qfld = A00_QueryFactory.getFieldTokenPath(Contact.Name);
		String qfld2 = A00_QueryFactory.getFieldTokenPath(Contact.LastName);
		System.assert(!qfld.equals(qfld2));	
	}

	@isTest
	static void addChildQueriesWithChildRelationship_success(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;

		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name').addField('Id').setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING, true);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		//explicitly assert object accessibility when creating the subselect
		qf.subselectQuery('Tasks', true).addField('Id').addField('Subject').setCondition(' IsDeleted = false ');
		List<A00_QueryFactory> queries = qf.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = Database.query(qf.toSOQL());
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@isTest
	static void addChildQueriesWithChildRelationshipNoAccessibleCheck_success(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;

		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name').addField('Id').setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING, true);
		//explicitly assert object accessibility when creating the subselect
		qf.subselectQuery('Tasks').addField('Id').addField('Subject').setCondition(' IsDeleted = false ');
		List<A00_QueryFactory> queries = qf.getSubselectQueries();
		System.assert(queries != null);
		String soql = qf.toSOQL();
		System.debug(soql);
		List<Contact> contacts = Database.query(soql);
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@isTest
	static void addChildQueriesWithChildRelationshipObjCheckIsAccessible_success(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;

		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name').addField('Id').setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING, true);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		Schema.ChildRelationship relationship;
		for (Schema.ChildRelationship childRow : descResult.getChildRelationships()){
        	//occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.  
        	//if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getRelationshipName() == 'Tasks'){ 
                relationship = childRow;
            }   
        }
       	//explicitly assert object accessibility when creating the subselect
		qf.subselectQuery(relationship, true).addField('Id').addField('Subject').setCondition(' IsDeleted = false ');
		List<A00_QueryFactory> queries = qf.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = Database.query(qf.toSOQL());
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@isTest
	static void addChildQueriesWithChildRelationshipObj_success(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;

		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name').addField('Id').setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING, true);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		Schema.ChildRelationship relationship;
		for (Schema.ChildRelationship childRow : descResult.getChildRelationships()){
        	//occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.  
        	//if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getRelationshipName() == 'Tasks'){ 
                relationship = childRow;
            }   
        }
       	//explicitly assert object accessibility when creating the subselect
		qf.subselectQuery(relationship).addField('Id').addField('Subject').setCondition(' IsDeleted = false ');
		List<A00_QueryFactory> queries = qf.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = Database.query(qf.toSOQL());
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@isTest
	static void addChildQueriesWithChildRelationshipNoAccessibleCheck_fail(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;

		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name').addField('Id').setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING, true);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		//explicitly assert object accessibility when creating the subselect
		//
		Exception e;
		try {
			qf.subselectQuery('Tas').addField('Id').addField('Subject').setCondition(' IsDeleted = false ');
		} catch (A00_QueryFactory.InvalidSubqueryRelationshipException ex) {
			e = ex;   
		}	
		System.assertNotEquals(e, null);
	}

	@isTest
	static void addChildQueries_success(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;

		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name').addField('Id').setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING, true);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
		//explicitly assert object accessibility when creating the subselect
		qf.subselectQuery(Task.SObjectType, true).addField('Id').addField('Subject').setCondition(' IsDeleted = false ');
		List<A00_QueryFactory> queries = qf.getSubselectQueries();
		System.assert(queries != null);
		List<Contact> contacts = Database.query(qf.toSOQL());
		System.assert(contacts != null && contacts.size() == 1);
		System.assert(contacts[0].Tasks.size() == 1);
		System.assert(contacts[0].Tasks[0].Subject == 'test');
	}

	@isTest
	static void addChildQuerySameRelationshipAgain_success(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
        Task tsk = new Task();
        tsk.WhoId = cont.Id;
        tsk.Subject = 'test';
        tsk.ActivityDate = System.today();
        insert tsk;
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		qf.addField('Id');
		qf.setCondition( 'name like \'%test%\'' );
		qf.addOrdering( new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) ).addOrdering('CreatedBy.Name', A00_QueryFactory.SortOrder.DESCENDING);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
       	ChildRelationship relationship;
        for (Schema.ChildRelationship childRow : descResult.getChildRelationships()) {
            if (childRow.getRelationshipName() == 'Tasks') {
                relationship = childRow;
            }
        }
        System.assert(qf.getSubselectQueries() == null);
		A00_QueryFactory childQf = qf.subselectQuery(Task.SObjectType);
		childQf.assertIsAccessible();
		childQf.setEnforceFLS(true);
		childQf.addField('Id');
		A00_QueryFactory childQf2 = qf.subselectQuery(Task.SObjectType);
		List<A00_QueryFactory> queries = qf.getSubselectQueries();
		System.assert(queries != null);
		System.assert(queries.size() == 1);
	}

	@isTest
	static void addChildQueries_invalidChildRelationship(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		qf.addField('email');
		qf.setCondition( 'name like \'%test%\'' );
		qf.addOrdering( new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) ).addOrdering( 'CreatedDATE', A00_QueryFactory.SortOrder.DESCENDING);
		Schema.DescribeSObjectResult descResult = Account.SObjectType.getDescribe();
        Exception e;
		try {
			SObjectType invalidType = null;
			A00_QueryFactory childQf = qf.subselectQuery(invalidType);
			childQf.addField('Id');
		} catch (A00_QueryFactory.InvalidSubqueryRelationshipException ex) {
			e = ex;
		}	
		System.assertNotEquals(e, null);
	}

	@isTest
	static void addChildQueries_invalidChildRelationshipTooDeep(){
		Account acct = new Account();
		acct.Name = 'testchildqueriesacct';
		insert acct;
		Contact cont = new Contact();
		cont.FirstName = 'test';
		cont.LastName = 'test';
		cont.AccountId = acct.Id;
		insert cont;
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.addField('name');
		qf.addField('email');
		qf.setCondition( 'name like \'%test%\'' );
		qf.addOrdering( new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) ).addOrdering('CreatedDATE', A00_QueryFactory.SortOrder.DESCENDING);
		Schema.DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
  
		A00_QueryFactory childQf = qf.subselectQuery(Task.SObjectType);
		childQf.addField('Id');
		childQf.addField('Subject');
		Exception e;
		try {
			A00_QueryFactory subChildQf = childQf.subselectQuery(Task.SObjectType);
		} catch (A00_QueryFactory.InvalidSubqueryRelationshipException ex) {
			e = ex;   
		}	
		System.assertNotEquals(e, null);
	}

	@isTest
	static void checkFieldObjectReadSort_success(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.assertIsAccessible()
		  .setEnforceFLS(true) 
		  .addField('createdby.name')
		  .addField(Contact.LastModifiedById)
		  .selectFields(new List<SObjectField>{Contact.LastModifiedDate})
		  .setEnforceFLS(false)
		  .addField(Contact.LastName)
		  .selectFields(new List<SObjectField>{Contact.Id})
		  .setCondition( 'name like \'%test%\'' )
		  .setEnforceFLS(true)
		  .selectFields(new Set<SObjectField>{Contact.FirstName})
		  .addOrdering(new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) )
		  .addOrdering(Contact.LastModifiedDate, A00_QueryFactory.SortOrder.DESCENDING)
		  .addOrdering(Contact.CreatedDate, A00_QueryFactory.SortOrder.DESCENDING, true);
		Set<String> fields = qf.getSelectedFields();  
		A00_QueryFactory.Ordering ordering = new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING);
		System.assertEquals('Name',ordering.getField());

		System.assertEquals(new Set<String>{
			'CreatedBy.Name',
			'LastModifiedById',
			'LastModifiedDate',
			'LastName',
			'Id',
			'FirstName'},
			fields);

		System.assert(qf.toSOQL().containsIgnoreCase('NULLS LAST'));
	}

	@isTest
	static void checkObjectRead_fail(){
		User usr = createTestUser_noAccess();
		if (usr != null){
			System.runAs(usr){
				//create a query factory object for Account.  
				A00_QueryFactory qf = new A00_QueryFactory(Account.SObjectType);
				Boolean excThrown = false;
				try {
					//check to see if this record is accessible, it isn't.
					qf.assertIsAccessible();
				} catch (fflib_SecurityUtils.CrudException e) {
					excThrown = true;
				}	
				System.assert(excThrown);
			}	
		}	
	}  

	@isTest
	static void checkFieldRead_fail(){		
		User usr = createTestUser_noAccess();
		if (usr != null){
			System.runAs(usr){
				//create a query factory object for Account. 
				A00_QueryFactory qf = new A00_QueryFactory(Account.SObjectType);
				Boolean excThrown = false;
				try {
					//set field to enforce FLS, then try to add a field.  
					qf.setEnforceFLS(true);
					qf.addField('Name');
				} catch (fflib_SecurityUtils.FlsException e) {
					excThrown = true;
				}	
				System.assert(excThrown);
			}	
		}	
	}

	@isTest
	static void queryWith_noFields(){
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType);
		qf.assertIsAccessible().setEnforceFLS(true).setCondition( 'name like \'%test%\'' ).addOrdering('CreatedDate', A00_QueryFactory.SortOrder.DESCENDING);
		String query = qf.toSOQL();
		System.assert(query.containsIgnoreCase('SELECT Id FROM Contact'),'Expected \'SELECT Id FROM Contact\' in the SOQL, found: ' + query);
	}  

	@isTest
	static void deterministic_toSOQL(){
		A00_QueryFactory qf1 = new A00_QueryFactory(User.SObjectType);
		A00_QueryFactory qf2 = new A00_QueryFactory(User.SObjectType);
		for(A00_QueryFactory qf:new Set<A00_QueryFactory>{qf1,qf2}){
			qf.selectFields(new List<String>{
				'Id',
				'FirstName',
				'LastName',
				'CreatedBy.Name',
				'CreatedBy.Manager',
				'LastModifiedBy.Email'
			});
		}
		String expectedQuery = 
			'SELECT CreatedBy.ManagerId, CreatedBy.Name, '
			+'FirstName, Id, LastModifiedBy.Email, LastName '
			+'FROM User';
		System.assertEquals(qf1.toSOQL(), qf2.toSOQL());
		System.assertEquals(expectedQuery, qf1.toSOQL());
		System.assertEquals(expectedQuery, qf2.toSOQL());
	}

	@isTest
	static void deepCloneBasicNoChanges() {
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType)
		.setLimit(10)
		.setCondition('id=12345')
		.addField('Description')
		.addOrdering(new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) )
		.addOrdering( new A00_QueryFactory.Ordering('Contact','CreatedDATE', A00_QueryFactory.SortOrder.DESCENDING))
		.setEnforceFLS(true);

		A00_QueryFactory qf2 = qf.deepClone();

		System.assertEquals(qf2, qf);

		System.assertEquals(qf.getLimit(), qf2.getLimit());
		System.assertEquals(qf.getCondition(), qf2.getCondition());
		System.assertEquals(qf.toSOQL(), qf2.toSOQL());
		System.assertEquals(qf.getOrderings(), qf2.getOrderings());
	}

	@isTest
	static void deepCloneSubqueryNoChanges() {
		A00_QueryFactory qf = new A00_QueryFactory(Account.SObjectType)
		.setLimit(10)
		.setCondition('id=12345')
		.addField('Description')
		.addOrdering(new A00_QueryFactory.Ordering('Account','Name', A00_QueryFactory.SortOrder.ASCENDING) )
		.addOrdering( new A00_QueryFactory.Ordering('Account','Description', A00_QueryFactory.SortOrder.DESCENDING))
		.setEnforceFLS(true);

		qf.subselectQuery('Contacts', true);	

		A00_QueryFactory qf2 = qf.deepClone();

		System.assertEquals(qf, qf2);

		System.assertEquals(qf.getLimit(), qf2.getLimit());
		System.assertEquals(qf.getCondition(), qf2.getCondition());
		System.assertEquals(qf.toSOQL(), qf2.toSOQL());
		System.assertEquals(qf.getOrderings(), qf2.getOrderings());
		System.assertEquals(qf.getSubselectQueries(), qf2.getSubselectQueries());
	}

	@isTest
	static void deepCloneBasic() {
		A00_QueryFactory qf = new A00_QueryFactory(Contact.SObjectType)
		.setLimit(10)
		.setCondition('id=12345')
		.addField('Description')
		.addOrdering(new A00_QueryFactory.Ordering('Contact','name', A00_QueryFactory.SortOrder.ASCENDING) )
		.addOrdering( new A00_QueryFactory.Ordering('Contact','CreatedDATE', A00_QueryFactory.SortOrder.DESCENDING))
		.setEnforceFLS(true);


		A00_QueryFactory qf2 = qf.deepClone()
			.setLimit(200)
			.setCondition('id=54321')
			.addField('Fax')
			.addOrdering( new A00_QueryFactory.Ordering('Contact','Fax', A00_QueryFactory.SortOrder.ASCENDING))
			.setEnforceFLS(false);

		qf2.getOrderings().remove(0);

		System.assertEquals(10, qf.getLimit());
		System.assertEquals(200, qf2.getLimit());

		System.assertEquals('id=12345', qf.getCondition());
		System.assertEquals('id=54321', qf2.getCondition());

		String query = qf.toSOQL();
		String query2 = qf2.toSOQL();

		System.assert(query.containsIgnoreCase('Fax') == false);
		System.assert(query.containsIgnoreCase('Description'));
		System.assert(query2.containsIgnoreCase('Description'));
		System.assert(query2.containsIgnoreCase('Fax'));

		System.assertEquals(2, qf.getOrderings().size());
		System.assertEquals('Name', qf.getOrderings()[0].getField() );
		System.assertEquals(A00_QueryFactory.SortOrder.DESCENDING, qf.getOrderings()[1].getDirection());

		System.assertEquals(2, qf2.getOrderings().size());
		System.assertEquals('Fax', qf2.getOrderings()[1].getField());
		System.assertEquals(A00_QueryFactory.SortOrder.ASCENDING, qf2.getOrderings()[1].getDirection());

	}

	@isTest
	static void deepCloneSubquery() {
		A00_QueryFactory qf = new A00_QueryFactory(Account.SObjectType);
		qf.subselectQuery('Contacts', true);

		A00_QueryFactory qf2 = qf.deepClone();
		qf2.subselectQuery('Opportunities', true);

		List<A00_QueryFactory> subqueries = qf.getSubselectQueries();
		List<A00_QueryFactory> subqueries2 = qf2.getSubselectQueries();

		A00_QueryFactory subquery2_0 = subqueries2.get(0);

		subquery2_0.addOrdering(new A00_QueryFactory.Ordering('Contact','Name', A00_QueryFactory.SortOrder.ASCENDING));

		System.assert(subqueries.size() == 1);
		System.assert(subqueries2.size() == 2);

		System.assert(qf.getSubselectQueries().get(0).getOrderings().size() == 0);
		System.assert(qf2.getSubselectQueries().get(0).getOrderings().size() == 1);
	}
	
	@isTest
	static void testSoql_unsortedSelectFields(){
		//Given
		A00_QueryFactory qf = new A00_QueryFactory(User.SObjectType);
		qf.selectFields(new List<String>{
			'Id',
			'FirstName',
			'LastName',
			'CreatedBy.Name',
			'CreatedBy.Manager',
			'LastModifiedBy.Email'
		});

		qf.setSortSelectFields(false);

		String orderedQuery =
			'SELECT '
			+'FirstName, Id, LastName, ' //less joins come first, alphabetically
			+'CreatedBy.ManagerId, CreatedBy.Name, LastModifiedBy.Email ' //alphabetical on the same number of joins'
			+'FROM User';

		//When
		String actualSoql = qf.toSOQL();

		//Then		
		System.assertNotEquals(orderedQuery, actualSoql);
	}


	public static User createTestUser_noAccess(){
		User usr;
		try {
			//look for a profile that does not have access to the Account object
			PermissionSet ps = 
			[SELECT Profile.Id, profile.name
				FROM PermissionSet
				WHERE IsOwnedByProfile = true
				AND Profile.UserType = 'Standard'
				AND Id NOT IN (SELECT ParentId
				               FROM ObjectPermissions
				               WHERE SObjectType = 'Account'
				               AND PermissionsRead = true)
				LIMIT 1];
			
			if (ps != null){
				//create a user with the profile found that doesn't have access to the Account object
				usr = new User(
				    firstName = 'testUsrF',
				    LastName = 'testUsrL',
				    Alias = 'tstUsr',
				    Email = 'testy.test@test.com',
				    UserName='test'+ Math.random().format()+'user99@test.com',
				    EmailEncodingKey = 'ISO-8859-1',
				    LanguageLocaleKey = 'en_US',
				    TimeZoneSidKey = 'America/Los_Angeles',
				    LocaleSidKey = 'en_US',
				    ProfileId = ps.Profile.Id,
				    IsActive=true
				    );
				insert usr;
			}
		} catch (Exception e) {
			//do nothing, just return null User because this test case won't work in this org.
			return null;
		}	
		return usr;	
	}
}