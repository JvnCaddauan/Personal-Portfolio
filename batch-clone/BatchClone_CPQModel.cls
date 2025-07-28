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
public without sharing class BatchClone_CPQModel implements Database.Batchable<sObject>, Database.Stateful {
    
    private Id oppId;
    public static Map<Id, Id> opptMap = new Map<Id, Id>();
    public static Map<Id, Id> proposalMap = new Map<Id, Id>();
    
    public BatchClone_CPQModel(Id oppId) {
        this.oppId = oppId;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, StageName, CloseDate, Type, AccountId, Pricebook2Id, OwnerId
            FROM Opportunity 
            WHERE Id =: oppId
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        // TODO: Cloning of Opportunity and Proposal
        if (scope.isEmpty()) return;

        for (Opportunity opp : scope) {
            cloneOpportunity(opp);
        }

        if(!opptMap.isEmpty()) {
            System.enqueueJob(QueueableBatchClone_CPQModel(opptMap, proposalMap)); 
        }
    }

    public void finish(Database.BatchableContext bc){
        // Queueable is run after finish() execution context
        EmailUtility.sendEmailCore(opptMap.keySet(), ConstantVariables.ORIGIN.BEFORE);
    }

    public static void cloneOpportunity(Opportunity oppRecord){
        Id originalId;
        Date dateToday = Date.today();

        Opportunity clonedOpp = oppRecord.clone(false, true, false, false);

        String opportunityName = (oppRecord.Name.contains(ConstantVariables.OPPORTUNITY.RENEWAL_NAME)) ? RenewalCloneName(oppRecord.Name) : clonedName(oppRecord.Name);
        clonedOpp.Name = opportunityName;
        clonedOpp.StageName = ConstantVariables.OPPORTUNITY.RENEWAL;
        clonedOpp.CloseDate = dateToday.addDays(180);
        clonedOpp.Type = ConstantVariables.OPPORTUNITY.TYPE;
        clonedOpp.Id = null;
        originalId = oppRecord.Id;

        insert clonedOpp;

        opptMap.put(originalId, clonedOpp.Id);
    }

    private static void cloneProposal(Map<Id, Id> opptMap){
        Id originalProposal;
        Id clonedPorposal;
        Proposal__c propList = QueryFactory.getProposal(opptMap);

        if(propList != null) {
            Proposal__c clonedProposal = propList.clone(false, true, false, false);
            
            clonedProposal.Id = null;
            clonedProposal.Opportunity__c = opptMap.get(propList.Opportunity__c);
            clonedProposal.Approval_Status__c = ConstantVariables.Proposal.APPROVAL_STATUS;
            clonedProposal.Status__c = ConstantVariables.PROPOSAL.STATUS;

            insert clonedProposal;

            originalProposal = propList.Id;
            clonedPorposal = clonedProposal.Id;
        }

        proposalMap.put(originalProposal, clonedPorposal);
    }

    public static String clonedName(String name){
        String newClonedName;
        String formattedDate = DateTime.newInstance(Date.today()).format('MM-dd-yyyy');

        if(name == null) {
            newClonedName = 'Unknown';

            return newClonedName;
        }

        newClonedName = 'Renewal ' +name+ ' - ' + formattedDate;

        return newClonedName;
    }

    public static String RenewalCloneName(String name){
        String newClonedName;
        String baseName;
        String formattedDate = DateTime.newInstance(Date.today()).format('MM-dd-yyyy');

        if(name == null) {
            newClonedName = 'Unknown';

            return newClonedName;
        }

        Pattern p = Pattern.compile('^(.*) - \\d{2}-\\d{2}-\\d{4}$');
        Matcher m = p.matcher(name);

        if (m.find()) {
            baseName = m.group(1);
        } else {
            baseName = name;
        }

        newClonedName = baseName + ' - ' + formattedDate;

        return newClonedName;
    }
}