# ⚙️ Personal Portfolio by Joven Caddauan

Welcome to my Apex Portfolio — a curated collection of production-grade Salesforce features designed to demonstrate scalable architecture, clean code, and real-world use cases.

📌 This repository is structured by feature branches, each focusing on a specific domain challenge and built using modular, scalable, and maintainable Apex.

---

## 👤 About Me

**Joven Caddauan**  
Salesforce Developer

- 🔗 LinkedIn: https://www.linkedin.com/in/joven-caddauan-354310244/
- 🔗 Trailhead: https://www.salesforce.com/trailblazer/jvncaddauan

---

## 🧱 Design Principles & Patterns

Every feature in this repository adheres to a consistent architecture that follows:

- 🧩 **Single Responsibility Principle (SRP)**
- 🔁 **Savepoint & Rollback** design (All-or-Nothing Transactional Logic)
- 🧬 **Singleton Pattern** for static org config (e.g., RecordTypes, Email Templates)
- 📦 **Repository Pattern** for centralized SOQL logic
- 🧠 **Service Layer** for isolated business logic
- 🛠️ **Modular Utility Classes** for shared logic
- 🧵 **Separation of Concerns** across all layers
- 🚀 **Batch and Queueable Apex** for async-safe execution
- 🧘 **Governor Limit Awareness**
- 💤 **Lazy-loading static metadata and config**

---

## 🚀 Feature Branches

Switch between feature branches to explore each isolated implementation.

### `feature/batch-cloning`  
Deep cloning of CPQ model (`Opportunity`, `Opportunity Product`, `Proposal`, `Proposal Item`, `Proposal Item Group`).  
Handles logic using Batch Apex and chained Queueables with full rollback control using Savepoints.

---

## 🧪 Where Are the Test Classes?

Test classes are **intentionally excluded** to keep this portfolio focused on architecture, clarity, and business logic.

All logic is modular and testable by design.  
Test coverage can easily be added depending on the org setup and deployment context.

---

### ⚠️ Disclaimer

This project is provided strictly for **educational and personal portfolio demonstration purposes**. It is **not intended for resale, reuse, or redistribution** in any commercial or production environment.

All logic, structure, and naming conventions have been **intentionally modified or aliased** to protect any intellectual property and to reflect fictionalized use cases.

The author makes **no warranties** and assumes **no responsibility or liability** for any misuse, mishandling, or legal consequences resulting from the use of this code outside its intended context.
