# Power Automate Flow Deployment Guide
## Scope Mapper - Create Planner Tasks from Webhook

### Overview
This Power Automate flow automatically creates Microsoft Planner tasks from webhook payloads containing integration scope analysis data. When triggered via HTTP webhook, it processes action items and missing information, creating organized tasks in designated Planner buckets.

---

## Prerequisites

1. **Microsoft 365 Account** with access to:
   - Power Automate (Premium license may be required)
   - Microsoft Planner
   - Microsoft Teams (if using Teams-based plans)

2. **Permissions Required**:
   - Create and manage flows in Power Automate
   - Create and modify tasks in the target Planner plan
   - Access to the Team/Plan where tasks will be created

---

## Deployment Steps

### Step 1: Create Planner Plan and Buckets

1. Navigate to Microsoft Planner (planner.cloud.microsoft or via Teams)
2. Create a new Plan or select an existing one
3. Create two buckets:
   - **Action Items** - for integration action items
   - **Missing Information** - for information gathering tasks
4. Note down the following IDs (instructions below):
   - Team ID
   - Plan ID
   - Action Items Bucket ID
   - Missing Information Bucket ID

### Step 2: Get Required IDs

#### Option A: Using Graph Explorer (Recommended)
1. Go to https://developer.microsoft.com/en-us/graph/graph-explorer
2. Sign in with your Microsoft 365 account
3. Run these queries:

**Get Team ID:**
```
GET https://graph.microsoft.com/v1.0/me/joinedTeams
```
Find your team and copy the `id` field.

**Get Plan ID:**
```
GET https://graph.microsoft.com/v1.0/groups/{teamId}/planner/plans
```
Replace `{teamId}` with your Team ID. Copy the `id` of your plan.

**Get Bucket IDs:**
```
GET https://graph.microsoft.com/v1.0/planner/plans/{planId}/buckets
```
Replace `{planId}` with your Plan ID. Copy the `id` for both buckets.

#### Option B: Using Browser Developer Tools
1. Open Planner in your browser
2. Open Developer Tools (F12)
3. Go to Network tab
4. Click on your plan and buckets
5. Look for API calls containing the IDs in the response

### Step 3: Import Flow to Power Automate

1. Go to https://make.powerautomate.com
2. Click **My flows** in the left navigation
3. Click **Import** > **Import Package (Legacy)**
4. Upload `ScopeMapperFlow.zip`
5. During import setup:
   - For Planner connection: Select existing or create new connection
   - Authenticate with your Microsoft 365 account

### Step 4: Configure Flow Variables

After importing, open the flow and update these variables:

1. Click **Edit** on the imported flow
2. Find the "Initialize" actions and update:

```
Initialize_TeamID:
Value: "6cdbd2a2-7e69-492e-ad7e-a617ed1c6597" (or your Team ID)

Initialize_PlanID:
Value: "<UPDATE_PLAN_ID>" → Replace with your actual Plan ID

Initialize_ActionItemsBucketID:
Value: "<UPDATE_BUCKET_ID>" → Replace with Action Items bucket ID

Initialize_MissingInfoBucketID:
Value: "<UPDATE_BUCKET_ID>" → Replace with Missing Info bucket ID
```

3. Click **Save**

### Step 5: Get Webhook URL

1. In the flow designer, click on the **manual** trigger
2. Copy the **HTTP POST URL**
3. This is your webhook endpoint for sending scope analysis data

---

## Usage

### Webhook Payload Format

Send POST requests to the webhook URL with this JSON structure:

```json
{
    "timestamp": "2025-11-14T10:30:00Z",
    "scopeDocument": {
        "title": "Project Name",
        "rawText": "Project description..."
    },
    "analysis": {
        "detectedSystems": [...],
        "detectedProcesses": [...],
        "missingInformation": [
            {
                "item": "EDI Mapping Details",
                "priority": "high",
                "category": "Technical"
            }
        ]
    },
    "actionItems": [
        {
            "title": "Configure EDI for Orders",
            "description": "Set up EDI mapping for order transmission",
            "priority": "high",
            "category": "Integration",
            "dueInDays": 7
        }
    ]
}
```

See `sample_webhook_payload.json` for a complete example.

### Testing the Flow

1. In Power Automate, open your flow
2. Click **Test** > **Manually**
3. Click **Test**
4. Use a tool like Postman or curl to send the sample payload:

```bash
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @sample_webhook_payload.json
```

5. Check your Planner plan for created tasks

---

## Flow Features

### Action Items Processing
- Creates tasks in "Action Items" bucket
- Sets due dates based on `dueInDays` field
- Maps priority (high=1, medium=5, low=9)
- Includes full description with category and project context

### Missing Information Processing
- Creates tasks in "Missing Information" bucket
- Prefixes titles with "Gather: "
- Includes priority and category in description
- Links to project title for context

### Error Handling
- Automatic retry logic for transient failures
- Returns detailed error responses with HTTP 500
- Success responses include task counts and timestamp

### Response Format

**Success (200):**
```json
{
    "status": "success",
    "message": "Tasks created successfully",
    "projectTitle": "NF 3PL Integration Scope",
    "tasksCreated": {
        "actionItems": 2,
        "missingInformation": 2
    },
    "timestamp": "2025-11-14T10:30:15Z"
}
```

**Error (500):**
```json
{
    "status": "error",
    "message": "Failed to create tasks",
    "error": "[error details]",
    "timestamp": "2025-11-14T10:30:15Z"
}
```

---

## Troubleshooting

### Issue: "Unauthorized" Error
**Solution:** Check Planner connection in Power Automate connections page. Reconnect if needed.

### Issue: Tasks Not Appearing
**Solution:**
- Verify Plan ID and Bucket IDs are correct
- Check you have permissions to create tasks in the plan
- Review flow run history for specific errors

### Issue: "Invalid Template" Error
**Solution:** Ensure the webhook payload matches the expected schema defined in the trigger.

### Issue: Priority Not Setting
**Solution:** Ensure priority values are exactly "high", "medium", or "low" (case-sensitive).

---

## Monitoring

1. Go to Power Automate > **My flows**
2. Click on your flow
3. View **28-day run history**
4. Click on individual runs to see:
   - Inputs received
   - Actions executed
   - Outputs produced
   - Any errors encountered

---

## Security Considerations

1. **Webhook URL Protection:**
   - Keep webhook URL confidential
   - Consider implementing authentication layer
   - Monitor for unusual activity in run history

2. **Data Validation:**
   - Flow validates payload structure via schema
   - Invalid payloads will be rejected

3. **Access Control:**
   - Only authorized users should create/modify the flow
   - Review Planner plan permissions regularly

---

## Maintenance

### Updating Bucket IDs
If you reorganize buckets or plans:
1. Get new Bucket IDs following Step 2
2. Edit flow and update Initialize variables
3. Save and test

### Modifying Task Fields
To add custom fields or change behavior:
1. Edit flow
2. Modify the "Create Task" actions
3. Update the Planner API body as needed
4. Reference: https://docs.microsoft.com/en-us/graph/api/planner-post-tasks

---

## Support Resources

- **Power Automate Documentation:** https://docs.microsoft.com/en-us/power-automate/
- **Planner API Reference:** https://docs.microsoft.com/en-us/graph/api/resources/planner-overview
- **Graph Explorer:** https://developer.microsoft.com/en-us/graph/graph-explorer

---

## Version History

- **v1.0.0** (2025-11-14): Initial release
  - Action items task creation
  - Missing information task creation
  - Error handling and response formatting
  - Priority mapping (high/medium/low)
