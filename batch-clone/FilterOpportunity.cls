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
public without sharing class FilterOpportunity {

    public static void runFilterOpportunity(){
        try {
            Map<Id, Integer> groupedResult = new Map<Id, Integer>();
            List<Opportunity> skipList = new List<Opportunity>();
            List<Opportunity> forCloneList = new List<Opportunity>();
            List<Id> oppIds = new List<Id>();

            // Get all opportunities that met the criteria
            List<Opportunity> oppList = QueryFactory.getOpportunities();

            if(oppList.isEmpty()) return;

            // Get the record count of the closed won opportunities
            // To determine the total count of Proposal Item (CPQ Model proposal item and opportunity line item are sync)
            for(Opportunity op : oppList) {
                oppIds.add(op.Id);
            }

            // Aggregate the record count of the opportunity
            // If the count is greater than the allowed maximum, add to the skipList
            AggregateResult[] countRecord = QueryFactory.getResult(oppIds);

            if (countRecord.size() == 0) return;

            for(AggregateResult ar : countRecord){
                groupedResult.put((Id) ar.get('OpportunityId'), (Integer) ar.get('recordCount'));
            }

            for (Opportunity opp : oppList) {
                Integer recordCount = groupedResult.containsKey(opp.Id) ? groupedResult.get(opp.Id) : 0;
                // Count of related must not exceed 125
                if(recordCount < ConstantVariables.Count.MAXED_COUNT){
                    // Assign Id in opportunityId variable for each loop
                    Id opportunityId = opp.Id;
                    // Create batch job for each Opportunity + related records
                    Database.executeBatch(new BatchClone_CPQModel(opportunityId), 1);
                }else{
                    // Collect all opportunity Ids that exceeds max count of related records
                    skipList.add(opp);
                }
            }

            // For all opportunities collected for email sending,
            EmailUtility.sendEmailBeforeClone(forCloneList);
            // Send email to skipped opportunities that has large volume of records
            EmailUtility.skippedOpportunities(skipList);
        }catch(Exception e) {
            System.debug(LoggingLevel.DEBUG, ' @@@@@@@@@@ Error in FilterOpportunity Error Message: ' + e.getMessage());
            System.debug(LoggingLevel.DEBUG, ' @@@@@@@@@@ Error in FilterOpportunity Stack Trace: ' + e.getStackTraceString());
        }
    }
}