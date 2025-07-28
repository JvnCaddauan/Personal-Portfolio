/*
    ############################################################
    # DISCLAIMER:
    #
    # This Apex code is intended for EDUCATIONAL and PORTFOLIO
    # demonstration purposes only. It is not for resale, reuse,
    # or redistribution in commercial production environments.
    #
    # All logic, structure, and naming have been modified or
    # aliased to protect intellectual property and to reflect
    # safe, fictional use cases.
    #
    # The author assumes no responsibility for any misuse,
    # mishandling, or legal consequences resulting from the
    # use of this code in any unauthorized context.
    #
    # Author: [Your Name or Initials]
    ############################################################
*/
public inherited sharing class EmailUtility {

    public static void sendEmailCore(List<Opportunity> opportunities, String origin){
        // TODO: Construct Email Template with merge fields

        // Get semicolon-separated CC email string
        String listOfCcEmails = EmailRecipients.getSemicolonSeparatedEmails();

        // Example usage
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setCcAddresses(EmailRecipients.getListOfEmails());

        // Determine the origin of the email and send the appropriate email template
        switch on origin {
            when 'Before' {
                EmailTemplate et = QueryFactory.getEmailTemplate(ConstantVariables.TEMPLATES.BEFORE_TRIGGER_EMAIL_TEMPLATE);

                sendEmailWithSelectedTemplate(emailTemplate, opportunities);
            }
            when 'After' {
                EmailTemplate et = QueryFactory.getEmailTemplate(ConstantVariables.TEMPLATES.AFTER_TRIGGER_EMAIL_TEMPLATE);

                sendEmailWithSelectedTemplate(emailTemplate, opportunities);
            }
        }
    }

    public static void sendErrorToAdmin(String errorMessage, String stackTraceString){
        // TODO: Construct Email Template with merge fields
        // Send to Admin Only
    }

    private static void sendEmailWithSelectedTemplate(EmaiLTemplate emailTemplate, List<Opportunity> opportunities) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Opportunity op : opportunities){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setCcAddresses(EmailRecipients.getListOfEmails());
            email.TargetObjectId(op.OwnerId);
            email.setTemplateId(emailTemplate.Id);

            emails.add(email);
        }

        if(emails.isEmpty()){
            // TODO: Send Email
        }
    }

    private class EmailRecipients {
        // Return list of emails
        public static List<String> getListOfEmails() {
            List<String> ccEmails = new List<String>();
            for (Email_Recipient_Metadata__mdt meta : Email_Recipient_Metadata__mdt.getAll().values()) {
                if (meta.CC_Email__c != null) {
                    ccEmails.add(meta.CC_Email__c);
                }
            }
            return ccEmails;
        }

        public static String getSemicolonSeparatedEmails() {
            return String.join(getListOfEmails(), ';');
        }
    }
}