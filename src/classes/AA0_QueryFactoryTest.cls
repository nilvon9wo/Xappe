@IsTest
private class AA0_QueryFactoryTest {
    private static final XAP_DAO_SOQL_WHERE_ClauseIntf TEST_WHERE_EQUALS_CLAUSE
            = new XAP_DAO_SOQL_WHERE_StringCompareClause(
                    'name', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, '\'test\''
            );

    private static final XAP_DAO_SOQL_WHERE_ClauseIntf TEST_WHERE_LIKE_CLAUSE
            = new XAP_DAO_SOQL_WHERE_StringCompareClause(
                    'name', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.IS_LIKE, '\'%test%\''
            );
    private static final XAP_DAO_SOQL_WHERE_StringCompareClause TEST_WHERE_NOT_DELETED_CLAUSE
            = new XAP_DAO_SOQL_WHERE_StringCompareClause(
                    'IsDeleted', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, 'false'
            );
    private static final XAP_DAO_SOQL_WHERE_StringCompareClause TEST_WHERE_ID_CLAUSE_1
            = new XAP_DAO_SOQL_WHERE_StringCompareClause(
                    'id', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, '12345'
            );
    private static final XAP_DAO_SOQL_WHERE_StringCompareClause TEST_WHERE_ID_CLAUSE_2
            = new XAP_DAO_SOQL_WHERE_StringCompareClause(
                    'id', XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS, '54321'
            );

    @IsTest
    static void fieldSelections() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('firstName');
        qf.addField(Contact.SObjectType.fields.LastName);
        qf.addFields(new Set<String>{
                'acCounTId', 'account.name'
        });
        qf.addFields(new List<String>{
                'homePhonE', 'fAX'
        });
        qf.addFields(new List<Schema.SObjectField>{
                Contact.Email, Contact.Title
        });
        System.assertEquals(new Set<String>{
                'FirstName',
                'LastName',
                'AccountId',
                'Account.Name',
                'HomePhone',
                'Fax',
                'Email',
                'Title'
        },
                qf.getSelectedFields());
    }

    @IsTest
    static void simpleFieldSelection() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('NAMe').addFields(new Set<String>{
                'naMe', 'email'
        });
        String query = qf.toSOQL();
        System.assert(Pattern.matches('SELECT.*Name.*FROM.*', query), 'Expected Name field in query, got ' + query);
        System.assert(Pattern.matches('SELECT.*Email.*FROM.*', query), 'Expected Name field in query, got ' + query);
        qf.setLimit(100);
        System.assertEquals(100, qf.getLimit());
        System.assert(
                qf.toSOQL()
                        .endsWithIgnoreCase('LIMIT ' + qf.getLimit()), 'Failed to respect limit clause:' + qf.toSOQL()
        );
    }

    @IsTest
    static void simpleFieldCondition() {
        XAP_DAO_SOQL_WHERE_ClauseIntf whereClause = TEST_WHERE_EQUALS_CLAUSE;
        AA0_QueryFactory queryFactory = new AA0_QueryFactory(Contact.SObjectType);
        queryFactory.addField('name');
        queryFactory.addField('email');
        queryFactory.setCondition(whereClause);
        System.assertEquals(whereClause, queryFactory.getCondition());
        String query = queryFactory.toQueryInterpolation().template;
        System.assert(
                query.endsWith('WHERE name = \'test\''), 'Query should have ended with a filter on name, got: ' + query
        );
    }

    @IsTest
    static void duplicateFieldSelection() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('NAMe').addFields(new Set<String>{
                'naMe', 'email'
        });
        String query = qf.toSOQL();
        System.assertEquals(1, query.countMatches('Name'), 'Expected one name field in query: ' + query);
    }

    @IsTest
    static void equalityCheck() {
        AA0_QueryFactory qf1 = new AA0_QueryFactory(Contact.SObjectType);
        AA0_QueryFactory qf2 = new AA0_QueryFactory(Contact.SObjectType);
        System.assertEquals(qf1, qf2);
        qf1.addField('name');
        System.assertNotEquals(qf1, qf2);
        qf2.addField('NAmE');
        System.assertEquals(qf1, qf2);
        qf1.addField('name').addFields(new Set<String>{
                'NAME', 'name'
        }).addFields(new Set<Schema.SObjectField>{
                Contact.Name, Contact.Name
        });
        System.assertEquals(qf1, qf2);
    }

    @IsTest
    static void nonReferenceField() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        XAP_DAO_SOQL_NonReferenceFieldException e;
        try {
            qf.addField('name.title');
        }
        catch (XAP_DAO_SOQL_NonReferenceFieldException ex) {
            e = ex;
        }
        System.assertNotEquals(null, e, 'Cross-object notation on a non-reference field should throw NonReferenceFieldException.');
    }

    @IsTest
    static void invalidCrossObjectField() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        XAP_DAO_SOQL_InvalidFieldException e;
        try {
            qf.addField('account.NOT_A_REAL_FIELD');
        }
        catch (XAP_DAO_SOQL_InvalidFieldException ex) {
            e = ex;
        }
        System.assertNotEquals(null, e, 'Cross-object notation on a non-reference field should throw NonReferenceFieldException.');
    }

    @IsTest
    static void invalidFieldTests() {
        List<XAP_DAO_SOQL_InvalidFieldException> exceptions = new List<XAP_DAO_SOQL_InvalidFieldException>();
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        try {
            qf.addField('Not_a_field');
        }
        catch (XAP_DAO_SOQL_InvalidFieldException e) {
            exceptions.add(e);
        }
        try {
            qf.addFields(new Set<String>{
                    'Not_a_field', 'alsoNotreal'
            });
        }
        catch (XAP_DAO_SOQL_InvalidFieldException e) {
            exceptions.add(e);
        }
        try {
            qf.addFields(new Set<Schema.SObjectField>{
                    null
            });
        }
        catch (XAP_DAO_SOQL_InvalidFieldException e) {
            exceptions.add(e);
        }
        try {
            qf.addFields(new List<Schema.SObjectField>{
                    null, Contact.title
            });
        }
        catch (XAP_DAO_SOQL_InvalidFieldException e) {
            exceptions.add(e);
        }
        System.assertEquals(4, exceptions.size());
    }

    @IsTest
    static void ordering() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        qf.addField('email');
        qf.setCondition(TEST_WHERE_EQUALS_CLAUSE);
        qf.addOrdering(new XAP_DAO_SOQL_QuerySortOrdering(
                'Contact',
                'name',
                XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING
        ))
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering(
                'Contact',
                'CreatedDATE',
                XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING
        ));
        String query = qf.toSOQL();

        System.assertEquals(2, qf.getOrderings().size());
        System.assertEquals('Name', qf.getOrderings()[0].getField());
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, qf.getOrderings()[1].getDirection());


        System.assert(Pattern.matches('SELECT.*Name.*FROM.*', query), 'Expected Name field in query, got ' + query);
        System.assert(Pattern.matches('SELECT.*Email.*FROM.*', query), 'Expected Name field in query, got ' + query);
    }

    @IsTest
    static void setOrdering_ReplacesPreviousOrderingsWithExpectedOrdering() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        qf.addField('email');
        qf.setCondition(TEST_WHERE_EQUALS_CLAUSE);

        //test base method with ordeting by OwnerId Descending
        qf.setOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'OwnerId', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING));

        System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace default Orderings');
        System.assertEquals(Contact.OwnerId.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field OwnerId');
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

        //test method overload with ordering by LastModifiedDate Ascending
        qf.setOrdering('LastModifiedDate', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, true);

        System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
        System.assertEquals(Contact.LastModifiedDate.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field LastModifiedDate');
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

        //test method overload with ordering by CreatedDate Descending
        qf.setOrdering(Contact.CreatedDate, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);

        System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
        System.assertEquals(Contact.CreatedDate.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field CreatedDate');
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

        //test method overload with ordering by CreatedBy.Name Descending
        qf.setOrdering('CreatedBy.Name', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);

        System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');

        //test method overload with ordering by Birthdate Ascending
        qf.setOrdering(Contact.Birthdate, XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING);

        System.assertEquals(1, qf.getOrderings().size(), 'Unexpected order size - setOrder should replace previous Orderings');
        System.assertEquals(Contact.Birthdate.getDescribe().getName(), qf.getOrderings()[0].getField(), 'Unexpected order field - should have been resolved from the field Birthdate');
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, qf.getOrderings()[0].getDirection(), 'Unexpected order direction.');
    }

    @IsTest
    static void invalidField_string() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        Exception e;
        try {
            qf.addField('not_a__field');
        }
        catch (XAP_DAO_SOQL_InvalidFieldException ex) {
            e = ex;
        }
        System.assertNotEquals(null, e);
    }

    @IsTest
    static void invalidFields_string() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        Exception e;
        try {
            qf.addFields(new List<String>{
                    'not_a__field'
            });
        }
        catch (XAP_DAO_SOQL_InvalidFieldException ex) {
            e = ex;
        }
        System.assertNotEquals(null, e);
    }

    @IsTest
    static void invalidField_nullToken() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        Exception e;
        Schema.SObjectField token = null;
        try {
            qf.addField(token);
        }
        catch (XAP_DAO_SOQL_InvalidFieldException ex) {
            e = ex;
        }
        System.assertNotEquals(null, e);
    }

    @IsTest
    static void invalidFields_nullToken() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        Exception e;
        List<Schema.SObjectField> token = new List<Schema.SObjectField>{
                null
        };
        try {
            qf.addFields(token);
        }
        catch (XAP_DAO_SOQL_InvalidFieldException ex) {
            e = ex;
        }
        System.assertNotEquals(null, e);
    }

    @IsTest
    static void invalidFields_noQueryField() {
        try {
            AA0_QueryFactory.getFieldTokenPath(null);
            System.assert(false, 'Expected InvalidFieldException; none was thrown');
        }
        catch (XAP_DAO_SOQL_InvalidFieldException ife) {
            //Expected
        }
        catch (Exception e) {
            System.assert(false, 'Expected InvalidFieldException; ' + e.getTypeName() + ' was thrown instead: ' + e);
        }
    }

    @IsTest
    static void queryFieldsNotEquals() {
        String qfld = AA0_QueryFactory.getFieldTokenPath(Contact.Name);
        String qfld2 = AA0_QueryFactory.getFieldTokenPath(Contact.LastName);
        System.assert(!qfld.equals(qfld2));
    }

    @IsTest
    static void addChildQueriesWithChildRelationship_success() {
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

        AA0_QueryFactory queryFactory = new AA0_QueryFactory(Contact.SObjectType);
        queryFactory.addField('name')
                .addField('Id')
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        //explicitly assert object accessibility when creating the subselect
        queryFactory.subselectQuery('Tasks', true)
                .addField('Id')
                .addField('Subject')
                .setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
        List<AA0_QueryFactory> queries = queryFactory.getSubselectQueries();
        System.assert(queries != null);
        List<Contact> contacts = queryFactory.query();
        System.assert(contacts != null && contacts.size() == 1);
        System.assert(contacts[0].Tasks.size() == 1);
        System.assert(contacts[0].Tasks[0].Subject == 'test');
    }

    @IsTest
    static void addChildQueriesWithChildRelationshipNoAccessibleCheck_success() {
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

        AA0_QueryFactory queryFactory = new AA0_QueryFactory(Contact.SObjectType);
        queryFactory.addField('name')
                .addField('Id')
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        //explicitly assert object accessibility when creating the subselect
        queryFactory.subselectQuery('Tasks').addField('Id').addField('Subject').setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
        List<AA0_QueryFactory> queries = queryFactory.getSubselectQueries();
        System.assert(queries != null);
        List<Contact> contacts = queryFactory.query();
        System.assert(contacts != null && contacts.size() == 1);
        System.assert(contacts[0].Tasks.size() == 1);
        System.assert(contacts[0].Tasks[0].Subject == 'test');
    }

    @IsTest
    static void addChildQueriesWithChildRelationshipObjCheckIsAccessible_success() {
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

        AA0_QueryFactory queryFactory = new AA0_QueryFactory(Contact.SObjectType);
        queryFactory
                .addField('name')
                .addField('Id')
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
        Schema.ChildRelationship relationship;
        for (Schema.ChildRelationship childRow : descResult.getChildRelationships()) {
            //occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
            //if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getRelationshipName() == 'Tasks') {
                relationship = childRow;
            }
        }
        //explicitly assert object accessibility when creating the subselect
        queryFactory.subselectQuery(relationship, true)
                .addField('Id')
                .addField('Subject')
                .setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
        List<AA0_QueryFactory> queries = queryFactory.getSubselectQueries();
        System.assert(queries != null);
        List<Contact> contacts = queryFactory.query();
        System.assert(contacts != null && contacts.size() == 1);
        System.assert(contacts[0].Tasks.size() == 1);
        System.assert(contacts[0].Tasks[0].Subject == 'test');
    }

    @IsTest
    static void addChildQueriesWithChildRelationshipObj_success() {
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

        AA0_QueryFactory queryFactory = new AA0_QueryFactory(Contact.SObjectType);
        queryFactory
                .addField('name')
                .addField('Id')
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
        Schema.ChildRelationship relationship;
        for (Schema.ChildRelationship childRow : descResult.getChildRelationships()) {
            //occasionally on some standard objects (Like Contact child of Contact) do not have a relationship name.
            //if there is no relationship name, we cannot query on it, so throw an exception.
            if (childRow.getRelationshipName() == 'Tasks') {
                relationship = childRow;
            }
        }
        //explicitly assert object accessibility when creating the subselect
        queryFactory.subselectQuery(relationship).addField('Id').addField('Subject').setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
        List<AA0_QueryFactory> queries = queryFactory.getSubselectQueries();
        System.assert(queries != null);
        List<Contact> contacts = queryFactory.query();
        System.assert(contacts != null && contacts.size() == 1);
        System.assert(contacts[0].Tasks.size() == 1);
        System.assert(contacts[0].Tasks[0].Subject == 'test');
    }

    @IsTest
    static void addChildQueriesWithChildRelationshipNoAccessibleCheck_fail() {
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

        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name')
                .addField('Id')
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        //explicitly assert object accessibility when creating the subselect
        //
        Exception e;
        try {
            qf.subselectQuery('Tas').addField('Id').addField('Subject').setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
        }
        catch (XAP_DAO_SOQL_InvalidSubqueryException ex) {
            e = ex;
        }
        System.assertNotEquals(e, null);
    }

    @IsTest
    static void addChildQueries_success() {
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

        AA0_QueryFactory queryFactory = new AA0_QueryFactory(Contact.SObjectType);
        queryFactory.addField('name')
                .addField('Id')
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        //explicitly assert object accessibility when creating the subselect
        queryFactory.subselectQuery(Task.SObjectType, true)
                .addField('Id')
                .addField('Subject')
                .setCondition(TEST_WHERE_NOT_DELETED_CLAUSE);
        List<AA0_QueryFactory> queries = queryFactory.getSubselectQueries();
        System.assert(queries != null);
        List<Contact> contacts = queryFactory.query();
        System.assert(contacts != null && contacts.size() == 1);
        System.assert(contacts[0].Tasks.size() == 1);
        System.assert(contacts[0].Tasks[0].Subject == 'test');
    }

    @IsTest
    static void addChildQuerySameRelationshipAgain_success() {
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
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        qf.addField('Id');
        qf.setCondition(TEST_WHERE_LIKE_CLAUSE);
        qf.addOrdering(
                new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
        )
                .addOrdering('CreatedBy.Name', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);
        DescribeSObjectResult descResult = Contact.SObjectType.getDescribe();
        ChildRelationship relationship;
        for (Schema.ChildRelationship childRow : descResult.getChildRelationships()) {
            if (childRow.getRelationshipName() == 'Tasks') {
                relationship = childRow;
            }
        }
        System.assert(qf.getSubselectQueries() == null);
        AA0_QueryFactory childQf = qf.subselectQuery(Task.SObjectType);
        childQf.assertIsAccessible();
        childQf.setEnforceFLS(true);
        childQf.addField('Id');
        qf.subselectQuery(Task.SObjectType);
        List<AA0_QueryFactory> queries = qf.getSubselectQueries();
        System.assert(queries != null);
        System.assert(queries.size() == 1);
    }

    @IsTest
    static void addChildQueries_invalidChildRelationship() {
        Account acct = new Account();
        acct.Name = 'testchildqueriesacct';
        insert acct;
        Contact cont = new Contact();
        cont.FirstName = 'test';
        cont.LastName = 'test';
        cont.AccountId = acct.Id;
        insert cont;
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        qf.addField('email');
        qf.setCondition(TEST_WHERE_LIKE_CLAUSE);
        qf.addOrdering(
                new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
        )
                .addOrdering('CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);
        Exception e;
        try {
            SObjectType invalidType = null;
            AA0_QueryFactory childQf = qf.subselectQuery(invalidType);
            childQf.addField('Id');
        }
        catch (XAP_DAO_SOQL_InvalidSubqueryException ex) {
            e = ex;
        }
        System.assertNotEquals(e, null);
    }

    @IsTest
    static void addChildQueries_invalidChildRelationshipTooDeep() {
        Account acct = new Account();
        acct.Name = 'testchildqueriesacct';
        insert acct;
        Contact cont = new Contact();
        cont.FirstName = 'test';
        cont.LastName = 'test';
        cont.AccountId = acct.Id;
        insert cont;
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.addField('name');
        qf.addField('email');
        qf.setCondition(TEST_WHERE_LIKE_CLAUSE);
        qf.addOrdering(
                new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING)
        )
                .addOrdering('CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);

        AA0_QueryFactory childQf = qf.subselectQuery(Task.SObjectType);
        childQf.addField('Id');
        childQf.addField('Subject');
        Exception e;
        try {
            childQf.subselectQuery(Task.SObjectType);
        }
        catch (XAP_DAO_SOQL_InvalidSubqueryException ex) {
            e = ex;
        }
        System.assertNotEquals(e, null);
    }

    @IsTest
    static void checkFieldObjectReadSort_success() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.assertIsAccessible()
                .setEnforceFLS(true)
                .addField('createdby.name')
                .addField(Contact.LastModifiedById)
                .addFields(new List<SObjectField>{
                Contact.LastModifiedDate
        })
                .setEnforceFLS(false)
                .addField(Contact.LastName)
                .addFields(new List<SObjectField>{
                Contact.Id
        })
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .setEnforceFLS(true)
                .addFields(new Set<SObjectField>{
                Contact.FirstName
        })
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING))
                .addOrdering(Contact.LastModifiedDate, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING)
                .addOrdering(Contact.CreatedDate, XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, true);
        Set<String> fields = qf.getSelectedFields();
        XAP_DAO_SOQL_QuerySortOrdering ordering = new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING);
        System.assertEquals('Name', ordering.getField());

        System.assertEquals(new Set<String>{
                'CreatedBy.Name',
                'LastModifiedById',
                'LastModifiedDate',
                'LastName',
                'Id',
                'FirstName'
        },
                fields);

        System.assert(qf.toSOQL().containsIgnoreCase('NULLS LAST'));
    }

    @IsTest
    static void checkObjectRead_fail() {
        User usr = createTestUser_noAccess();
        if (usr != null) {
            System.runAs(usr) {
                //create a query factory object for Account.
                AA0_QueryFactory qf = new AA0_QueryFactory(Account.SObjectType);
                Boolean excThrown = false;
                try {
                    //check to see if this record is accessible, it isn't.
                    qf.assertIsAccessible();
                }
                catch (A00_SecurityUtils.CrudException e) {
                    excThrown = true;
                }
                System.assert(excThrown);
            }
        }
    }

    @IsTest
    static void checkFieldRead_fail() {
        User usr = createTestUser_noAccess();
        if (usr != null) {
            System.runAs(usr) {
                //create a query factory object for Account.
                AA0_QueryFactory qf = new AA0_QueryFactory(Account.SObjectType);
                Boolean excThrown = false;
                try {
                    //set field to enforce FLS, then try to add a field.
                    qf.setEnforceFLS(true);
                    qf.addField('Name');
                }
                catch (A00_SecurityUtils.FlsException e) {
                    excThrown = true;
                }
                System.assert(excThrown);
            }
        }
    }

    @IsTest
    static void queryWith_noFields() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType);
        qf.assertIsAccessible()
                .setEnforceFLS(true)
                .setCondition(TEST_WHERE_LIKE_CLAUSE)
                .addOrdering('CreatedDate', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING);
        String query = qf.toSOQL();
        System.assert(
                query.containsIgnoreCase('SELECT Id FROM Contact'),
                'Expected \'SELECT Id FROM Contact\' in the SOQL, found: ' + query
        );
    }

    @IsTest
    static void deterministic_toSOQL() {
        AA0_QueryFactory qf1 = new AA0_QueryFactory(User.SObjectType);
        AA0_QueryFactory qf2 = new AA0_QueryFactory(User.SObjectType);
        for (AA0_QueryFactory qf : new Set<AA0_QueryFactory>{
                qf1, qf2
        }) {
            qf.addFields(new List<String>{
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
                        + 'FirstName, Id, LastModifiedBy.Email, LastName '
                        + 'FROM User';
        System.assertEquals(qf1.toSOQL(), qf2.toSOQL());
        System.assertEquals(expectedQuery, qf1.toSOQL());
        System.assertEquals(expectedQuery, qf2.toSOQL());
    }

    @IsTest
    static void deepCloneBasicNoChanges() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType)
                .setLimit(10)
                .setCondition(TEST_WHERE_ID_CLAUSE_1)
                .addField('Description')
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING))
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING))
                .setEnforceFLS(true);

        AA0_QueryFactory qf2 = qf.deepClone();

        System.assertEquals(qf2, qf);

        System.assertEquals(qf.getLimit(), qf2.getLimit());
        System.assertEquals(qf.getCondition(), qf2.getCondition());
        System.assertEquals(qf.toSOQL(), qf2.toSOQL());
        System.assertEquals(qf.getOrderings(), qf2.getOrderings());
    }

    @IsTest
    static void deepCloneSubqueryNoChanges() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Account.SObjectType)
                .setLimit(10)
                .setCondition(TEST_WHERE_ID_CLAUSE_1)
                .addField('Description')
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Account', 'Name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING))
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Account', 'Description', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING))
                .setEnforceFLS(true);

        qf.subselectQuery('Contacts', true);

        AA0_QueryFactory qf2 = qf.deepClone();

        System.assertEquals(qf, qf2);

        System.assertEquals(qf.getLimit(), qf2.getLimit());
        System.assertEquals(qf.getCondition(), qf2.getCondition());
        System.assertEquals(qf.toSOQL(), qf2.toSOQL());
        System.assertEquals(qf.getOrderings(), qf2.getOrderings());
        System.assertEquals(qf.getSubselectQueries(), qf2.getSubselectQueries());
    }

    @IsTest
    static void deepCloneBasic() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Contact.SObjectType)
                .setLimit(10)
                .setCondition(TEST_WHERE_ID_CLAUSE_1)
                .addField('Description')
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING))
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'CreatedDATE', XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING))
                .setEnforceFLS(true);


        AA0_QueryFactory qf2 = qf.deepClone()
                .setLimit(200)
                .setCondition(TEST_WHERE_ID_CLAUSE_2)
                .addField('Fax')
                .addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'Fax', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING))
                .setEnforceFLS(false);

        qf2.getOrderings().remove(0);

        System.assertEquals(10, qf.getLimit());
        System.assertEquals(200, qf2.getLimit());

        System.assertEquals(TEST_WHERE_ID_CLAUSE_1, qf.getCondition());
        System.assertEquals(TEST_WHERE_ID_CLAUSE_2, qf2.getCondition());

        String query = qf.toSOQL();
        String query2 = qf2.toSOQL();

        System.assert(query.containsIgnoreCase('Fax') == false);
        System.assert(query.containsIgnoreCase('Description'));
        System.assert(query2.containsIgnoreCase('Description'));
        System.assert(query2.containsIgnoreCase('Fax'));

        System.assertEquals(2, qf.getOrderings().size());
        System.assertEquals('Name', qf.getOrderings()[0].getField());
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.DESCENDING, qf.getOrderings()[1].getDirection());

        System.assertEquals(2, qf2.getOrderings().size());
        System.assertEquals('Fax', qf2.getOrderings()[1].getField());
        System.assertEquals(XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING, qf2.getOrderings()[1].getDirection());

    }

    @IsTest
    static void deepCloneSubquery() {
        AA0_QueryFactory qf = new AA0_QueryFactory(Account.SObjectType);
        qf.subselectQuery('Contacts', true);

        AA0_QueryFactory qf2 = qf.deepClone();
        qf2.subselectQuery('Opportunities', true);

        List<AA0_QueryFactory> subqueries = qf.getSubselectQueries();
        List<AA0_QueryFactory> subqueries2 = qf2.getSubselectQueries();

        AA0_QueryFactory subquery2_0 = subqueries2.get(0);

        subquery2_0.addOrdering(new XAP_DAO_SOQL_QuerySortOrdering('Contact', 'Name', XAP_DAO_SOQL_QuerySortOrderEnum.ASCENDING));

        System.assert(subqueries.size() == 1);
        System.assert(subqueries2.size() == 2);

        System.assert(qf.getSubselectQueries().get(0).getOrderings().size() == 0);
        System.assert(qf2.getSubselectQueries().get(0).getOrderings().size() == 1);
    }

    @IsTest
    static void testSoql_unsortedSelectFields() {
        //Given
        AA0_QueryFactory qf = new AA0_QueryFactory(User.SObjectType);
        qf.addFields(new List<String>{
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
                        + 'FirstName, Id, LastName, ' //less joins come first, alphabetically
                        + 'CreatedBy.ManagerId, CreatedBy.Name, LastModifiedBy.Email ' //alphabetical on the same number of joins'
                        + 'FROM User';

        //When
        String actualSoql = qf.toSOQL();

        //Then
        System.assertNotEquals(orderedQuery, actualSoql);
    }


    public static User createTestUser_noAccess() {
        User usr;
        try {
            //look for a profile that does not have access to the Account object
            PermissionSet ps = [
                    SELECT Profile.Id, Profile.Name
                    FROM PermissionSet
                    WHERE IsOwnedByProfile = TRUE
                            AND Profile.UserType = 'Standard'
                            AND Id NOT IN (
                                    SELECT ParentId
                                    FROM ObjectPermissions
                                    WHERE SobjectType = 'Account'
                                            AND PermissionsRead = TRUE
                            )
                    LIMIT 1
            ];

            if (ps != null) {
                //create a user with the profile found that doesn't have access to the Account object
                usr = new User(
                        FirstName = 'testUsrF',
                        LastName = 'testUsrL',
                        Alias = 'tstUsr',
                        Email = 'testy.test@test.com',
                        Username = 'test' + Math.random().format() + 'user99@test.com',
                        EmailEncodingKey = 'ISO-8859-1',
                        LanguageLocaleKey = 'en_US',
                        TimeZoneSidKey = 'America/Los_Angeles',
                        LocaleSidKey = 'en_US',
                        ProfileId = ps.Profile.Id,
                        IsActive = true
                );
                insert usr;
            }
        }
        catch (Exception e) {
            //do nothing, just return null User because this test case won't work in this org.
            return null;
        }
        return usr;
    }
}