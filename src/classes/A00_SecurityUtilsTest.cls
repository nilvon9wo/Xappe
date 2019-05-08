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

@IsTest
private class A00_SecurityUtilsTest {
    static User setupTestUser(String profileName) {
        //username global uniqueness is still enforced in tests
        //make sure we get something unique to avoid issues with parallel tests
        String uniqueness = DateTime.now() + ':' + Math.random();
        try {
            throw new NullPointerException();
        } catch (Exception e) {
            uniqueness += e.getStackTraceString(); //includes the top level test method name without having to pass it
        }
        Profile p = [SELECT id, Name FROM Profile WHERE Name = :profileName];
        User result = new User(
                username = UserInfo.getUserId() + '.' + uniqueness.HashCode() + '@' + UserInfo.getOrganizationId() + '.sfdcOrg',
                alias = 'testExec',
                email = 'apextests@example.com',
                emailencodingkey = 'UTF-8',
                lastname = 'Testing',
                languagelocalekey = 'en_US',
                localesidkey = 'en_US',
                profileid = p.Id,
                timezonesidkey = 'America/Los_Angeles'
        );
        insert result;
        return result;
    }

    @IsTest
    static void readonly_field_access() {
        User testUser = setupTestUser('Read Only');
        System.runAs(testUser) {
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkFieldIsInsertable(Account.SObjectType, 'naMe');
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to insert Account.Name');
                System.assert(ex instanceof A00_SecurityUtils.FlsException, 'Expected an FlsException, got ' + ex.getTypeName());
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkFieldIsReadable(Contact.SObjectType, 'LastNAME');
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertEquals(null, ex, 'Read only profile should be able to read Contact.LastName');
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkFieldIsUpdateable(Lead.SObjectType, 'cOMPANY');
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to update Lead.Company');
                System.assert(ex instanceof A00_SecurityUtils.FlsException, 'Expected an FlsException, got ' + ex.getTypeName());
            }

            A00_SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
            { //no exceptions, despite no rights
                A00_SecurityUtils.checkFieldIsInsertable(Account.SObjectType, 'naMe');
                A00_SecurityUtils.checkFieldIsReadable(Contact.SObjectType, 'LastNAME');
                A00_SecurityUtils.checkFieldIsUpdateable(Lead.SObjectType, 'cOMPANY');
            }
        }
    }

    @IsTest
    static void readonly_object_access() {
        User testUser = setupTestUser('Read Only');
        System.runAs(testUser) {
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkObjectIsInsertable(Account.SObjectType);
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to insert Account');
                System.assert(ex instanceof A00_SecurityUtils.CrudException, 'Expected an CrudException, got ' + ex.getTypeName());
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkObjectIsReadable(Contact.SObjectType);
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertEquals(null, ex, 'Read only profile should be able to read Contact');
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkObjectIsUpdateable(Lead.SObjectType);
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to update Lead');
                System.assert(ex instanceof A00_SecurityUtils.CrudException, 'Expected an CrudException, got ' + ex.getTypeName());
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkObjectIsDeletable(Opportunity.SObjectType);
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to delete Opportunity');
                System.assert(ex instanceof A00_SecurityUtils.CrudException, 'Expected an CrudException, got ' + ex.getTypeName());
            }

            A00_SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
            { //no exceptions, despite no rights
                A00_SecurityUtils.checkObjectIsInsertable(Account.SObjectType);
                A00_SecurityUtils.checkObjectIsReadable(Contact.SObjectType);
                A00_SecurityUtils.checkObjectIsUpdateable(Lead.SObjectType);
                A00_SecurityUtils.checkObjectIsDeletable(Opportunity.SObjectType);
            }
        }
    }

    @IsTest
    static void readonly_objectAndField_access() {
        User testUser = setupTestUser('Read Only');
        System.runAs(testUser) {
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkInsert(
                            Account.SObjectType,
                            new List<String>{
                                    'Name',
                                    'ParentId',
                                    'ownerId'
                            }
                    );
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to insert Account');
                System.assert(ex instanceof A00_SecurityUtils.CrudException, 'Expected an CrudException, got ' + ex.getTypeName());
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkRead(
                            Contact.SObjectType,
                            new List<String>{
                                    'LastName',
                                    'accountId',
                                    'ownerId'
                            }
                    );
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertEquals(null, ex, 'Read only profile should be able to read Contact');
            }
            {
                A00_SecurityUtils.SecurityException ex;
                try {
                    A00_SecurityUtils.checkUpdate(
                            Lead.SObjectType,
                            new List<String>{
                                    'LastName',
                                    'FirstNAMe',
                                    'cOMPANY'
                            }
                    );
                } catch (A00_SecurityUtils.SecurityException e) {
                    ex = e;
                }
                System.assertNotEquals(null, ex, 'Read only profile should not be able to update Lead');
                System.assert(ex instanceof A00_SecurityUtils.CrudException, 'Expected an CrudException, got ' + ex.getTypeName());
            }

            A00_SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
            { //no exceptions, despite no rights
                A00_SecurityUtils.checkInsert(
                        Account.SObjectType,
                        new List<String>{
                                'Name',
                                'Type',
                                'ownerId'
                        }
                );
                A00_SecurityUtils.checkRead(
                        Contact.SObjectType,
                        new List<String>{
                                'LastName',
                                'accountId',
                                'ownerId'
                        }
                );
                A00_SecurityUtils.checkUpdate(
                        Lead.SObjectType,
                        new List<String>{
                                'LastName',
                                'FirstNAMe',
                                'cOMPANY'
                        }
                );
            }
        }
    }

    @IsTest
    static void sysadmin_objectAndField_access() {
        User testUser = setupTestUser('System Administrator');
        System.runAs(testUser) {
            A00_SecurityUtils.checkInsert(
                    Account.SObjectType,
                    new List<Schema.SObjectField>{
                            Account.SObjectType.fields.Name,
                            Account.SObjectType.fields.ParentId,
                            Account.SObjectType.fields.ownerId
                    }
            );
            A00_SecurityUtils.checkRead(
                    Contact.SObjectType,
                    new List<Schema.SObjectField>{
                            Contact.SObjectType.fields.LastName,
                            Contact.SObjectType.fields.accountId,
                            Contact.SObjectType.fields.ownerId
                    }
            );
            A00_SecurityUtils.checkUpdate(
                    Lead.SObjectType,
                    new List<Schema.SObjectField>{
                            Lead.SObjectType.fields.LastName,
                            Lead.SObjectType.fields.FirstNAMe,
                            Lead.SObjectType.fields.cOMPANY
                    }
            );
        }
    }

}