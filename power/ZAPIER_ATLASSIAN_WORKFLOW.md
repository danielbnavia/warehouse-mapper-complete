# Zapier + Atlassian Email-to-Task Automation
## No Microsoft Admin Permissions Required

---

## 🎯 Solution Overview

**Problem:** Need to create/update Planner tasks from emails, but don't have Microsoft admin permissions.

**Solution:** Use Zapier + Atlassian (Trello/Jira) as alternatives that work with standard Outlook email.

---

## 🏗️ Architecture Options

### **Option 1: Zapier → Trello (Recommended - Easiest)**

```
Outlook Email (with scope analysis)
    ↓
Zapier Trigger: New Email in Outlook
    ↓
Zapier Action: Parse Email Body/Attachment
    ↓
Zapier Action: Create Trello Card
    ├─ List: "Action Items" or "Analysis/Software Requirements"
    ├─ Add checklist items
    └─ Set due date
    ↓
Zapier Action: Send confirmation email
```

**Benefits:**
- ✅ No admin permissions needed
- ✅ Visual Kanban board (like Planner)
- ✅ Easy to set up (5 minutes)
- ✅ Free for basic usage
- ✅ Mobile apps available

---

### **Option 2: Zapier → Jira (For Complex Projects)**

```
Outlook Email (with scope analysis)
    ↓
Zapier Trigger: New Email in Outlook
    ↓
Zapier Action: Parse Email Content
    ↓
Zapier Action: Create Jira Issue
    ├─ Project: "3PL Integrations"
    ├─ Issue Type: Task/Story
    ├─ Priority: High/Medium/Low
    └─ Custom fields populated
    ↓
Zapier Action: Add comment with email details
```

**Benefits:**
- ✅ Enterprise-grade project management
- ✅ Advanced workflows and automation
- ✅ Better reporting and analytics
- ✅ Integration with dev tools

---

### **Option 3: Hybrid - Both Trello AND Jira**

```
Outlook Email
    ↓
Zapier Trigger
    ↓
Split to multiple actions:
    ├─→ Create Trello Card (Quick view)
    └─→ Create Jira Issue (Detailed tracking)
```

---

## 📋 Email Format Requirements

**Please provide a sample email with:**

1. **Email Subject Format**
2. **Email Body Structure**
3. **Attachment Format** (if any)

**Example needed:**
```
Subject: New Integration Scope - Shopify to BGI

Body:
[What format will the scope analysis be in?]
- Plain text?
- JSON?
- Markdown?
- Attached file?

Attachments:
[What file format?]
- .txt?
- .json?
- .pdf?
- .docx?
```

---

## 🔧 Zapier Configuration (Once we have email format)

### **Step 1: Trigger Setup**

**Trigger:** Email by Zapier (or Microsoft Outlook connector)

**Configuration:**
- Mailbox: your@email.com
- Label/Folder: "Integration Scopes" (create this in Outlook)
- Search String: `subject:(Integration Scope OR scope analysis OR 3PL)`

---

### **Step 2: Email Parser**

Depending on your email format, we'll use:

**Option A - JSON in Email Body:**
```javascript
// Zapier Code Step
const emailBody = inputData.body;
const jsonMatch = emailBody.match(/\{[\s\S]*\}/);
const scopeData = JSON.parse(jsonMatch[0]);

output = {
  projectTitle: scopeData.scopeDocument.title,
  actionItems: scopeData.actionItems,
  systems: scopeData.analysis.systems,
  missingInfo: scopeData.analysis.missingInformation
};
```

**Option B - Structured Text:**
```javascript
// Extract from formatted text
const lines = inputData.body.split('\n');
const projectTitle = lines.find(l => l.startsWith('Project:')).split(':')[1].trim();
// ... parse other fields
```

**Option C - Attachment:**
```javascript
// Download and parse attachment
const attachment = inputData.attachments[0];
// Parse based on file type
```

---

### **Step 3: Create Trello Cards**

**For each Action Item:**

```
Action: Create Trello Card

Board: NF 3PL Integrations
List: Analysis/Software Requirements
Card Name: {{action_item.title}}
Description:
{{action_item.description}}

Priority: {{action_item.priority}}
Category: {{action_item.category}}
Project: {{project_title}}

Due Date: {{action_item.dueInDays}} days from now
Labels: {{action_item.category}}, {{action_item.priority}}

Checklist: (if applicable)
- [ ] Review requirements
- [ ] Assign to team member
- [ ] Update status
```

---

### **Step 4: Create Cards for Missing Information**

```
Action: Create Trello Card

Board: NF 3PL Integrations
List: Analysis/Software Requirements
Card Name: Gather: {{missing_info.item}}
Description:
Missing Information Required

Category: {{missing_info.category}}
Priority: {{missing_info.priority}}

Labels: Missing Info, {{missing_info.priority}}
```

---

## 🎨 Trello Board Setup

### **Recommended Board Structure:**

**Board Name:** "NF 3PL Integrations"

**Lists (Columns):**
1. **Scope** - Initial scope documents
2. **Analysis/Software Requirements** - Parsed action items
3. **Design** - Technical design tasks
4. **Development** - Implementation tasks
5. **Testing** - QA tasks
6. **Documentation** - Docs to create
7. **Deployment** - Go-live tasks
8. **Done** - Completed items

**Labels:**
- 🔴 High Priority
- 🟡 Medium Priority
- 🟢 Low Priority
- 📋 Action Item
- ❓ Missing Info
- 🔧 Technical
- 📊 Business
- 🚀 Deployment

---

## 📊 Jira Setup (Alternative)

### **Project Configuration:**

**Project Name:** "3PL Integrations"
**Project Key:** "INT"

**Issue Types:**
- Epic: Major integration project
- Story: Feature/Integration requirement
- Task: Action item
- Sub-task: Checklist items
- Bug: Issues to resolve

**Custom Fields:**
- Customer Name
- Systems Involved (multi-select)
- Integration Type (dropdown)
- Missing Information (text area)
- Scope Document Link

---

## 🔄 Complete Zapier Workflow (Detailed)

### **Zap Name:** "Email Scope → Trello/Jira Tasks"

**Steps:**

1. **Trigger: New Email in Outlook**
   - Folder: "Integration Scopes"
   - Has attachments: Optional

2. **Action: Extract Email Data**
   - Code by Zapier (JavaScript)
   - Parse email body or attachment
   - Output structured data

3. **Action: Iterate Action Items**
   - Looping by Zapier
   - Loop through action items array

4. **Action: Create Trello Card (inside loop)**
   - Board: NF 3PL Integrations
   - List: Analysis/Software Requirements
   - Populate from parsed data

5. **Action: Iterate Missing Info**
   - Loop through missing information items

6. **Action: Create Trello Card (inside loop)**
   - Board: NF 3PL Integrations
   - List: Analysis/Software Requirements
   - Mark as "Missing Info"

7. **Action: Send Confirmation Email**
   - To: Original sender
   - Subject: "Tasks Created - {{project_title}}"
   - Body: Summary with Trello board link

---

## 🧪 Testing Workflow

### **Test Email Format:**

**Send this to your Outlook (Integration Scopes folder):**

```
Subject: Test Integration Scope - Shopify to BGI

Body:
{
  "timestamp": "2025-11-16T10:30:00Z",
  "scopeDocument": {
    "title": "Test Integration - Shopify to BGI",
    "rawText": "Sample scope..."
  },
  "analysis": {
    "systems": ["Shopify", "BGI", "ShipStation"],
    "missingInformation": [
      {
        "item": "Shopify API credentials",
        "category": "Technical",
        "priority": "high"
      }
    ]
  },
  "actionItems": [
    {
      "title": "Configure Shopify webhook",
      "description": "Set up webhook for order events",
      "priority": "high",
      "category": "Technical Setup",
      "dueInDays": 3
    }
  ]
}
```

---

## 🔗 Integration with Scope Mapper PRO

### **Updated Export Flow:**

Instead of Power Automate webhook, Scope Mapper PRO can:

**Option 1: Email the JSON**
```javascript
// In Scope Mapper PRO
function exportToEmail() {
  const analysisData = generateAnalysis();
  const emailBody = JSON.stringify(analysisData, null, 2);

  // Open email client with pre-filled data
  window.location.href = `mailto:integrations@navia.com?subject=New Integration Scope - ${projectTitle}&body=${encodeURIComponent(emailBody)}`;
}
```

**Option 2: Email with Attachment**
```javascript
// Create JSON file and attach
const blob = new Blob([JSON.stringify(analysisData, null, 2)], {type: 'application/json'});
const file = new File([blob], 'scope-analysis.json');

// User attaches to email manually
// Or use Web Share API if supported
```

---

## 💰 Cost Comparison

### **Trello:**
- Free: Unlimited cards, 10 boards
- Standard: $5/user/month - More automation
- Premium: $10/user/month - Advanced features

### **Jira:**
- Free: Up to 10 users
- Standard: $7.75/user/month
- Premium: $15.25/user/month

### **Zapier:**
- Free: 100 tasks/month
- Starter: $19.99/month - 750 tasks
- Professional: $49/month - 2000 tasks

**Recommendation:** Start with all free tiers, upgrade if needed.

---

## 🚀 Quick Start Guide

### **1. Set Up Trello (5 minutes)**

1. Go to https://trello.com
2. Create account (free)
3. Create board: "NF 3PL Integrations"
4. Add lists: Scope, Analysis, Design, Development, etc.
5. Note the Board ID from URL

### **2. Set Up Zapier (10 minutes)**

1. Go to https://zapier.com
2. Create account
3. Click "Create Zap"
4. Trigger: Outlook → New Email
5. Configure folder filter
6. Test trigger with sample email

### **3. Configure Parser (depends on email format)**

Once you provide the email format, I'll give you the exact JavaScript code for parsing.

### **4. Add Trello Actions**

1. Add "Create Trello Card" action
2. Connect to your Trello account
3. Map fields from parsed data
4. Test with sample email

---

## 📧 What I Need From You

**Please provide:**

1. **Sample email** with the scope analysis data
   - How does it appear in the email body?
   - Is it JSON? Plain text? Formatted?

2. **Or sample attachment**
   - What file format?
   - What's the structure?

3. **Preferred option:**
   - Trello?
   - Jira?
   - Both?

---

## 🎯 Expected Outcome

Once configured:

1. **Scope Mapper PRO** exports analysis
2. **Email sent** to your Outlook
3. **Zapier detects** new email in "Integration Scopes" folder
4. **Parser extracts** data (JSON or text)
5. **Trello cards created** automatically
6. **Confirmation email** sent back to you
7. **Team can view** tasks in Trello board

**Time:** ~30 seconds from email to Trello cards

**No Microsoft admin permissions required!** ✅

---

**Paste your sample email format below, and I'll create the exact Zapier configuration!**
