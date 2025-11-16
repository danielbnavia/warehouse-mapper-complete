# Intelligent Scope Mapper PRO - Complete Guide

**Version:** 3.0 PRO  
**Date:** November 16, 2025  
**New Feature:** Power Automate Flow Export 🚀

---

## 🎯 What's NEW in PRO Version

### **Power Automate Integration**

The PRO version automatically detects automation opportunities and generates **ready-to-import Power Automate flows**!

| **Feature** | **Free Version** | **PRO Version** |
|------------|-----------------|----------------|
| Workflow mapping | ✅ | ✅ |
| System detection | 14 systems | 14 systems + automation detection |
| Export formats | JSON, Markdown | JSON, MD, **+ Power Automate Flow** |
| Templates | 3 standard | 3 standard + **Email Bug Tracking** |
| AI detection | Basic | **Enhanced with PA patterns** |
| Automation opportunities | ❌ | **✅ Auto-detected** |

---

## 🚀 Key Enhancements

### **1. Auto-Detection of Automation Opportunities**

The tool now recognizes these Power Automate patterns:

| **Pattern** | **Triggered By Keywords** | **Generates** |
|------------|--------------------------|---------------|
| **Email Processing** | "email parse", "email monitor", "support email" | Email parser with AI extraction |
| **Bug Tracking** | "bug", "issue tracking" | Bug report automation with Planner |
| **Webhook Handler** | "webhook", "api" | Multi-system webhook orchestration |
| **Invoice Processing** | "invoice" + "process"/"extract" | AI invoice data extraction |

### **2. Power Automate Flow Preview**

When automation opportunities are detected, you'll see:

```
⚡ Detected Power Automate Opportunities
┌────────────────────────────────────────┐
│ 1. Email Parser with AI                │
│ Trigger: When new email arrives        │
│ Parse support emails and create tasks  │
└────────────────────────────────────────┘
```

### **3. One-Click Flow Export**

Click **"⚡ Export Power Automate Flow"** to download:
- Production-ready JSON file
- Importable directly into Power Automate
- Pre-configured with best practices from the power-automate-expert skill

### **4. New Template: Email Bug Tracking**

A complete email-to-Planner automation template specifically for Raft.ai workflows!

---

## 📋 Quick Start Guide

### **Option 1: Standard Workflow Mapping** (No changes from v2.0)

1. Paste integration scope or load template
2. Click **"Analyze & Generate Flow"**
3. Review 4-column workflow
4. Export JSON/Markdown

**Time:** 2-3 minutes

---

### **Option 2: Generate Power Automate Flow** (NEW!)

1. **Load Email Bug Tracking Template** (or paste scope with email keywords)
2. Click **"Analyze & Generate Flow"**
3. See **Power Automate Opportunities** section appear
4. Click **"📥 Export Power Automate Flow JSON"**
5. Import in Power Automate:
   - Go to https://flow.microsoft.com
   - Click "My flows" → "Import" → "Import Package (Legacy)"
   - Upload the JSON file
   - Configure connections (Outlook, SharePoint, Planner)
   - Save and test!

**Time:** 5 minutes total (including PA import)

---

## 🎨 UI Changes

### **New Power Automate Section** (Left Panel)

```
┌───────────────────────────────────────┐
│ ⚡ Power Automate Export              │
│                                       │
│ Generate ready-to-import flows       │
│ based on your integration scope      │
│                                       │
│ [📥 Export Power Automate Flow JSON] │
└───────────────────────────────────────┘
```

**Status:**
- **Disabled** (gray) when no opportunities detected
- **Enabled** (blue) when automation patterns found

### **Enhanced Analysis Cards**

New metric card added:

```
┌─────────────────┐
│ PA Automations  │
│      2          │  ← Number of detected opportunities
└─────────────────┘
```

### **Power Automate Preview Panel**

Appears below analysis when opportunities detected:

```
⚡ Detected Power Automate Opportunities
┌────────────────────────────────────────────────┐
│ 1. Email Parser with AI                        │
│ Trigger: When new email arrives                │
│ Parse support emails and create structured...  │
├────────────────────────────────────────────────┤
│ 2. Bug Report Automation                       │
│ Trigger: When email arrives with bug report    │
│ Extract bug details with AI and create...      │
└────────────────────────────────────────────────┘
```

---

## 🔍 Detection Examples

### **Example 1: Email Workflow Detection**

**Input Scope:**
```
We need email parsing for support tickets.
Emails arrive at support@company.com.
Create tasks in Microsoft Planner automatically.
```

**Detection Result:**
```
✅ Systems: Outlook, Microsoft Planner
✅ Processes: Email-based workflow automation
✅ PA Opportunities: 1
   → Email Parser with AI
```

**Generated Flow:**
- Trigger: When new email arrives (Outlook)
- Action 1: Extract data with Azure OpenAI
- Action 2: Parse JSON response
- Action 3: Create Planner task
- Action 4: Send confirmation email

---

### **Example 2: Bug Tracking Detection**

**Input Scope:**
```
Raft.ai processes bug reports from email.
Extract: title, description, priority, affected system.
Track in SharePoint list.
Send notifications to dev team.
```

**Detection Result:**
```
✅ Systems: Raft.ai, SharePoint, Outlook
✅ Processes: Bug/Issue tracking automation, Email-based workflow
✅ PA Opportunities: 2
   → Email Parser with AI
   → Bug Report Automation
```

**Generated Flow:**
- Email trigger with subject filter ("bug", "issue", "error")
- AI extraction of bug details
- SharePoint list item creation
- Planner task assignment
- Confirmation email

---

### **Example 3: Multi-System Integration**

**Input Scope:**
```
Shopify webhooks trigger order processing.
Update CargoWise, BGI warehouse, and ShipStation.
Real-time parallel updates required.
```

**Detection Result:**
```
✅ Systems: Shopify, CargoWise, BGI, ShipStation
✅ Processes: Shipping & tracking updates
✅ PA Opportunities: 1
   → Multi-System Webhook Handler
```

**Generated Flow:**
- HTTP trigger (webhook endpoint)
- Immediate 202 response
- Parallel branches for each system
- Error handling scope
- Audit logging

---

## 📥 Power Automate Flow Types

### **1. Email Parser with AI**

**Use Case:** Process support/bug/inquiry emails automatically

**Flow Structure:**
```
Trigger: Email arrives
├─ Initialize CorrelationID (tracking)
├─ Clean email body
├─ HTTP: Azure OpenAI (extract structured data)
├─ Parse JSON response
├─ Create SharePoint item
└─ Send confirmation email
```

**Required Connections:**
- Office 365 Outlook
- SharePoint
- HTTP (Azure OpenAI endpoint)

**Customization Points:**
- Email folder path
- SharePoint site/list
- AI prompt template
- Notification recipients

---

### **2. Bug Report Automation**

**Use Case:** Raft.ai style bug tracking from emails

**Flow Structure:**
```
Trigger: Email with "bug"/"issue"/"error" in subject
├─ Extract bug details via AI
├─ Create Planner task (assigned to dev team)
├─ Create SharePoint tracking record
├─ Send Slack/Teams notification
└─ Reply to reporter with bug ID
```

**Required Connections:**
- Office 365 Outlook
- Microsoft Planner
- SharePoint
- Slack or Teams (optional)

---

### **3. Multi-System Webhook Handler**

**Use Case:** Shopify/CargoWise/3PL integrations

**Flow Structure:**
```
Trigger: HTTP POST
├─ Immediate Response (202 Accepted)
├─ Parse webhook payload
├─ Parallel Scope:
│   ├─ Update CargoWise
│   ├─ Update Shopify
│   ├─ Update Internal DB
│   └─ Send customer notification
├─ Error handling scope
└─ Log to audit table
```

**Required Connections:**
- HTTP (multiple endpoints)
- SharePoint (audit logging)

---

### **4. Invoice Processing**

**Use Case:** AI-powered invoice data extraction

**Flow Structure:**
```
Trigger: Email with attachment (invoice)
├─ AI Builder: Form Recognizer (process invoice)
├─ Parse extracted data
├─ Validate against PO database
├─ Condition: Match found?
│   ├─ Yes: Auto-approve
│   └─ No: Manual review queue
└─ Update accounting system
```

**Required Connections:**
- Office 365 Outlook
- AI Builder
- SharePoint or Dataverse

---

## 🛠️ Import & Configure Guide

### **Step 1: Export from Scope Mapper PRO**

1. Load template or analyze custom scope
2. Verify **PA Opportunities** detected
3. Click **"📥 Export Power Automate Flow JSON"**
4. Save file (e.g., `power-automate-email_processing-1234567890.json`)

---

### **Step 2: Import to Power Automate**

1. Go to https://flow.microsoft.com
2. Click **"My flows"**
3. Click **"Import"** → **"Import Package (Legacy)"**
4. Upload the JSON file
5. Click **"Import"**

---

### **Step 3: Configure Connections**

**Email Parser Flow:**
```
⚠️ Action Required:

1. Office 365 Outlook
   → Sign in with your work account
   
2. SharePoint
   → Sign in
   → Update: Site URL, List name
   
3. HTTP (Azure OpenAI)
   → Update URI: YOUR_AZURE_OPENAI_ENDPOINT
   → Update headers: YOUR_API_KEY
```

**Bug Tracking Flow:**
```
⚠️ Action Required:

1. Office 365 Outlook
   → Configure email filter
   
2. Microsoft Planner
   → Sign in
   → Update Plan ID: YOUR_PLAN_ID
   → Update Bucket ID (optional)
   
3. SharePoint
   → Update Site/List for tracking
```

---

### **Step 4: Customize & Test**

**Customization Checklist:**

- [ ] Update email trigger folder/filters
- [ ] Configure SharePoint site/list URLs
- [ ] Set Azure OpenAI endpoint + API key
- [ ] Adjust AI prompt for your use case
- [ ] Update Planner plan/bucket IDs
- [ ] Configure notification recipients
- [ ] Test with sample data

**Testing:**
1. Send test email that matches trigger
2. Check flow run history
3. Verify actions completed successfully
4. Check created items in SharePoint/Planner
5. Confirm notifications sent

---

## 🎯 Use Cases by Department

### **Product/IT Team**

**Use Scope Mapper PRO to:**
- ✅ Document integration requirements
- ✅ Generate automation flows for dev team
- ✅ Create technical handoff packages
- ✅ Validate scope completeness

**Workflow:**
1. Gather requirements from stakeholders
2. Load relevant template (e.g., Multi-Warehouse)
3. Customize in text box
4. Export Markdown for documentation
5. Export PA Flow for implementation team

---

### **Operations/Support Team**

**Use Scope Mapper PRO to:**
- ✅ Automate email-based workflows
- ✅ Create bug tracking systems
- ✅ Process customer support tickets
- ✅ Route emails to correct teams

**Workflow:**
1. Load Email Bug Tracking template
2. Customize for your support email
3. Export PA Flow
4. Import to Power Automate
5. Configure Outlook/Planner connections
6. Go live in 30 minutes!

---

### **Sales/BDM Team**

**Use Scope Mapper PRO to:**
- ✅ Generate technical proposals
- ✅ Estimate automation opportunities
- ✅ Show ROI of Power Automate
- ✅ Create follow-up question lists

**Workflow:**
1. Discovery call with prospect
2. Take notes on integration needs
3. Load appropriate template
4. Generate workflow + follow-up questions
5. Export Markdown for proposal document
6. Include PA automation benefits in pitch

---

## 📊 Comparison: Free vs PRO

| **Feature** | **Original v2.0** | **PRO v3.0** |
|------------|------------------|-------------|
| Workflow mapping | ✅ | ✅ |
| 4-column visualization | ✅ | ✅ |
| System detection | 14 types | 14 types |
| Quick templates | 3 | **4** (+ Email Bug Tracking) |
| Export JSON | ✅ | ✅ |
| Export Markdown | ✅ | ✅ |
| Follow-up questions | ✅ | ✅ |
| **Automation detection** | ❌ | **✅ Auto-detect** |
| **PA flow export** | ❌ | **✅ Importable JSON** |
| **AI workflow patterns** | ❌ | **✅ 4 types** |
| **Flow preview** | ❌ | **✅ In-app preview** |

---

## 🔧 Troubleshooting

### **"No PA Opportunities Detected"**

**Cause:** Scope text doesn't contain automation keywords

**Solution:** Add phrases like:
- "email parsing"
- "bug tracking"
- "invoice processing"
- "webhook handler"
- "support tickets"

---

### **"Export Button Disabled"**

**Cause:** Haven't run analysis yet

**Solution:**
1. Ensure scope text entered
2. Click "Analyze & Generate Flow"
3. Wait for analysis to complete
4. Button will enable if opportunities found

---

### **"Import Failed in Power Automate"**

**Cause:** JSON format or connection issues

**Solution:**
1. Re-export from Scope Mapper
2. Check file size (<10MB)
3. Use "Import Package (Legacy)" option
4. Ensure you have permissions to create flows

---

### **"Flow Runs But Fails Immediately"**

**Cause:** Missing/invalid connections

**Solution:**
1. Go to flow → Edit
2. Check all actions for ⚠️ warning icons
3. Re-authenticate connections
4. Update placeholder values:
   - `YOUR_AZURE_OPENAI_ENDPOINT`
   - `YOUR_SITE`
   - `YOUR_LIST`
   - `YOUR_PLAN_ID`
   - `YOUR_API_KEY`

---

## 💡 Pro Tips

### **Tip 1: Combine Templates**

Load multiple templates and merge in text box:
1. Load "Shopify → BGI"
2. Copy text
3. Load "Email Bug Tracking"
4. Paste Shopify text below
5. Analyze → Detects both integration + automation!

---

### **Tip 2: Enhance AI Prompts**

After exporting PA flow, edit the AI prompt in Power Automate:
1. Open flow in editor
2. Find "HTTP_Azure_OpenAI" action
3. Expand body → messages
4. Customize system message for your use case

**Example:**
```json
"content": "You are a 3PL logistics assistant. Extract: order_id, tracking_number, warehouse_location, priority. Return JSON."
```

---

### **Tip 3: Add Error Notifications**

Enhance exported flows with error handling:
1. Add "Scope" action around main flow
2. Configure "Run After" → "has failed"
3. Add email/Teams notification
4. Include error details in message

---

### **Tip 4: Version Control**

Save multiple exports for comparison:
- `pa-flow-v1-basic.json`
- `pa-flow-v2-enhanced.json`
- `pa-flow-v3-production.json`

Easy rollback if needed!

---

## 📈 ROI Examples

### **Email Bug Tracking Automation**

**Before:**
- Manual: 5 min per bug report
- Volume: 20 bugs/day
- Time: 100 min/day = **8.3 hrs/week**

**After (with PA flow):**
- Automated: <10 seconds per bug
- Savings: **8 hours/week**
- ROI: **$400/week** @ $50/hr

---

### **Multi-System Webhook Integration**

**Before:**
- Manual data entry across 3 systems
- Time: 15 min per order
- Volume: 50 orders/day
- Total: **12.5 hrs/day**

**After:**
- Automated real-time sync
- Savings: **62.5 hrs/week**
- ROI: **$3,125/week** @ $50/hr

---

## 🚀 Next Steps

1. **Try the Email Bug Tracking template**
   - Quick win: 30-minute setup
   - Immediate value for support teams

2. **Customize for your workflows**
   - Edit templates to match your systems
   - Add custom fields

3. **Scale across organization**
   - Share with other departments
   - Create company-specific templates

4. **Measure impact**
   - Track flow runs in Power Automate
   - Monitor time savings
   - Report ROI to leadership

---

## 📞 Support

**Common Questions:**

**Q:** Can I modify the exported PA flow?  
**A:** Yes! It's standard Power Automate JSON. Edit freely.

**Q:** Do I need Azure OpenAI for all flows?  
**A:** Only for AI-based flows (email parsing, bug extraction). Webhook handlers don't require it.

**Q:** Can I use AI Builder instead of Azure OpenAI?  
**A:** Yes! Replace HTTP action with AI Builder connector.

**Q:** What Power Automate license do I need?  
**A:** Premium connectors (HTTP, custom APIs) require Power Automate Per User license.

---

## 📋 Checklist: Going Live

**Pre-Production:**
- [ ] Test flow with sample data
- [ ] Configure all connections
- [ ] Replace placeholder values
- [ ] Add error handling
- [ ] Set up monitoring/alerts
- [ ] Document for team

**Production:**
- [ ] Enable flow
- [ ] Monitor first 10 runs closely
- [ ] Verify all systems updating correctly
- [ ] Check audit logs
- [ ] Measure performance

**Post-Launch:**
- [ ] Gather user feedback
- [ ] Optimize AI prompts
- [ ] Add enhancements
- [ ] Share learnings with team

---

**Version:** 3.0 PRO  
**Last Updated:** November 16, 2025  
**Status:** ✅ Production Ready

🚀 **Ready to automate!**
