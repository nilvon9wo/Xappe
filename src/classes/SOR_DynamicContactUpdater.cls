public class SOR_DynamicContactUpdater {
    public static void updateContactOutreachStatus(
            List<Contact> contactList,
            Map<Id, List<OpportunityContactRole>> opportunityContactRoleByContactId,
            SOR_DyanmicSObjectUpdater sObjectUpdater
    ) {
        for (Contact contact : contactList) {
            Contact updatedContact = (Contact) sObjectUpdater.getSObject(contact.Id);

            OpportunityContactRole firstOpportunityContactRole = opportunityContactRoleByContactId.get(contact.Id)[0];
            String opportunityState = firstOpportunityContactRole.Opportunity.StageName;
            if ((new Set<String>{'Closed Won', 'Closed Won (Non-Annual Contract)'}).contains(opportunityState)) {
                updatedContact.Description = 'Current Client';
            }
            else if (opportunityState == 'Closed Lost') {
                updatedContact.Description = 'Lost Client';
            }
            else {
                updatedContact.Description = 'Confused Client';
            }
        }
    }
}