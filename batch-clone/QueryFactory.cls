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
public inherited sharing class QueryFactory {

    public static List<Opportunity> getOpportunities(){
        List<Opportunity> opList = [
            SELECT Id 
            FROM Opportunity 
            WHERE StageName = :ConstantVariables.OPPORTUNITY.CLOSED_WON
            AND CreatedDate = TODAY
            WITH SECURITY_ENFORCED
        ];

        return opList;
    }

    public static AggregateResult[] getResult(List<Id> oppList) {
        AggregateResult[] countRecord = [
            SELECT OpportunityId, COUNT(Id) recordCount 
            FROM OpportunityLineItem 
            WHERE OpportunityId IN :oppList
            WITH SECURITY_ENFORCED
            GROUP BY OpportunityId
        ];

        return countRecord;
    }

    public static Proposal__c getProposal(Map<Id, Id> opptMap) {
        Proposal__c proposalList = [
            SELECT Id, Opportunity__c 
            FROM Proposal__c 
            WHERE Opportunity__c = :opptMap.keySet()
            AND Primary__c = TRUE
            WITH SECURITY_ENFORCED
        ];

        return proposalList;
    }

    public static List<OpportunityLineItem> getOpportunityLineItem(Set<Id> originalOppId) {
        List<OpportunityLineItem> opportunityLineItemList = [
            SELECT Id, OpportunityId
            FROM OpportunityLineItem
            WHERE OpportunityId = :originalOppId
            WITH SECURITY_ENFORCED
        ];

        return opportunityLineItemList;
    }

    public static List<Proposal_Line_Item__c> getProposalLineItem(Set<Id> proposalId) {
        List<Proposal_Line_Item__c> proposalLineItemList = [
            SELECT Id, Proposal__c
            FROM Proposal_Line_Item__c
            WHERE Proposal__c = :proposalId
            WITH SECURITY_ENFORCED
        ];
    }

    public static List<Proposal_Line_Group__c> getProposalLineGroup(Set<Id> proposalId) {
        List<Proposal_Line_Item__c> proposalLineItemList = [
            SELECT Id, Proposal__c
            FROM Proposal_Line_Group__c
            WHERE Proposal__c = :proposalId
            WITH SECURITY_ENFORCED
        ];
    }

    public static EmailTemplate getEmailTemplate(String emailDeveloperName) {
        EmailTemplate template = [
            SELECT Id, Body, HtmlValue, Subject
            FROM EmailTemplate 
            WHERE DeveloperName = :emailDeveloperName
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        return template;
    }
}