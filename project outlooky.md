
# Complete Intelligent 3PL Project Management System with Zapier, Jira & Outlook

## System Architecture Overview (Outlook-Optimized)

Your system will use **Outlook** as the email source with these 5 core workflows:

1. **Outlook Email Intelligence Engine** - AI-powered email classification
2. **Jira Project Synchronization** - Automated task creation/updates
3. **Project Context Tracking** - Google Sheets knowledge base
4. **Email-to-Task Automation** - Outlook → Jira workflow
5. **Smart Notification System** - Microsoft Teams/Slack alerts

---

## Core Component 1: Outlook Email Intelligence Engine

## Zap 1: Intelligent Outlook Email Classifier & Project Matcher

**Workflow Architecture:**

```text
Trigger: Outlook - New Email
    ↓
Action 1: Email Parser - Extract structured data
    ↓
Action 2: OpenAI (ChatGPT) - AI Classification & Project Matching
    ↓
Action 3: Google Sheets - Lookup project database
    ↓
Action 4: Code by Zapier - Intelligent matching algorithm
    ↓
Action 5: Paths - Route based on confidence
    ↓
    → Path A: High Confidence → Create Jira Task
    → Path B: Multiple Matches → Request Clarification
    → Path C: No Match → Log for review
    ↓
Action 6: Outlook - Apply categories/flags
    ↓
Action 7: Outlook - Move to project-specific folder
```

## Detailed Configuration:

**Trigger: Microsoft Outlook - New Email**

Zapier's native Outlook integration options:

* **Option 1:** "New Email" - Triggers on any new email in inbox
* **Option 2:** "New Email in Folder" - Triggers only for specific Outlook folder
* **Option 3:** "New Email Matching Search" - Use Outlook search query

**Recommended Configuration:**

* Trigger: **New Email Matching Search**
* Search Query:

  ```text
  from:@client-domain.com OR from:@partner-domain.com OR 
  subject:"Shopify" OR subject:"CargoWise" OR subject:"BGI" OR 
  subject:"warehouse" OR subject:"integration"
  ```
* Folder: `Inbox` (or specific folder like `3PL Projects`)
* Include Attachments: Yes (in case of error screenshots, logs)

**Advanced Outlook Search Syntax for Project Filtering:**

```text
(from:@acmecorp.com OR from:@partnername.com) AND 
(subject:"order" OR subject:"integration" OR subject:"bug" OR subject:"urgent") AND 
received:>= today-7
```

**Action 1: Email Parser by Zapier**

Since Outlook trigger already provides structured data, you can work directly with it, but Email Parser adds AI extraction capabilities:

**Option A: Use Outlook trigger data directly** (simpler):

* Subject: `{{Outlook - Subject}}`
* Body: `{{Outlook - Body Plain}}` or `{{Outlook - Body HTML}}`
* From: `{{Outlook - From Email}}`
* Date: `{{Outlook - Date Received}}`
* Conversation ID: `{{Outlook - Conversation ID}}`

**Option B: Forward to Email Parser mailbox** (more powerful):

* Create Email Parser mailbox: `3pl-outlook-intelligence@parser.zapier.com`
* Set up Outlook rule to auto-forward matching emails to parser
* Parser extracts custom fields with templates

**Recommended: Use Option A** for direct integration, fewer hops.

**Action 2: OpenAI (ChatGPT) - AI Project Classification**

Use the same comprehensive AI prompt from before, but update the inputs:

```text
Conversation with AI Assistant:

You are an expert 3PL integration project analyzer. Analyze this Outlook email and extract project intelligence.

INPUTS:
- Email From: {{Outlook - From Email}}
- Email Subject: {{Outlook - Subject}}
- Email Body: {{Outlook - Body Plain}}
- Email Date: {{Outlook - Date Received}}
- Email Has Attachments: {{Outlook - Has Attachments}}
- Conversation Thread: {{Outlook - Conversation ID}}

CONTEXT - ACTIVE PROJECTS (will be inserted dynamically):
[Google Sheets project data]

ANALYZE AND RETURN JSON:
{
  "classification": {
    "email_type": "bug_report" | "status_update" | "feature_request" | "question" | "notification",
    "priority": "critical" | "high" | "medium" | "low",
    "requires_action": true | false,
    "sentiment": "positive" | "neutral" | "negative" | "urgent"
  },
  "project_matching": {
    "matched_projects": [{
      "project_key": "PROJ-001",
      "project_name": "Shopify BGI Integration - Acme Corp",
      "confidence_score": 0.95,
      "matching_reasons": ["sender from acme.com", "mentions Shopify orders", "references ticket #123"]
    }],
    "match_confidence": "high" | "medium" | "low" | "none"
  },
  "entities_extracted": {
    "customer_names": ["Acme Corp"],
    "system_names": ["Shopify", "BGI", "CargoWise"],
    "people_mentioned": ["John Smith"],
    "order_numbers": ["ORD-12345"],
    "ticket_references": ["TICKET-123", "Case #456"],
    "error_codes": ["ERR-500", "TIMEOUT"],
    "integration_points": ["order webhook", "inventory sync"],
    "dates_mentioned": ["2025-11-20", "next Tuesday"]
  },
  "action_items": [{
    "task_title": "Fix Shopify webhook timeout for large orders",
    "task_description": "Customer reports webhook failures for orders >$1000. Error ERR-500.",
    "task_type": "bug",
    "priority": "high",
    "estimated_effort": "2-4 hours",
    "suggested_assignee": "api-team",
    "due_date": "2025-11-20"
  }],
  "email_summary": "Acme Corp reporting Shopify webhook timeout errors affecting high-value orders. Immediate API investigation required.",
  "follow_up_required": true,
  "requires_immediate_attention": false
}
```

**Action 3: Google Sheets - Lookup Project Database**

**Tab 1: Active Projects** (same structure as before)

```text
Columns:
- Project Key (PROJ-001)
- Jira Project Key (SHOP-ACME)
- Project Name
- Customer Name
- Customer Email Domain (acme.com)
- System Keywords (Shopify, BGI, CargoWise, webhook, order sync)
- Primary Contact Email
- Outlook Folder Name (for auto-filing)
- Status (Active/On Hold/Completed)
- Jira Board ID
- Teams Channel URL
- Created Date
- Go-Live Date
- Last Email Received
```

**Lookup Action:**

* Spreadsheet: `3PL Projects Master Database`
* Worksheet: `Active Projects`
* Lookup Column: `Customer Email Domain`
* Lookup Value: Use Formatter to extract domain from `{{Outlook - From Email}}`
  * Formula: `SPLIT({{Outlook - From Email}}, "@")[1]`
* Return: All columns

**Action 4: Code by Zapier - Enhanced Project Matching with Outlook Context**

```javascript
// Enhanced for Outlook-specific data
const aiClassification = JSON.parse(inputData.chatgpt_output);
const projectData = inputData.sheets_project_lookup;
const emailFrom = inputData.outlook_from_email;
const emailSubject = inputData.outlook_subject;
const emailBody = inputData.outlook_body;
const conversationId = inputData.outlook_conversation_id;
const hasAttachments = inputData.outlook_has_attachments === 'true';

// Intelligent matching with Outlook metadata
function matchProject(ai, db, email) {
  let matches = [];
  let matchScore = 0;
  
  // Priority 1: Database lookup by sender domain (highest confidence)
  if (db && db.status === 'Active') {
    matchScore = 70; // Base score for domain match
  
    // Boost score based on keyword matches
    const projectKeywords = db.system_keywords.toLowerCase().split(',');
    const emailText = (emailSubject + ' ' + emailBody).toLowerCase();
  
    projectKeywords.forEach(keyword => {
      if (emailText.includes(keyword.trim())) {
        matchScore += 5;
      }
    });
  
    // Boost if AI also identified this project
    const aiMatchesThis = ai.project_matching.matched_projects.find(
      p => p.project_key === db.project_key
    );
    if (aiMatchesThis) {
      matchScore += 20;
    }
  
    // Check if this is part of existing conversation thread
    // (Outlook Conversation ID helps maintain context)
    if (conversationId) {
      matchScore += 10; // Bonus for threaded conversation
    }
  
    if (matchScore >= 70) {
      matches.push({
        project_key: db.project_key,
        project_name: db.project_name,
        jira_project_key: db.jira_project_key,
        outlook_folder: db.outlook_folder_name,
        teams_channel: db.teams_channel_url,
        confidence: matchScore >= 90 ? 'high' : 'medium',
        match_score: matchScore,
        source: 'database_primary',
        match_reasons: [
          'Sender domain matches project',
          `${matchScore - 70} keyword matches found`,
          aiMatchesThis ? 'AI confirmed match' : 'Database only match'
        ]
      });
    }
  }
  
  // Priority 2: AI-only matches (for new projects not yet in database)
  if (matches.length === 0 && ai.project_matching.matched_projects.length > 0) {
    ai.project_matching.matched_projects.forEach(aiProject => {
      matches.push({
        ...aiProject,
        jira_project_key: 'NEW_PROJECT_DETECTED',
        outlook_folder: 'Unclassified',
        confidence: 'low',
        match_score: aiProject.confidence_score * 100,
        source: 'ai_new_project',
        match_reasons: [...aiProject.matching_reasons, 'Not in database - potential new project']
      });
    });
  }
  
  // Sort by match score
  matches.sort((a, b) => b.match_score - a.match_score);
  
  return matches;
}

// Execute matching
const projectMatches = matchProject(aiClassification, projectData, {
  from: emailFrom,
  subject: emailSubject,
  body: emailBody
});

// Routing decision
let routingDecision;
if (projectMatches.length === 1 && projectMatches[0].confidence === 'high') {
  routingDecision = 'create_jira_task';
} else if (projectMatches.length > 1) {
  routingDecision = 'request_clarification';
} else if (projectMatches.length === 1 && projectMatches[0].confidence === 'medium') {
  routingDecision = 'create_jira_task_needs_review';
} else {
  routingDecision = 'log_unmatched';
}

// Check for urgent flags
const isUrgent = 
  aiClassification.classification.priority === 'critical' ||
  aiClassification.classification.requires_immediate_attention ||
  emailSubject.toLowerCase().includes('urgent') ||
  emailSubject.toLowerCase().includes('asap') ||
  hasAttachments && aiClassification.classification.email_type === 'bug_report';

// Output
output = {
  matches: projectMatches,
  match_count: projectMatches.length,
  top_match: projectMatches[0] || null,
  classification: aiClassification.classification,
  action_items: aiClassification.action_items,
  entities: aiClassification.entities_extracted,
  email_summary: aiClassification.email_summary,
  routing_decision: routingDecision,
  is_urgent: isUrgent,
  conversation_id: conversationId,
  processing_timestamp: new Date().toISOString()
};
```

**Action 5: Paths by Zapier - Route Based on Match Confidence**

**Path A: High Confidence Match → Create Jira Task**

* Continue if: `{{Code - routing_decision}}` equals "create_jira_task"
* OR: `{{Code - routing_decision}}` equals "create_jira_task_needs_review" AND `{{Code - is_urgent}}` is true

**Path B: Multiple Matches → Request Clarification**

* Continue if: `{{Code - routing_decision}}` equals "request_clarification"
* **Action: Microsoft Teams - Post to Channel** (asking project manager to classify)
* **Action: Outlook - Flag email** with Follow Up flag
* **Action: Outlook - Add category** "Needs Classification"

**Path C: No Match → Log for Review**

* Continue if: `{{Code - routing_decision}}` equals "log_unmatched"
* **Action: Google Sheets - Add to "Unmatched Emails" sheet**
* **Action: Outlook - Move to folder** "Unclassified - Review Required"

**Action 6: Microsoft Outlook - Apply Categories**

Zapier's Outlook integration allows you to set categories (color-coded labels):

* **Action: Outlook - Update Email**
* Email ID: `{{Outlook - Message ID}}`
* Categories:
  * `{{Project Name}}` (e.g., "Shopify-Acme")
  * `{{Priority}}` (e.g., "High Priority")
  * `{{Email Type}}` (e.g., "Bug Report")
  * Add: `Processed by Automation`

**Action 7: Microsoft Outlook - Move Email to Project Folder**

* **Action: Outlook - Move Email**
* Email ID: `{{Outlook - Message ID}}`
* Destination Folder: `{{Code - top_match - outlook_folder}}`
  * Example folder structure:

    ```text
    📁 Inbox
    📁 3PL Projects
      📁 Shopify-Acme (Active)
      📁 WooCommerce-BetaCo (Active)
      📁 Multi-Warehouse-GammaCorp (Testing)
      📁 Archived Projects
    📁 Unclassified - Review Required
    📁 Support Tickets
    ```

This keeps your Outlook organized automatically based on project matching.

---

## Core Component 2: Outlook-to-Jira Automation

## Zap 2: Create Jira Tasks from Outlook Intelligence

**Workflow:**

```text
Trigger: Webhooks - Receive from Zap 1 (Path A)
    ↓
Action 1: Filter - Validate Jira project exists
    ↓
Action 2: Jira - Search existing issues
    ↓
Action 3: Paths - Create new or update existing
    ↓
Action 4: Jira - Create issue with custom fields
    ↓
Action 5: Jira - Add Outlook email link
    ↓
Action 6: Outlook - Reply to sender (acknowledgment)
    ↓
Action 7: Microsoft Teams - Notify team
    ↓
Action 8: Google Sheets - Log task creation
```

**Key Outlook-Specific Actions:**

**Action 6: Microsoft Outlook - Send Email (Auto-Reply)**

Send automatic acknowledgment to the email sender:

* **To:** `{{Outlook - From Email}}`
* **Subject:** `RE: {{Outlook - Subject}}`
* **Body:**

  ```html
  <p>Hi {{Outlook - From Name}},</p>

  <p>Thank you for your email regarding <strong>{{Project Name}}</strong>.</p>

  <p>We've automatically created a task to track this:</p>
  <ul>
    <li><strong>Task ID:</strong> {{Jira - Issue Key}}</li>
    <li><strong>Priority:</strong> {{Jira - Priority}}</li>
    <li><strong>Assigned To:</strong> {{Jira - Assignee Name}}</li>
  </ul>

  <p><a href="{{Jira - Issue URL}}">View task in Jira →</a></p>

  <p>Our team will review and respond shortly. For urgent matters, please call our support line.</p>

  <p>Best regards,<br>
  3PL Operations Team<br>
  <em>This is an automated response</em></p>
  ```
* **Importance:** Set to "High" if `{{Code - is_urgent}}` is true

**Action 7: Microsoft Teams - Post Adaptive Card to Channel**

Post rich notification to project-specific Teams channel:

```json
{
  "type": "AdaptiveCard",
  "version": "1.4",
  "body": [
    {
      "type": "TextBlock",
      "text": "📧 New Task from Email",
      "weight": "Bolder",
      "size": "Large"
    },
    {
      "type": "FactSet",
      "facts": [
        {
          "title": "Project:",
          "value": "{{Project Name}}"
        },
        {
          "title": "Task:",
          "value": "{{Jira - Issue Key}} - {{Jira - Summary}}"
        },
        {
          "title": "Priority:",
          "value": "{{Jira - Priority}}"
        },
        {
          "title": "From:",
          "value": "{{Outlook - From Name}} ({{Outlook - From Email}})"
        },
        {
          "title": "Assigned:",
          "value": "{{Jira - Assignee Name}}"
        }
      ]
    },
    {
      "type": "TextBlock",
      "text": "**Quick Summary:**\n{{Email Summary}}",
      "wrap": true
    }
  ],
  "actions": [
    {
      "type": "Action.OpenUrl",
      "title": "View in Jira",
      "url": "{{Jira - Issue URL}}"
    },
    {
      "type": "Action.OpenUrl",
      "title": "View Email in Outlook",
      "url": "https://outlook.office.com/mail/deeplink/read/{{Outlook - Message ID}}"
    }
  ]
}
```

This creates clickable cards in Teams with direct links to both Jira and the original Outlook email.

---

## Complete Outlook Folder Structure & Auto-Filing

Set up your Outlook folders for automatic organization:

```text
📧 Outlook Mailbox
│
├── 📁 Inbox (incoming emails land here)
│
├── 📁 3PL Projects (auto-filed by Zap)
│   ├── 📁 Active
│   │   ├── 📁 Shopify-Acme
│   │   ├── 📁 WooCommerce-BetaCo
│   │   ├── 📁 CargoWise-GammaCorp
│   │   └── 📁 Multi-Warehouse-DeltaInc
│   │
│   ├── 📁 Testing Phase
│   │   ├── 📁 Shopify-EpsilonCo
│   │   └── 📁 BGI-ZetaCorp
│   │
│   └── 📁 Completed (archive after go-live)
│
├── 📁 Unclassified - Review Required (no project match)
│
├── 📁 Support Tickets (general support, not project-specific)
│
└── 📁 Processed Archive (after task creation)
```

**Zap Action: Create folder structure automatically**

Add this to your setup workflow:

**Zap 3: Auto-Create Outlook Folders for New Projects**

```text
Trigger: Google Sheets - New Row in "Active Projects"
    ↓
Action: Microsoft Outlook - Create Folder
    - Folder Name: {{Project Name}}
    - Parent Folder: "3PL Projects/Active"
    ↓
Action: Google Sheets - Update row with folder name
```

---

## Integration with Your Existing Power Automate Flows

Since you're already using Power Automate, you can create a **hybrid system**:

## Option 1: Zapier Handles Email Intelligence → Power Automate Handles Business Logic

**Flow:**

```text
Outlook Email → Zapier (AI Classification) → 
Webhook to Power Automate → PA Flow (Business Logic) → 
Jira/SharePoint/Teams Updates
```

**Why:** Zapier has better AI integrations (OpenAI), Power Automate has deeper Microsoft 365 integration

## Option 2: Full Zapier Replacement (Recommended for Simplicity)

**Flow:**

```text
Outlook Email → Zapier (All steps) → Jira + Teams + Sheets
```

**Why:** Single platform, easier to manage, lower cost per task

## Option 3: Power Automate Primary, Zapier for Advanced AI

**Flow:**

```text
Outlook Email → Power Automate → 
(Complex cases) → Webhook to Zapier AI → 
Response back to Power Automate → Continue PA Flow
```

**Why:** Leverage existing PA infrastructure, add AI only when needed

---

## Microsoft 365 Native Outlook Rules (Pre-Filter)

Before emails even reach Zapier, use Outlook rules to pre-organize:

**Outlook Rule 1: High-Priority Client Emails**

* Conditions:
  * From: addresses in "VIP Clients" contact group
  * OR Subject contains: "urgent", "critical", "down", "error"
* Actions:
  * Mark as Important
  * Play a sound
  * Move to "Priority Review" folder
  * **Then let Zapier process from this folder**

**Outlook Rule 2: Known Project Senders**

* Conditions:
  * From: @acmecorp.com
* Actions:
  * Apply category: "Acme Corp"
  * Keep in Inbox (for Zapier to process)

**Outlook Rule 3: Auto-Archive Low-Priority**

* Conditions:
  * From: no-reply@ addresses
  * Subject contains: "newsletter", "digest", "unsubscribe"
* Actions:
  * Move to Archive
  * Mark as Read
  * **Skip Zapier processing**

This reduces Zapier task usage and filters noise before automation.

---

## Complete System Summary: Outlook Edition

**Email Flow:**

1. **Email arrives in Outlook** → Outlook rule pre-filters
2. **Zapier Zap 1 triggers** → AI analyzes and classifies
3. **Google Sheets lookup** → Matches to project database
4. **Intelligent routing** → High confidence goes to Jira
5. **Jira task created** → With custom fields and links
6. **Outlook organized** → Email moved to project folder, categorized
7. **Teams notified** → Project channel gets rich card
8. **Sender acknowledged** → Auto-reply sent confirming task creation
9. **Tracking logged** → Google Sheets records all activity

**Your Benefits:**

* ✅ **Zero manual email triage** - AI handles classification
* ✅ **Automatic Jira task creation** - from intelligent email analysis
* ✅ **Organized Outlook** - auto-filed by project
* ✅ **Team awareness** - Teams notifications with context
* ✅ **Customer communication** - auto-acknowledgments
* ✅ **Audit trail** - everything logged in Google Sheets
* ✅ **Works with existing Power Automate** - hybrid or full replacement

**Next Steps:**

1. Set up Google Sheets project database
2. Create Outlook folders structure
3. Build Zap 1 (Email Intelligence)
4. Build Zap 2 (Jira Creation)
5. Test with sample emails
6. Deploy to production
7. Train team on new system

Would you like me to detail any specific part, such as the exact Jira custom fields setup, the Teams adaptive card template, or the Google Sheets formulas for project tracking?
