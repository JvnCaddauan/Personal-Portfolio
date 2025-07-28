# 🛠️ Batch Cloning Feature
A robust Salesforce architectural framework to clone **Opportunities** and their related **CPQ Proposals** using **Batch Apex**, **Queueable Apex**, and **Email Alerts**. Designed to handle high-volume cloning operations with fallback logic, filtering, and admin notifications.

---

## 📋 Overview

This project automates the cloning of Opportunities and their related CPQ records. It is built with a modular design consisting of:

- **Scheduler**: Triggers async Apex jobs on a schedule.
- **Filtering Logic**: Filters Opportunities exceeding configurable limits.
- **Batch Apex**: Clones Opportunity and Proposal records.
- **Queueable Apex**: Deep clones Proposal Line Items, Proposal Line Groups, and Opportunity Products.
- **Email Utility**: Sends notifications before cloning, after cloning, and in case of errors.

---

## ⚠️ Disclaimer

> This feature requires a **Salesforce CPQ Specialist** to **enable and configure CPQ discounting, pricing calculations, and engine behaviors**. Without these configurations, the cloning logic may not fully replicate the CPQ behavior expected in cloned records.
> This feature is only intended to show the architectural design for heavy cloning of records with respect to governor limits and multiple async features such as Batch Apex and Queueable Apex.

---

## 📦 Features

### ✅ Filtering (FilterOpportunity)
- Queries all **Closed Won Opportunities**.
- Uses `AggregateResult` to count related `OpportunityLineItem` records.
- If the count exceeds **125 records**, the Opportunity is skipped.
- Skipped Opportunities are collected and reported via email.
- All eligible Opportunities are processed one-by-one using **Batch Apex** (1 batch per Opportunity with Related Records).

### 🔁 Batch Apex (BatchClone_CPQModel)
- Clones the `Opportunity` and its primary `Proposal__c`.
- Prepares mapping structures for use in the next queueable phase.
- After the batch executes, it triggers a **Queueable Apex** job for deep cloning.

### ⚙️ Queueable Apex (Coming soon)
- Deep clones:
  - `Proposal Line Items`
  - `Proposal Line Groups`
  - `Opportunity Products`
- Includes rollback logic on error using try-catch and `Savepoint`.
- In any case that there's a failure during cloning, all initial committed (inserted records) are rollback. Nothing will commit to the database.

### 📧 Email Utility (EmailUtility)
- Sends email notifications in these phases:
  - **Before cloning**: Informs record owner that original opportunity is subject for cloning/renewal.
  - **After cloning**: Informs record owner that opportunity and related cpq records cloned successfully.
  - **Skipped records**: Notifies admins of high-volume Opportunities skipped.
  - **Errors**: Sends detailed error reports to admins.

---

## 🔧 Architecture

+-------------+        +---------------------+        +------------------------+
|  Scheduler  | -----> |  FilterOpportunity  | -----> |  BatchClone_CPQModel   |
+-------------+        +---------------------+        +------------------------+
       |                         |                               |
       |                         |                               |
       |                         v                               v
       |              +-------------------+         +------------------------+
       +------------> |  Queueable Apex   | ----->  |  Deep clone child      |
                      +-------------------+         |  records + rollback on |
                                                    |  failure               |
                                                    +------------------------+

---

## 📨 Email Notification
| Trigger                   | Method                       | Description                                     |
|---------------------------|------------------------------|-------------------------------------------------|
| No eligible opportunities | *TODO: Add logic*            | Send admin notification                         |
| Opportunities skipped     | `skippedOpportunities()`     | Sent when record count exceeds threshold        |
| Before cloning            | `sendEmailBeforeClone()`     | Sent before cloning each opportunity            |
| After cloning             | `sendEmailAfterClone()`      | Sent after successful cloning                   |
| Error in cloning          | `sendErrorEmail()`           | Triggered on exception; includes error details  |

---

## 📁 Project Structure

feature/batch-cloning/  
├── apex-repository/  
│   ├── BatchCloneScheduler.cls  
│   ├── FilterOpportunity.cls  
│   ├── BatchClone_CPQModel.cls  
│   ├── EmailUtility.cls  
│   ├── QueryFactory.cls  
│   ├── ConstantVariables.cls  
│   └── QueueableBatchClone_CPQModel.cls  
└── emailTemplates/  
    └── (TODO) VF Email Templates  

