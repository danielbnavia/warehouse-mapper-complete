# Warehouse 3PL Scope Document → Automated Task Creation
## Zapier + Trello/Jira Integration (No Microsoft Admin Required)

---

## 📧 Email Format Detection

**Subject Line Pattern:**
- `Warehouse 3PL Scope Document Generator`
- `3PL Scope Document for [Customer Name]`
- Contains: "Navia Freight", "Scope Document", "APS Systems"

**Email Body:**
Complete scope document as provided (plain text format)

**Key Sections to Extract:**
1. Title and Document Overview
2. Customer Details
3. 3PL Provider Details
4. Systems and Integrations
5. Operational Processes
6. Testing Plan
7. Acceptance Criteria
8. Known Gaps/Assumptions
9. Exclusions

---

## 🔍 Intelligent Parsing Strategy

### **Section-Based Task Extraction**

```javascript
// Zapier Code by Zapier - JavaScript

const emailBody = inputData.emailBody;

// Extract key metadata
const extractMetadata = (text) => {
  const metadata = {
    customer: text.match(/Customer Name:\s*(.+)/)?.[1]?.trim() || 'Unknown',
    project: text.match(/Title:\s*(.+)/)?.[1]?.trim() || 'Unknown Project',
    systems: [],
    actionItems: [],
    missingInfo: [],
    testingTasks: [],
    acceptanceCriteria: []
  };

  // Extract systems
  const systemsSection = text.match(/Systems and Integrations[\s\S]*?(?=\n\n[A-Z])/)?.[0];
  if (systemsSection) {
    const systems = [
      'Navia Fuel App',
      'Shopify',
      'Odoo',
      'ShipStation',
      'CargoWise'
    ];
    systems.forEach(sys => {
      if (systemsSection.includes(sys)) {
        metadata.systems.push(sys);
      }
    });
  }

  // Extract testing tasks
  const testingSection = text.match(/Testing Plan:[\s\S]*?(?=\n\n[A-Z])/)?.[0];
  if (testingSection) {
    const testLines = testingSection.split('\n').filter(l => l.trim().startsWith('-') || l.includes('Test'));
    testLines.forEach(line => {
      const cleaned = line.replace(/^[-*]\s*/, '').trim();
      if (cleaned) {
        metadata.testingTasks.push({
          title: cleaned,
          category: 'Testing',
          priority: 'high',
          dueInDays: 14
        });
      }
    });
  }

  // Extract operational processes as action items
  const processesSection = text.match(/Operational Processes and Workflows[\s\S]*?(?=\n\n[A-Z])/)?.[0];
  if (processesSection) {
    // Receiving tasks
    if (processesSection.includes('Receiving:')) {
      metadata.actionItems.push({
        title: 'Set up receiving workflow with serial number capture',
        description: 'Configure BGI warehouse to capture serial numbers at check-in in CargoWise',
        category: 'Receiving',
        priority: 'high',
        dueInDays: 7
      });
    }

    // Inventory Management
    if (processesSection.includes('Inventory Management:')) {
      metadata.actionItems.push({
        title: 'Configure CargoWise inventory tracking',
        description: 'Set up serial number storage and reconciliation with Odoo',
        category: 'Inventory',
        priority: 'high',
        dueInDays: 7
      });
    }

    // Order Fulfillment
    if (processesSection.includes('Order Fulfillment:')) {
      metadata.actionItems.push({
        title: 'Integrate Shopify orders with Navia Fuel app',
        description: 'Configure order ingestion from Shopify to warehouse system',
        category: 'Integration',
        priority: 'high',
        dueInDays: 10
      });
    }

    // Shipping
    if (processesSection.includes('Shipping')) {
      metadata.actionItems.push({
        title: 'Set up ShipStation carrier integration',
        description: 'Configure shipping labels and tracking updates',
        category: 'Shipping',
        priority: 'medium',
        dueInDays: 10
      });
    }
  }

  // Extract known gaps as missing information
  const gapsSection = text.match(/Known Gaps\/Assumptions:[\s\S]*?(?=\n\n[A-Z]|$)/)?.[0];
  if (gapsSection) {
    const gapLines = gapsSection.split('\n').filter(l => l.trim().length > 0 && !l.includes('Known Gaps'));
    gapLines.forEach(line => {
      const cleaned = line.replace(/^[-*]\s*/, '').trim();
      if (cleaned && !cleaned.includes('Assumptions')) {
        metadata.missingInfo.push({
          item: cleaned,
          category: 'Requirements',
          priority: 'medium'
        });
      }
    });
  }

  // Extract acceptance criteria as tasks
  const acceptanceSection = text.match(/Acceptance Criteria:[\s\S]*?(?=Sign-off:|$)/)?.[0];
  if (acceptanceSection) {
    const criteriaLines = acceptanceSection.split('\n').filter(l => l.trim().startsWith('-') || l.includes('validated') || l.includes('tested'));
    criteriaLines.forEach(line => {
      const cleaned = line.replace(/^[-*]\s*/, '').trim();
      if (cleaned) {
        metadata.acceptanceCriteria.push({
          title: `Verify: ${cleaned}`,
          category: 'Acceptance',
          priority: 'high',
          dueInDays: 21
        });
      }
    });
  }

  // Add standard integration setup tasks
  metadata.actionItems.push({
    title: 'Create Navia Fuel sandbox environment',
    description: 'Set up test environment for APS data',
    category: 'Setup',
    priority: 'high',
    dueInDays: 3
  });

  metadata.actionItems.push({
    title: 'Configure data mappings between systems',
    description: 'Map SKUs, weights, dimensions between Odoo, Shopify, and CargoWise',
    category: 'Configuration',
    priority: 'high',
    dueInDays: 7
  });

  metadata.actionItems.push({
    title: 'Set up daily reporting schedule',
    description: 'Configure automated reports for inventory, serial numbers, and shipping',
    category: 'Reporting',
    priority: 'medium',
    dueInDays: 14
  });

  return metadata;
};

// Parse the email
const scopeData = extractMetadata(emailBody);

// Output structured data for Zapier
output = {
  projectTitle: scopeData.project,
  customerName: scopeData.customer,
  systems: scopeData.systems.join(', '),
  actionItemsCount: scopeData.actionItems.length + scopeData.testingTasks.length + scopeData.acceptanceCriteria.length,
  missingInfoCount: scopeData.missingInfo.length,
  allTasks: [
    ...scopeData.actionItems,
    ...scopeData.testingTasks,
    ...scopeData.acceptanceCriteria
  ],
  missingInformation: scopeData.missingInfo
};
```

---

## 🎯 Trello Board Structure for 3PL Scopes

### **Board Name:** "Navia 3PL Integrations"

### **Lists:**

1. **📋 Scope** - New scope documents received
2. **⚙️ Setup** - Initial configuration tasks
3. **🔗 Integration** - System integration tasks
4. **📊 Configuration** - Data mapping and setup
5. **🧪 Testing** - Test cases and validation
6. **✅ Acceptance** - Final acceptance criteria
7. **❓ Missing Info** - Information gaps to resolve
8. **📦 Deployment** - Go-live tasks
9. **✔️ Done** - Completed

### **Labels:**

- 🔴 **High Priority** - Critical path items
- 🟡 **Medium Priority** - Important but not blocking
- 🟢 **Low Priority** - Nice to have
- 🔧 **Setup** - Initial configuration
- 🔗 **Integration** - System connections
- 📊 **Data** - Data mapping/migration
- 🧪 **Testing** - QA tasks
- ✅ **Acceptance** - Final validation
- ❓ **Missing** - Information needed
- 🏷️ **APS** - Customer tag
- 🏷️ **BGI** - Warehouse partner tag

---

## ⚡ Complete Zapier Workflow

### **Zap Name:** "3PL Scope Email → Trello Tasks"

---

### **Step 1: Trigger - New Email in Outlook**

**App:** Email by Zapier (or Microsoft Outlook)

**Configuration:**
- Mailbox: `integrations@navia.com`
- Folder: `3PL Scopes` (create this folder in Outlook)
- Search: `subject:(3PL Scope OR Warehouse 3PL)`

---

### **Step 2: Filter - Only Process Scope Documents**

**App:** Filter by Zapier

**Condition:**
- Email Body contains: `"Navia Freight 3PL Scope Document"`
- OR Subject contains: `"Scope Document Generator"`

---

### **Step 3: Parse Scope Document**

**App:** Code by Zapier (JavaScript)

**Input Data:**
- `emailBody`: From Step 1

**Code:** Use the extraction function above

**Output:**
- `projectTitle`
- `customerName`
- `systems`
- `allTasks` (array)
- `missingInformation` (array)

---

### **Step 4: Create Master Card in "Scope" List**

**App:** Trello

**Action:** Create Card

**Configuration:**
```
Board: Navia 3PL Integrations
List: Scope
Name: {{projectTitle}}
Description:
Customer: {{customerName}}
Systems: {{systems}}

Total Tasks: {{actionItemsCount}}
Missing Info: {{missingInfoCount}}

Created from email: {{email_date}}

Labels: High Priority, APS
Due Date: 30 days from now
```

---

### **Step 5: Loop Through Action Items**

**App:** Looping by Zapier

**Loop On:** `allTasks` from Step 3

---

### **Step 6: Create Task Cards (Inside Loop)**

**App:** Trello

**Action:** Create Card

**Configuration:**
```
Board: Navia 3PL Integrations
List: {{category}} (mapped to appropriate list)
  - Setup → Setup list
  - Integration → Integration list
  - Testing → Testing list
  - Acceptance → Acceptance list
  - Configuration → Configuration list

Name: {{task.title}}
Description:
{{task.description}}

Project: {{projectTitle}}
Customer: {{customerName}}
Category: {{task.category}}

Labels:
  - {{task.priority}} (High/Medium/Low)
  - {{task.category}}
  - APS

Due Date: {{task.dueInDays}} days from now

Checklist:
- [ ] Review requirements
- [ ] Assign owner
- [ ] Implement
- [ ] Test
- [ ] Document
```

---

### **Step 7: Loop Through Missing Information**

**App:** Looping by Zapier

**Loop On:** `missingInformation` from Step 3

---

### **Step 8: Create Missing Info Cards (Inside Loop)**

**App:** Trello

**Action:** Create Card

**Configuration:**
```
Board: Navia 3PL Integrations
List: Missing Info

Name: Gather: {{missing.item}}
Description:
Missing Information Required

Category: {{missing.category}}
Priority: {{missing.priority}}
Project: {{projectTitle}}

Labels: Missing, {{missing.priority}}
Due Date: 7 days from now
```

---

### **Step 9: Send Confirmation Email**

**App:** Email by Zapier

**Configuration:**
```
To: {{sender_email}}
Subject: Tasks Created - {{projectTitle}}

Body:
Hi,

Your 3PL scope document for {{customerName}} has been processed.

✅ Total tasks created: {{actionItemsCount}}
❓ Missing information items: {{missingInfoCount}}

View your project board:
https://trello.com/b/YOUR_BOARD_ID

All tasks have been organized by category:
- Setup tasks: {{setupCount}}
- Integration tasks: {{integrationCount}}
- Testing tasks: {{testingCount}}
- Acceptance tasks: {{acceptanceCount}}

Next steps:
1. Review tasks in Trello
2. Assign team members
3. Address missing information items
4. Start with high-priority setup tasks

Best regards,
Navia 3PL Automation
```

---

## 🧪 Testing the Workflow

### **Test Email:**

**To:** `integrations@navia.com`

**Subject:** `Warehouse 3PL Scope Document Generator`

**Body:** [Paste the entire scope document you provided]

**Expected Result:**
1. ✅ Email detected in "3PL Scopes" folder
2. ✅ Zapier parses the document
3. ✅ Master card created in "Scope" list
4. ✅ ~15-20 task cards created across different lists
5. ✅ ~3-5 missing info cards created
6. ✅ Confirmation email sent back

---

## 📊 Expected Task Breakdown

From your scope document, here's what will be created:

### **Setup Tasks (3-5 cards):**
- Create Navia Fuel sandbox environment
- Configure BGI warehouse access
- Set up data exchange credentials

### **Integration Tasks (5-7 cards):**
- Integrate Shopify with Navia Fuel app
- Configure Odoo ERP connection
- Set up ShipStation carrier integration
- Connect CargoWise for serial tracking
- Configure data mappings

### **Testing Tasks (5-8 cards):**
- Test order ingestion from Shopify
- Test serial number capture at receiving
- Validate ShipStation label creation
- Test Odoo integration and backorders
- Validate CargoWise reporting

### **Acceptance Tasks (4-6 cards):**
- Verify data exchanges validated
- Confirm serial numbers visible in reports
- Validate ShipStation labels generate correctly
- Confirm Odoo backorder support

### **Configuration Tasks (3-5 cards):**
- Map SKUs between systems
- Configure inventory reconciliation
- Set up daily reporting schedule

### **Missing Info Tasks (2-4 cards):**
- Real-time API integration limitations
- Shopify serial number structure
- Custom ERP modifications scope

**Total:** ~25-35 tasks automatically created

---

## 🎨 Advanced: Custom Field Mapping

If you want more detailed extraction:

```javascript
// Enhanced parser with customer-specific detection

const detectCustomer = (text) => {
  const customers = ['APS Systems', 'Customer ABC', 'Company XYZ'];
  for (const customer of customers) {
    if (text.includes(customer)) {
      return customer;
    }
  }
  return text.match(/Customer Name:\s*(.+)/)?.[1] || 'Unknown';
};

const detectSystems = (text) => {
  const systemsList = {
    'Navia Fuel': /Navia Fuel [Aa]pp/,
    'Shopify': /Shopify/,
    'Odoo': /Odoo/,
    'ShipStation': /ShipStation/,
    'CargoWise': /CargoWise/,
    'BGI': /BGI/,
    'SharePoint': /SharePoint/
  };

  const detected = [];
  for (const [system, regex] of Object.entries(systemsList)) {
    if (regex.test(text)) {
      detected.push(system);
    }
  }
  return detected;
};

const extractPrioritizedTasks = (text) => {
  // Extract tasks with priority based on keywords
  const highPriorityKeywords = ['must', 'required', 'critical', 'immediate'];
  const mediumPriorityKeywords = ['should', 'important', 'needed'];

  // ... parsing logic
};
```

---

## 🚀 Alternative: Jira Integration

If you prefer Jira over Trello:

### **Step 6 Alternative: Create Jira Issues**

**App:** Jira Software

**Action:** Create Issue

**Configuration:**
```
Project: 3PL Integrations (INT)
Issue Type: Task
Summary: {{task.title}}
Description:
{{task.description}}

*Project:* {{projectTitle}}
*Customer:* {{customerName}}
*Category:* {{task.category}}

Priority: {{task.priority}}
Labels: {{customerName}}, {{task.category}}
Due Date: {{task.dueInDays}} days from now

Custom Fields:
- Customer: {{customerName}}
- Systems Involved: {{systems}}
- Integration Type: 3PL Warehouse
```

---

## 💡 Quick Start Instructions

### **1. Set Up Email Folder (2 minutes)**

1. Open Outlook
2. Create folder: **"3PL Scopes"**
3. Set up rule: Emails with subject containing "3PL Scope" → Move to folder

### **2. Set Up Trello (5 minutes)**

1. Go to https://trello.com
2. Create board: **"Navia 3PL Integrations"**
3. Create lists as described above
4. Create labels as described
5. Copy Board ID from URL

### **3. Set Up Zapier (15 minutes)**

1. Go to https://zapier.com
2. Create new Zap
3. Follow steps 1-9 above
4. Use the JavaScript code provided
5. Test with sample email

### **4. Test End-to-End (5 minutes)**

1. Send scope document to your email
2. Move to "3PL Scopes" folder
3. Wait 2-3 minutes for Zapier
4. Check Trello board for tasks
5. Verify confirmation email received

---

## ✅ Success Metrics

**After setup, you should have:**
- ✅ 25-35 tasks automatically created
- ✅ Tasks organized by category
- ✅ Proper priorities assigned
- ✅ Due dates calculated
- ✅ Customer tags applied
- ✅ Missing info flagged
- ✅ Confirmation email sent

**Time saved:** 2-3 hours per scope document

---

## 📦 Ready-to-Import Zapier Template

I can create a Zapier template file with all steps configured. Would you like me to generate that?

---

**This workflow requires NO Microsoft admin permissions and works entirely through:**
- ✅ Standard Outlook email (read-only)
- ✅ Zapier (cloud automation)
- ✅ Trello/Jira (task management)

**Ready to set this up?**
