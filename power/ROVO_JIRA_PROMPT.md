# Rovo AI Agent Prompt - Trello Workflow for 3PL Scope Automation

## Copy this entire prompt and paste it into Rovo/Jira AI Agent:

---

**Role:** You are a Trello workflow automation expert helping to set up an automated task management system for 3PL warehouse integration projects.

**Context:**
I need to automatically process warehouse 3PL scope documents received via email and create organized task boards in Trello. These scope documents contain detailed integration requirements for warehouse management systems, inventory tracking, and multi-system integrations (Shopify, Odoo, CargoWise, ShipStation, etc.).

**Goal:**
Create a Trello board structure and automation workflow that:
1. Organizes tasks by project phase
2. Tracks integration requirements
3. Manages testing and acceptance criteria
4. Flags missing information
5. Assigns priorities and due dates

---

## Trello Board Configuration

**Board Name:** "Navia 3PL Integrations"

**Board Description:**
"Automated tracking for warehouse 3PL integration projects. Tasks auto-generated from scope documents for customer implementations including Shopify, Odoo, CargoWise, ShipStation integrations."

---

## Lists (Columns) to Create:

1. **📋 Scope**
   - Purpose: Master project cards for each customer integration
   - Automation: New cards start here

2. **⚙️ Setup**
   - Purpose: Initial configuration and environment setup tasks
   - Examples: Create sandbox, configure access, set up credentials

3. **🔗 Integration**
   - Purpose: System integration and API connection tasks
   - Examples: Connect Shopify, configure Odoo, set up CargoWise

4. **📊 Configuration**
   - Purpose: Data mapping and system configuration
   - Examples: Map SKUs, configure inventory sync, set up reports

5. **🧪 Testing**
   - Purpose: Test cases and validation tasks
   - Examples: Test order flow, validate serial numbers, test webhooks

6. **✅ Acceptance**
   - Purpose: Final acceptance criteria and sign-off
   - Examples: Client validation, data accuracy checks, go-live approval

7. **❓ Missing Info**
   - Purpose: Information gaps that need to be resolved
   - Examples: API credentials needed, missing requirements

8. **📦 Deployment**
   - Purpose: Go-live and production deployment tasks
   - Examples: Production cutover, monitoring setup

9. **✔️ Done**
   - Purpose: Completed tasks archive

---

## Labels to Create:

**Priority Labels:**
- 🔴 **High Priority** (Red) - Critical path items, must complete first
- 🟡 **Medium Priority** (Yellow) - Important but not blocking
- 🟢 **Low Priority** (Green) - Nice to have, can be deferred

**Category Labels:**
- 🔧 **Setup** (Blue) - Initial configuration work
- 🔗 **Integration** (Purple) - System connection tasks
- 📊 **Data** (Orange) - Data mapping and migration
- 🧪 **Testing** (Lime) - QA and validation tasks
- ✅ **Acceptance** (Sky) - Final acceptance criteria
- ❓ **Missing** (Pink) - Information needed
- 📦 **Deployment** (Black) - Production deployment

**Customer Labels (create as needed):**
- 🏷️ **APS Systems** - Customer tag
- 🏷️ **BGI** - Warehouse partner tag

**System Labels:**
- 💻 **Shopify** - Shopify integration tasks
- 🗃️ **Odoo** - Odoo ERP tasks
- 📦 **CargoWise** - CargoWise WMS tasks
- 🚚 **ShipStation** - Shipping integration tasks
- ⚡ **Navia Fuel** - Navia system tasks

---

## Card Templates to Create:

### **Template 1: Master Project Card**

**Template Name:** "New Integration Project"

**Default List:** Scope

**Template Content:**
```
Title: [Customer Name] - 3PL Integration Project

Description:
**Customer:** [Customer Name]
**Systems Involved:** [List systems: Shopify, Odoo, CargoWise, etc.]
**Project Type:** Warehouse 3PL Integration

**Overview:**
[Brief project description]

**Key Systems:**
- Navia Fuel App: ✅
- Shopify: [ ]
- Odoo: [ ]
- CargoWise: [ ]
- ShipStation: [ ]

**Project Stats:**
- Setup Tasks: [count]
- Integration Tasks: [count]
- Testing Tasks: [count]
- Acceptance Tasks: [count]
- Missing Info Items: [count]

**Timeline:**
- Start Date: [Date]
- Target Go-Live: [+30 days]
- Status: 🟡 In Progress

**Contacts:**
- Customer Contact: [Name]
- Navia PM: [Name]
- Technical Lead: [Name]

**Links:**
- Scope Document: [link]
- Project Drive: [link]
- Meeting Notes: [link]

Labels: High Priority, [Customer Name]
Due Date: 30 days from creation
```

---

### **Template 2: Setup Task**

**Template Name:** "Setup Task"

**Default List:** Setup

**Template Content:**
```
Title: [Setup Task Name]

Description:
**Task Type:** Setup/Configuration
**Project:** [Project Name]
**Customer:** [Customer Name]

**Objective:**
[What needs to be accomplished]

**Details:**
[Specific requirements and steps]

**Dependencies:**
- [ ] [Prerequisite 1]
- [ ] [Prerequisite 2]

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] Documentation updated

**Resources:**
- [Link to documentation]
- [Access credentials location]

Labels: High Priority, Setup, [Customer]
Due Date: 7 days from creation
Checklist:
- [ ] Review requirements
- [ ] Assign owner
- [ ] Complete setup
- [ ] Test configuration
- [ ] Document changes
```

---

### **Template 3: Integration Task**

**Template Name:** "Integration Task"

**Default List:** Integration

**Template Content:**
```
Title: [Integration Name] - [System A] to [System B]

Description:
**Integration Type:** System Connection
**Systems:** [System A] ↔ [System B]
**Project:** [Project Name]

**Objective:**
[What data/functionality needs to integrate]

**Technical Details:**
- API Endpoint: [URL]
- Authentication: [Method]
- Data Format: [JSON/XML/etc.]
- Frequency: [Real-time/Scheduled]

**Data Mapping:**
- [ ] Field mapping documented
- [ ] Test data prepared
- [ ] Error handling defined

**Testing:**
- [ ] Unit test completed
- [ ] Integration test passed
- [ ] End-to-end validation done

Labels: High Priority, Integration, [System names]
Due Date: 10 days from creation
```

---

### **Template 4: Testing Task**

**Template Name:** "Testing Task"

**Default List:** Testing

**Template Content:**
```
Title: Test - [Feature/Integration Name]

Description:
**Test Type:** [Unit/Integration/E2E/UAT]
**Project:** [Project Name]
**Feature:** [What's being tested]

**Test Scenario:**
[Description of test case]

**Preconditions:**
- [ ] Test environment ready
- [ ] Test data loaded
- [ ] Systems configured

**Test Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Results:**
- [Result 1]
- [Result 2]

**Actual Results:**
[To be filled during testing]

**Status:** ⏳ Pending

Labels: Testing, [Customer]
Due Date: 14 days from creation
```

---

### **Template 5: Missing Information**

**Template Name:** "Missing Info Item"

**Default List:** Missing Info

**Template Content:**
```
Title: Gather: [Information Needed]

Description:
**Missing Information Type:** [API Credentials/Requirements/Documentation]
**Project:** [Project Name]
**Urgency:** [High/Medium/Low]

**What We Need:**
[Detailed description of missing information]

**Why We Need It:**
[Impact if not provided]

**Who Can Provide:**
- Primary: [Contact name]
- Secondary: [Contact name]

**Follow-up:**
- [ ] Request sent
- [ ] Reminder 1 (3 days)
- [ ] Reminder 2 (5 days)
- [ ] Escalate if not received

Labels: Missing, High Priority, [Customer]
Due Date: 7 days from creation
```

---

## Automation Rules to Create:

### **Rule 1: Auto-Label by List**

**Trigger:** When a card is moved to a list

**Actions:**
- If moved to "Setup" → Add label "Setup"
- If moved to "Integration" → Add label "Integration"
- If moved to "Testing" → Add label "Testing"
- If moved to "Acceptance" → Add label "Acceptance"
- If moved to "Missing Info" → Add label "Missing"
- If moved to "Deployment" → Add label "Deployment"

---

### **Rule 2: High Priority Due Date Warning**

**Trigger:** When a card with label "High Priority" is 3 days from due date

**Actions:**
- Move card to top of list
- Add comment: "⚠️ High priority task due in 3 days"
- (Optional) Send notification to card members

---

### **Rule 3: Overdue Task Notification**

**Trigger:** When a card's due date is past

**Actions:**
- Add label "Overdue" (create this label in red)
- Add comment: "🚨 This task is overdue. Please update status or extend due date."
- Move to top of list

---

### **Rule 4: Completion Checklist**

**Trigger:** When a card is moved to "Done"

**Actions:**
- Set due date as complete
- Add comment: "✅ Task completed on [date]"
- Archive card after 7 days (optional)

---

### **Rule 5: New Card Default Settings**

**Trigger:** When a card is created in "Setup" list

**Actions:**
- Add default checklist:
  - [ ] Review requirements
  - [ ] Assign owner
  - [ ] Complete task
  - [ ] Test
  - [ ] Document
- Set due date to 7 days from now
- Add label "Setup"

---

### **Rule 6: Missing Info Escalation**

**Trigger:** When a card in "Missing Info" list is overdue by 5 days

**Actions:**
- Add label "Escalated"
- Add comment: "🚨 Missing information overdue by 5 days. Escalating to project manager."
- (Optional) Assign to PM

---

## Power-Ups to Enable:

1. **Custom Fields** - Track additional metadata
   - Field: "Customer Name" (Text)
   - Field: "Project Type" (Dropdown: Integration/Migration/Upgrade)
   - Field: "Systems Involved" (Text)
   - Field: "Complexity" (Dropdown: Low/Medium/High)

2. **Calendar** - Visualize due dates and timeline

3. **Dashboard** - Project metrics and progress tracking

4. **Voting** - Priority voting for backlog items

5. **Email-to-Board** - Create cards from email (if available)

---

## Board Views to Configure:

### **View 1: Timeline View**
- Show all cards sorted by due date
- Group by project (master card)
- Color code by priority

### **View 2: Project Dashboard**
- Show cards grouped by customer
- Display progress (% complete)
- Highlight overdue items

### **View 3: Team Workload**
- Show cards grouped by assigned member
- Display workload distribution
- Highlight capacity issues

---

## Sample Workflow Walkthrough:

**Scenario:** New 3PL scope document received for APS Systems

**Automated Process:**

1. **Email Received** → Scope document for APS-Shopify-BGI integration

2. **Master Card Created** (in "Scope" list):
   - Title: "APS Systems - 3PL Integration Project"
   - Description: Systems involved, overview, stats
   - Labels: High Priority, APS Systems
   - Due: 30 days from now

3. **Setup Tasks Created** (in "Setup" list):
   - "Create Navia Fuel sandbox environment" (Due: 3 days)
   - "Configure BGI warehouse access" (Due: 5 days)
   - "Set up data exchange credentials" (Due: 7 days)
   - Each with Setup label, checklist, High Priority

4. **Integration Tasks Created** (in "Integration" list):
   - "Integrate Shopify with Navia Fuel app" (Due: 10 days)
   - "Configure Odoo ERP connection" (Due: 10 days)
   - "Set up ShipStation carrier integration" (Due: 10 days)
   - "Connect CargoWise for serial tracking" (Due: 12 days)
   - Each with Integration label, relevant system labels

5. **Testing Tasks Created** (in "Testing" list):
   - "Test order ingestion from Shopify" (Due: 14 days)
   - "Test serial number capture at receiving" (Due: 14 days)
   - "Validate ShipStation label creation" (Due: 16 days)
   - "Test Odoo integration and backorders" (Due: 16 days)
   - Each with Testing label, test template checklist

6. **Acceptance Tasks Created** (in "Acceptance" list):
   - "Verify data exchanges validated" (Due: 21 days)
   - "Confirm serial numbers visible in reports" (Due: 21 days)
   - "Validate ShipStation labels correct" (Due: 21 days)
   - "Confirm Odoo backorder support" (Due: 21 days)
   - Each with Acceptance label

7. **Configuration Tasks Created** (in "Configuration" list):
   - "Map SKUs between systems" (Due: 7 days)
   - "Configure inventory reconciliation" (Due: 10 days)
   - "Set up daily reporting schedule" (Due: 14 days)
   - Each with Configuration label, Data label

8. **Missing Info Tasks Created** (in "Missing Info" list):
   - "Gather: Real-time API integration limitations" (Due: 7 days)
   - "Gather: Shopify serial number structure" (Due: 7 days)
   - Each with Missing label, High Priority

**Total:** ~28 tasks automatically organized and ready to work!

---

## Team Member Setup:

**Suggested Team Roles:**

1. **Project Manager**
   - Permissions: Admin
   - Watches: All lists
   - Auto-assigned: Master cards in "Scope"

2. **Technical Lead**
   - Permissions: Normal
   - Watches: Integration, Testing, Configuration
   - Auto-assigned: Integration tasks

3. **QA Lead**
   - Permissions: Normal
   - Watches: Testing, Acceptance
   - Auto-assigned: Testing tasks

4. **Implementation Team**
   - Permissions: Normal
   - Watches: Setup, Integration, Configuration
   - Assigned: Individual tasks

---

## Metrics to Track:

**Board-Level Metrics:**
- Total projects (master cards in Scope)
- Active projects (not in Done)
- Overdue tasks count
- High priority tasks count
- Missing info items count

**Per-Project Metrics:**
- Tasks completed / Total tasks
- Days until go-live
- Blocked tasks count
- Team workload distribution

**Velocity Metrics:**
- Tasks completed per week
- Average time in Testing
- Average time Setup → Done
- Missing info resolution time

---

## Integration Points:

**If using Zapier:**
- Email → Trello (create cards from scope documents)
- Slack → Trello (notifications)
- Google Calendar → Trello (due date sync)

**If using Atlassian Tools:**
- Confluence → Trello (documentation links)
- Jira → Trello (sync issues if needed)

---

## Expected Outcome:

After you set this up, Rovo should create:

✅ Trello board: "Navia 3PL Integrations"
✅ 9 lists (Scope through Done)
✅ 15+ labels (priorities, categories, customers, systems)
✅ 5 card templates (Project, Setup, Integration, Testing, Missing Info)
✅ 6+ automation rules (auto-labeling, due date warnings, etc.)
✅ 4 Power-Ups enabled (Custom Fields, Calendar, Dashboard, Voting)
✅ 3 board views configured (Timeline, Dashboard, Workload)
✅ Team member roles defined

**Ready to process 3PL scope documents automatically!**

---

## Post-Setup Instructions for Me:

Once Rovo creates this board, I will:
1. Connect Zapier to auto-create cards from emails
2. Test with sample scope document
3. Refine automation rules based on team feedback
4. Train team on board usage
5. Set up recurring reviews and metrics tracking

---

**Rovo, please create this Trello board configuration with all the lists, labels, templates, automation rules, and settings described above. Optimize for a 3PL warehouse integration workflow where tasks are auto-generated from scope documents and organized by project phase.**

---

## Additional Context for Rovo:

**Typical Project Flow:**
Scope Document → Email → Zapier → Trello Cards Created → Team Works → Testing → Acceptance → Deployment → Done

**Key Success Criteria:**
- Tasks organized by phase (Setup → Integration → Testing → Acceptance)
- Clear priorities and due dates
- Missing information flagged immediately
- Easy to track multiple customer projects simultaneously
- Metrics visible for project health monitoring

**Team Size:** 5-8 people working on 3-5 concurrent projects

**Project Duration:** Typically 30 days from scope to go-live

---

