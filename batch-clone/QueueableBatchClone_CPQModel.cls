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
public inherited sharing class QueueableBatchClone_CPQModel {
    Map<Id, Id> opptMap = new Map<Id, Id>();
    Map<Id, Id> proposalMap = new Map<Id, Id>();
    
    public QueueableBatchClone_CPQModel(Map<Id, Id> opptMap, Map<Id, Id> proposalMap) {
        this.opptMap = opptMap;
        this.proposalMap = proposalMap;
    }

    public void execute(QueueableContext ctx) {
        // Rollback SavePoint
        Database.SavePoint sp = Database.setSavepoint();
        
        try {
            // Clone Opportunity Product
            List<OpportunityLineItem> cloneOpptProd = new List<OpportunityLineItem>();
            List<OpportunityLineItem> getOpptProd = QueryFactory.getOpportunityLineItem(opptMap.keySet());

            for(OpportunityLineItem opd : getOpptProd) {
                OpportunityLineItem clonedOpd = opd.clone(false, true, false, false);

                clonedOpd.OpportunityId = opptMap.get(opd.OpportunityId);
                clonedOpd.TotalPrice = null;

                cloneOpptProd.add(clonedOpd);
            }

            if(!cloneOpptProd.isEmpty()) {
                insert cloneOpptProd;
            }

            // Clone Proposal Line Group
            List<Proposal_Line_Group__c> clonePropLineGroup = new List<Proposal_Line_Group__c>();
            List<Proposal_Line_Group__c> proposalLineGroup = QueryFactory.getProposalLineGroup(proposalMap.keySet());

            for(Proposal_Line_Group__c plg : proposalLineGroup) {
                Proposal_Line_Group__c clonePLG = plg.clone(false, true, false, false);

                clonePLG.Proposal__c = proposalMap.get(plg.Proposal__c);
                clonePLG.Id = null;

                clonePropLineGroup.add(clonePLG);
            }

            if(!clonePropLineGroup.isEmpty()) {
                insert clonePropLineGroup;
            }

            // Clone Proposal Line Item
            List<Proposal_Line_Item__c> clonePropLineItem = new List<Proposal_Line_Item__c>();
            List<Proposal_Line_Item__c> proposalLineItem = QueryFactory.getProposalLineItem();

            for(Proposal_Line_Item__c pli : proposalLineItem) {
                Proposal_Line_Item__c clonePLI = pli.clone(false, true, false, false);

                clonePLI.Proposal__c = proposalMap.get(pli.Proposal__c);
                clonePLI.Proposal_Line_Group__c = clonePropLineGroup.Id;
                clonePLI.Id = null;

                clonePropLineItem.add(clonePLI);
            }

            if(!clonePropLineItem.isEmpty()) {
                insert clonePropLineItem;
            }

            EmailUtility.sendEmailCore(opptMap.values(), ConstantVariables.ORIGIN.AFTER);
        }catch (Exception e) {
            Database.rollback(sp);
            EmailUtility.sendErrorToAdmin(e.getMessage(), e.getStackTraceString());
        }
    }
}