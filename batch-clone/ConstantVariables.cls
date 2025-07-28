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
    # Author: Joven Caddauan
    ############################################################
*/
public without sharing class ConstantVariables {
    
    public class Count {
        public final Integer MAXED_COUNT = 125;
    }

    public class Opportunity {
        public final String CLOSED_WON = 'Closed Won';
        public final String RENEWAL = 'Prospecting';
        public final String TYPE = 'Existing Customer - Replacement';
        public final String RENEWAL_NAME = 'Renewal';
    }

    public class Proposal {
        public final String TYPE = 'Renewal';
        public final String APPROVAL_STATUS = 'Draft';
        public final String STATUS = 'Draft';
    }

    public class Origin {
        public final String BEFORE = 'Before';
        public final String AFTER = 'After';
    }

    public class EmailTemplates {
        public final String BEFORE_TRIGGER_EMAIL_TEMPLATE = 'Before_Trigger_Email_Template';
        public final String AFTER_TRIGGER_EMAIL_TEMPLATE = 'After_Trigger_Email_Template';
    }

    public static final Count COUNT = new Count();
    public static final Opportunity OPPORTUNITY = new Opportunity();
    public static final Proposal PROPOSAL = new Proposal();
    public static final Origin ORIGIN = new Origin();
    public static final EmailTemplates TEMPLATES = new EmailTemplates();
}