# Email Parser Flow - Complete Setup Guide

**Fixed Flow File:** `email-parser-corrected.json`

---

## 🚨 What Was Wrong with the Original Export

### **Issues Fixed:**

1. ✅ **Added missing `$connections` parameter definition**
2. ✅ **Fixed runAfter for Initialize_CorrelationID** (was missing)
3. ✅ **Improved AI prompt** with better JSON structure examples
4. ✅ **Added required fields** to JSON schema
5. ✅ **Fixed SharePoint path** format
6. ✅ **Added Importance field** to confirmation email
7. ✅ **Better placeholder comments** for configuration

---

## 📋 Prerequisites

Before importing this flow, you need:

1. **Power Automate Premium License** (for HTTP connector)
2. **Azure OpenAI Resource** with:
   - Deployment created (e.g., gpt-4 or gpt-35-turbo)
   - API key
3. **SharePoint List** with these columns:
   - Title (Single line of text) - comes by default
   - Description (Multiple lines of text)
   - Priority (Choice: High, Medium, Low)
   - Category (Choice: Bug, Feature Request, Question)
   - CorrelationID (Single line of text)
4. **Office 365 Outlook** access

---

## 🔧 Step-by-Step Setup

### **Step 1: Prepare Azure OpenAI**

1. Go to Azure Portal: https://portal.azure.com
2. Navigate to your Azure OpenAI resource
3. **Get your endpoint:**
   ```
   Example: https://naviafreight-openai.openai.azure.com
   ```
4. **Get your API key:**
   - Go to "Keys and Endpoint"
   - Copy KEY 1 or KEY 2
5. **Get your deployment name:**
   - Go to "Deployments" in Azure OpenAI Studio
   - Note the deployment name (e.g., "gpt-4", "gpt-35-turbo")

---

### **Step 2: Prepare SharePoint List**

1. Go to your SharePoint site
2. Create a new list called "Support Tickets" (or use existing)
3. **Add required columns:**

   **Priority Column:**
   ```
   Type: Choice
   Choices:
   - High
   - Medium
   - Low
   Default: Medium
   ```

   **Category Column:**
   ```
   Type: Choice
   Choices:
   - Bug
   - Feature Request
   - Question
   ```

   **Description Column:**
   ```
   Type: Multiple lines of text
   ```

   **CorrelationID Column:**
   ```
   Type: Single line of text
   ```

4. **Get your SharePoint details:**
   - Site URL: `https://YOUR_TENANT.sharepoint.com/sites/YOUR_SITE`
   - List ID: Go to List Settings → Copy from URL (e.g., `%7B12345678-1234-1234-1234-123456789ABC%7D`)

---

### **Step 3: Configure the Flow JSON**

Open `email-parser-corrected.json` and replace these placeholders:

#### **Line 43: Azure OpenAI Endpoint**

**Find:**
```json
"uri": "https://YOUR_RESOURCE_NAME.openai.azure.com/openai/deployments/YOUR_DEPLOYMENT_NAME/chat/completions?api-version=2024-02-15-preview"
```

**Replace with:**
```json
"uri": "https://naviafreight-openai.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-15-preview"
```
*(Use your actual resource name and deployment name)*

---

#### **Line 46: API Key**

**Find:**
```json
"api-key": "YOUR_API_KEY_HERE"
```

**Replace with:**
```json
"api-key": "sk-proj-abc123...your-actual-api-key"
```

---

#### **Line 108: SharePoint Site and List**

**Find:**
```json
"path": "/datasets/@{encodeURIComponent('https://YOUR_TENANT.sharepoint.com/sites/YOUR_SITE')}/tables/@{encodeURIComponent('YOUR_LIST_ID')}/items"
```

**Replace with:**
```json
"path": "/datasets/@{encodeURIComponent('https://naviafreight.sharepoint.com/sites/SupportPortal')}/tables/@{encodeURIComponent('Support Tickets')}/items"
```

**Alternative (using List ID):**
```json
"path": "/datasets/@{encodeURIComponent('https://naviafreight.sharepoint.com/sites/SupportPortal')}/tables/@{encodeURIComponent('%7B12345678-1234-1234-1234-123456789ABC%7D')}/items"
```

---

### **Step 4: Import to Power Automate**

1. Open a **text editor** (Notepad, VS Code)
2. Open `email-parser-corrected.json`
3. Make the replacements above
4. **Save the file**

5. Go to https://flow.microsoft.com
6. Click **"My flows"** → **"New flow"** → **"Automated cloud flow"**
7. Name it: "Email Parser with AI - NaviaFreight"
8. Trigger: **"When a new email arrives (V3)"** (Office 365 Outlook)
9. Click **"Create"**

10. **In the flow designer:**
    - Click the **"..."** menu (top right)
    - Select **"Peek code"**
    - **Delete all existing code**
    - **Paste your configured JSON**
    - Click **"Done"**

---

### **Step 5: Configure Connections**

After importing, you'll see warnings about connections:

1. **Office 365 Outlook Connection:**
   - Click the warning
   - Select existing connection or create new
   - Sign in with your Microsoft account

2. **SharePoint Connection:**
   - Click the warning on "Create_SharePoint_Item"
   - Select existing connection or create new
   - Sign in

3. **HTTP Action:**
   - No connection needed (uses API key)

---

### **Step 6: Test the Flow**

1. **Save the flow** (top right)

2. **Send a test email** to the email address configured in the trigger:

   **Subject:** Test Bug Report

   **Body:**
   ```
   There's a login issue on the website. Users cannot log in after the latest update.

   Steps to reproduce:
   1. Go to login page
   2. Enter credentials
   3. Click Login
   4. Nothing happens

   Priority: High
   ```

3. **Check the flow run:**
   - Go to "My flows"
   - Click your flow
   - Check "28-day run history"
   - Click the latest run
   - Verify each step succeeded

4. **Check SharePoint:**
   - Go to your SharePoint list
   - Verify item was created
   - Check that AI extracted data correctly

5. **Check your email:**
   - You should receive a confirmation email
   - Verify it contains the Task ID and Priority

---

## 🔍 Troubleshooting

### **Error: "The API deployment for this resource does not exist"**

**Cause:** Wrong deployment name or endpoint

**Fix:**
1. Verify deployment name in Azure OpenAI Studio
2. Check endpoint URL is correct
3. Ensure API version is supported: `2024-02-15-preview`

---

### **Error: "Unauthorized" from Azure OpenAI**

**Cause:** Invalid API key

**Fix:**
1. Get new API key from Azure Portal
2. Update in the HTTP action
3. Save and test again

---

### **Error: "List 'YOUR_LIST' doesn't exist"**

**Cause:** SharePoint list name or ID is wrong

**Fix:**
1. Verify list exists
2. Use exact list name (case-sensitive) OR use List ID
3. To get List ID:
   - Go to List Settings
   - Copy from browser URL: `List=%7B...%7D`

---

### **Error: "Expression evaluation failed"**

**Cause:** AI returned invalid JSON

**Fix:**
1. Add Parse JSON error handling:
   ```
   In Parse_AI_Response action settings:
   - Configure run after: Add "has failed"
   - Add a Compose action to log raw response
   - Add Condition to check if valid JSON
   ```

2. Improve AI prompt to ensure JSON output:
   ```json
   "content": "You MUST return ONLY a valid JSON object, nothing else. No markdown, no explanations..."
   ```

---

### **SharePoint Item Not Created**

**Cause:** Column names don't match

**Fix:**
1. Verify SharePoint columns exist:
   - Title
   - Description
   - Priority
   - Category
   - CorrelationID

2. Update JSON body to match your column names:
   ```json
   "body": {
     "Title": "@body('Parse_AI_Response')?['title']",
     "YourDescriptionColumn": "@body('Parse_AI_Response')?['description']"
   }
   ```

---

## 🎯 Alternative: Use Planner Instead of SharePoint

If you prefer Microsoft Planner for tasks:

**Replace the "Create_SharePoint_Item" action with:**

```json
{
  "Create_Planner_Task": {
    "type": "ApiConnection",
    "inputs": {
      "host": {
        "connection": {
          "name": "@parameters('$connections')['planner']['connectionId']"
        }
      },
      "method": "post",
      "path": "/v1.0/planner/tasks",
      "body": {
        "planId": "YOUR_PLAN_ID",
        "bucketId": "YOUR_BUCKET_ID",
        "title": "@{body('Parse_AI_Response')?['title']}",
        "assignments": {},
        "priority": "@{if(equals(body('Parse_AI_Response')?['priority'], 'High'), 1, if(equals(body('Parse_AI_Response')?['priority'], 'Medium'), 5, 9))}"
      }
    },
    "runAfter": {
      "Parse_AI_Response": [
        "Succeeded"
      ]
    }
  }
}
```

**Get Plan ID and Bucket ID:**
```powershell
# Use the script from power/Get-PlannerIDs.ps1
# Or get from Power Automate by adding a "List tasks" action
```

---

## 📊 Expected Flow Behavior

### **Successful Run:**

```
1. Email arrives → Trigger activates
2. CorrelationID created: "a1b2c3d4-e5f6-..."
3. Email body cleaned
4. AI extracts:
   {
     "title": "Login issue after update",
     "description": "Users cannot log in...",
     "priority": "High",
     "category": "Bug"
   }
5. SharePoint item created with ID: 42
6. Confirmation email sent to requester
```

**Time:** ~5-10 seconds per email

**Cost:** ~$0.002 per email (Azure OpenAI GPT-4)

---

## 🔒 Security Best Practices

1. **Store API Key in Azure Key Vault:**
   - Create Azure Key Vault
   - Store OpenAI API key as secret
   - Use "Get secret" action in flow

2. **Limit Email Trigger:**
   - Add subject filter: "Contains 'Support Request'"
   - Add sender filter: Only from specific domains
   - Use dedicated support email address

3. **Add Error Notifications:**
   - Wrap actions in Scope
   - Add "Configure run after" for failures
   - Send admin alert on failures

4. **Enable Audit Logging:**
   - Keep CorrelationID for tracking
   - Log to separate audit list
   - Include original email data

---

## 📈 Performance Optimization

**For High Volume (>100 emails/day):**

1. **Use child flow pattern:**
   ```
   Parent flow: Email trigger → Queue to storage
   Child flow: Process from queue (scheduled)
   ```

2. **Batch processing:**
   - Collect emails for 5 minutes
   - Process in batches
   - Reduce API calls

3. **Cache AI responses:**
   - Check for similar emails
   - Reuse previous extractions
   - Store in Dataverse table

---

## ✅ Checklist

**Before going live:**

- [ ] Azure OpenAI endpoint configured
- [ ] API key updated and tested
- [ ] SharePoint list created with all columns
- [ ] SharePoint path updated in JSON
- [ ] Connections authenticated
- [ ] Test email sent and processed successfully
- [ ] Confirmation email received
- [ ] SharePoint item created with correct data
- [ ] Error handling tested
- [ ] Flow saved and enabled

---

## 📞 Need Help?

**Common Resources:**

- Azure OpenAI Docs: https://learn.microsoft.com/azure/ai-services/openai/
- Power Automate Expressions: https://learn.microsoft.com/power-automate/use-expressions-in-conditions
- SharePoint Connector: https://learn.microsoft.com/connectors/sharepointonline/

**Project Documentation:**

- Integration guide: `power/INTEGRATION_WITH_WAREHOUSE_BACKEND.md`
- Scope Mapper PRO: `power/SCOPE_MAPPER_PRO_GUIDE.md`
- Power Automate skill: `.claude/skills/power-automate-expert.md`

---

**File:** `email-parser-corrected.json`
**Version:** 1.0 (Corrected)
**Last Updated:** November 16, 2025
**Status:** ✅ Ready to Configure and Import
