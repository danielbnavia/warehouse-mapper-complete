# Instructions for AI Assistant - Power Automate Flow Configuration

## Context

The user needs help configuring a Power Automate flow that creates Planner tasks from integration scope analysis. The flow has placeholders that need to be replaced with actual IDs.

---

## Current Situation

### ✅ What We Have:

**Team ID:** `6cdbd2a2-7e69-492e-ad7e-a617ed1c6597`
**Plan ID:** `e5aef5db-e919-474b-a2df-8ceb63932d79`

**Plan URL:**
```
https://planner.cloud.microsoft/webui/premiumplan/e5aef5db-e919-474b-a2df-8ceb63932d79/org/c6acd9de-92a6-4930-a83f-fbf0562b3c71/view/grid?tid=2131d362-e12d-44c1-843b-a1413d6b96a3
```

**Planner Buckets Available:**
- Scope
- Analysis/Software Requirements
- Design
- Development
- Testing
- Training
- Documentation
- Deployment
- Post Implementation Review

**Power Automate Flow Webhook URL:**
```
https://default2131d362e12d44c1843ba1413d6b96.a3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/6087906563fd4ab2a9274d49dd7831b5/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=mtseca3tMlwn0kQwoCZtFXp_mHJrVmkQfROKwM2ksYk
```

**Teams Incoming Webhook URL:**
```
https://navia.webhook.office.com/webhookb2/6cdbd2a2-7e69-492e-ad7e-a617ed1c6597@2131d362-e12d-44c1-843b-a1413d6b96a3/IncomingWebhook/64fafebee7e64bc3aeca4cce437f9177/29f13b9e-2e28-484e-ba5d-971bbbfd79ba/V285Q7OZHvIQg_n8XOrxTWSTx0Ygia8lg2WgepujGR6eM1
```

---

## ❌ What's Missing:

The Power Automate flow file has 2 placeholders that need **Bucket IDs**:

1. **ActionItemsBucketID** - Line 110-111
   - Should use: **"Analysis/Software Requirements"** bucket

2. **MissingInfoBucketID** - Line 123-124
   - Should use: **"Analysis/Software Requirements"** bucket (same bucket is fine)

---

## 🎯 Your Mission:

Help the user get the Bucket IDs and update the Power Automate flow.

---

## 📋 Step-by-Step Process for AI Assistant:

### **Step 1: Get Bucket IDs**

**Method A - Using Power Automate (Recommended):**

Guide the user to:

1. Go to https://flow.microsoft.com
2. Create a new **Instant cloud flow**
3. Name it: "Get Bucket IDs Helper"
4. Trigger: **Manual trigger (button)**
5. Add action: **Microsoft Planner** → **List buckets**
6. Plan ID: `e5aef5db-e919-474b-a2df-8ceb63932d79`
7. **Test the flow** (click Test → Manually → Run flow)
8. Check the output - you'll see all buckets with their IDs
9. Find "Analysis/Software Requirements" bucket
10. Copy its ID (format: `bucket-id-123abc...`)

**Method B - Using Browser DevTools:**

1. Open Planner in browser: https://tasks.office.com
2. Open the plan
3. Press F12 (Developer Tools)
4. Go to **Network** tab
5. Click on a task in the "Analysis/Software Requirements" bucket
6. Look for API calls to `planner/tasks/`
7. In the response, find `bucketId` field
8. Copy the bucket ID

---

### **Step 2: Update the Flow File**

The flow file is located at:
```
M:\warehouse-mapper-complete\power\Post to a channel when a webhook request is received text_1. Parse JSON_   └─ Content_ triggerOutputs()_['body']_   └─ Schema_ [Use the schema from the documentation file]__2. Apply to each - Action Items_.json
```

**Find these lines and replace:**

**Line 110-111:**
```json
"value": "<UPDATE_BUCKET_ID>"
```
Replace with:
```json
"value": "THE_ACTUAL_BUCKET_ID_YOU_GOT_FROM_STEP_1"
```

**Line 123-124:**
```json
"value": "<UPDATE_BUCKET_ID>"
```
Replace with:
```json
"value": "THE_ACTUAL_BUCKET_ID_YOU_GOT_FROM_STEP_1"
```

**Line 97-98 (Plan ID) - Already known, verify it's correct:**
```json
"value": "e5aef5db-e919-474b-a2df-8ceb63932d79"
```

---

### **Step 3: Import/Update the Flow**

1. Go to https://flow.microsoft.com
2. Find the existing flow or import the updated JSON
3. **If importing fresh:**
   - My flows → Import → Import Package (Legacy)
   - Upload the updated JSON file
   - Configure connections (Planner, Teams)
   - Save

4. **If updating existing flow:**
   - Open the flow
   - Click "..." menu → **Peek code**
   - Replace the entire JSON with the updated version
   - Click "Done"
   - Save

---

### **Step 4: Test the Flow**

Send a test payload to the webhook:

```powershell
$webhook = "https://default2131d362e12d44c1843ba1413d6b96.a3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/6087906563fd4ab2a9274d49dd7831b5/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=mtseca3tMlwn0kQwoCZtFXp_mHJrVmkQfROKwM2ksYk"

$testPayload = @{
    timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    scopeDocument = @{
        title = "Test Integration - Shopify to BGI"
        rawText = "Sample scope document for testing..."
    }
    analysis = @{
        systems = @("Shopify", "BGI", "ShipStation")
        missingInformation = @(
            @{
                item = "API credentials for Shopify"
                category = "Technical"
                priority = "high"
            }
        )
    }
    actionItems = @(
        @{
            title = "Configure Shopify webhook"
            description = "Set up webhook endpoint for order events"
            priority = "high"
            category = "Technical Setup"
            dueInDays = 3
        }
    )
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri $webhook -Method Post -Body $testPayload -ContentType 'application/json'
```

---

### **Step 5: Verify Success**

Check:
1. ✅ Flow run completed successfully in Power Automate
2. ✅ Tasks appear in Planner under "Analysis/Software Requirements" bucket
3. ✅ Task details include priority, description, due dates
4. ✅ No errors in flow run history

---

## 🚨 Troubleshooting

### **Issue: "Bucket ID not found"**

**Solution:** The bucket ID might be wrong. Use Method A (Power Automate) to list all buckets and verify the ID.

### **Issue: "Invalid JSON"**

**Solution:** Make sure you didn't accidentally add extra quotes or miss a comma when updating the file.

### **Issue: "Connection not configured"**

**Solution:** In Power Automate, edit the flow and re-authenticate the Planner connection.

### **Issue: "Tasks not appearing in Planner"**

**Solution:**
- Check the flow run history for errors
- Verify the Plan ID is correct
- Check if tasks are being created but in a different bucket

---

## 📁 Files Included in Package

1. **Power Automate Flow JSON** - The flow that needs bucket IDs
2. **Get Bucket IDs Helper Flow** - Simple flow to list bucket IDs
3. **Test Payload JSON** - Sample data to test the flow
4. **This instructions file**

---

## 🎯 Expected Outcome

After completing these steps:
- The user will have a fully configured Power Automate flow
- When the Scope Mapper PRO sends data to the webhook, tasks will automatically be created in Planner
- Tasks will appear in the "Analysis/Software Requirements" bucket
- The flow will return a success response

---

## 💡 Additional Enhancements (Optional)

If the user wants to improve the flow further:

1. **Add Teams notification:** Post a message to Teams channel when tasks are created
2. **Add error handling:** Send alerts if task creation fails
3. **Add logging:** Store run history in SharePoint for audit
4. **Add approvals:** Route certain tasks through approval workflow

---

**Good luck! The user is counting on you to help them get this working! 🚀**
