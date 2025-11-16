# Scope Mapper Power Automate Flow

Automatically create Microsoft Planner tasks from integration scope analysis webhooks.

## Quick Start

### 1. Import the Flow
```bash
# Import ScopeMapperFlow_Complete.zip to Power Automate
# https://make.powerautomate.com > Import > Import Package
```

### 2. Get Your Planner IDs
```powershell
# Run the PowerShell helper script
.\Get-PlannerIDs.ps1
```

### 3. Configure the Flow
Update these variables in the flow editor:
- `PlanID`: Your Planner plan ID
- `ActionItemsBucketID`: Bucket for action items
- `MissingInfoBucketID`: Bucket for missing information

### 4. Test the Flow
```bash
# Using Python test script
python test_webhook.py YOUR_WEBHOOK_URL

# Or using curl
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @sample_webhook_payload.json
```

## What It Does

This Power Automate flow:
1. Receives integration scope analysis via HTTP webhook
2. Creates Planner tasks for action items with due dates
3. Creates tasks for missing information items
4. Sets task priorities (high/medium/low)
5. Returns success/error response

## Files Included

| File | Purpose |
|------|---------|
| `ScopeMapperFlow_Complete.zip` | Complete flow package for import |
| `flow.json` | Flow definition (JSON) |
| `sample_webhook_payload.json` | Example webhook payload |
| `Get-PlannerIDs.ps1` | PowerShell script to retrieve Planner IDs |
| `test_webhook.py` | Python script to test webhook |
| `DEPLOYMENT_GUIDE.md` | Comprehensive deployment instructions |
| `FLOW_ARCHITECTURE.md` | Technical architecture documentation |

## Prerequisites

- Microsoft 365 account with:
  - Power Automate Premium license
  - Microsoft Planner access
  - Permissions to create flows and tasks

## Flow Features

### Action Items Processing
- Creates tasks in designated bucket
- Sets due dates based on `dueInDays` field
- Maps priority levels to Planner priorities
- Includes full description with context

### Missing Information Processing
- Creates tasks prefixed with "Gather: "
- Organizes in separate bucket
- Includes category and priority
- Links to project title

### Error Handling
- Validates payload schema
- Returns detailed error responses
- Logs all runs in Power Automate history

### Response Format

**Success (HTTP 200):**
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

**Error (HTTP 500):**
```json
{
  "status": "error",
  "message": "Failed to create tasks",
  "error": "[error details]",
  "timestamp": "2025-11-14T10:30:15Z"
}
```

## Payload Structure

Send POST requests with this JSON structure:

```json
{
  "timestamp": "ISO 8601 datetime",
  "scopeDocument": {
    "title": "Project name",
    "rawText": "Description"
  },
  "analysis": {
    "missingInformation": [
      {
        "item": "What's missing",
        "priority": "high|medium|low",
        "category": "Category name"
      }
    ]
  },
  "actionItems": [
    {
      "title": "Task title",
      "description": "Task description",
      "priority": "high|medium|low",
      "category": "Category",
      "dueInDays": 7
    }
  ]
}
```

## Configuration

### Required Variables

1. **TeamID** (Optional): Microsoft Teams group ID
   - Default: `6cdbd2a2-7e69-492e-ad7e-a617ed1c6597`
   - Currently not used, reserved for future features

2. **PlanID** (Required): Planner plan ID
   - Get from `Get-PlannerIDs.ps1`
   - Update in flow editor

3. **ActionItemsBucketID** (Required): Bucket for action items
   - Create bucket named "Action Items" in Planner
   - Get ID from `Get-PlannerIDs.ps1`

4. **MissingInfoBucketID** (Required): Bucket for missing info
   - Create bucket named "Missing Information" in Planner
   - Get ID from `Get-PlannerIDs.ps1`

## Testing

### Using Python Script

```bash
# Install dependencies
pip install requests

# Test with sample payload
python test_webhook.py YOUR_WEBHOOK_URL

# Test with custom minimal payload
python test_webhook.py YOUR_WEBHOOK_URL --custom
```

### Using PowerShell

```powershell
# Test with Invoke-RestMethod
$payload = Get-Content sample_webhook_payload.json | ConvertFrom-Json
$response = Invoke-RestMethod -Uri "YOUR_WEBHOOK_URL" `
  -Method Post `
  -Body ($payload | ConvertTo-Json -Depth 10) `
  -ContentType "application/json"
$response
```

### Using Curl

```bash
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @sample_webhook_payload.json \
  -w "\nHTTP Status: %{http_code}\n"
```

## Monitoring

### View Flow Runs
1. Go to https://make.powerautomate.com
2. Click **My flows**
3. Select your flow
4. View **28-day run history**

### Check Created Tasks
1. Open Microsoft Planner
2. Navigate to your plan
3. Check "Action Items" and "Missing Information" buckets

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Flow not triggering | Check webhook URL is correct |
| Tasks not appearing | Verify Plan ID and Bucket IDs |
| Unauthorized error | Reconnect Planner connection |
| Invalid payload | Validate JSON against schema |
| Priority not setting | Use "high", "medium", or "low" exactly |

## Documentation

- **Quick Start:** This file
- **Deployment:** See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- **Architecture:** See [FLOW_ARCHITECTURE.md](./FLOW_ARCHITECTURE.md)

## Integration

### Calling from JavaScript/TypeScript

```typescript
async function sendToScopeMapper(scopeData: any) {
  const webhookUrl = 'YOUR_WEBHOOK_URL';

  const response = await fetch(webhookUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(scopeData),
  });

  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${await response.text()}`);
  }

  return await response.json();
}
```

### Calling from Python

```python
import requests

def send_to_scope_mapper(scope_data):
    webhook_url = 'YOUR_WEBHOOK_URL'

    response = requests.post(
        webhook_url,
        json=scope_data,
        timeout=30
    )
    response.raise_for_status()

    return response.json()
```

### Calling from PowerShell

```powershell
function Send-ToScopeMapper {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$ScopeData
    )

    $webhookUrl = 'YOUR_WEBHOOK_URL'

    $response = Invoke-RestMethod -Uri $webhookUrl `
        -Method Post `
        -Body ($ScopeData | ConvertTo-Json -Depth 10) `
        -ContentType "application/json"

    return $response
}
```

## Security

- Keep webhook URL confidential (contains secret)
- Flow runs with connection owner's permissions
- All communication over HTTPS
- Planner permissions apply to created tasks

## Performance

- Typical execution: 5-30 seconds
- Suitable for 1-50 items per request
- Sequential processing (can enable concurrency)
- Microsoft Graph API rate limits apply

## License

This Power Automate flow is provided as-is for use within your organization.

## Support

For issues or questions:
1. Check [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
2. Review flow run history for errors
3. Validate payload format
4. Check Microsoft 365 service health

## Version

- **Current:** 1.0.0
- **Released:** 2025-11-14
- **Status:** Production Ready

## Changelog

### v1.0.0 (2025-11-14)
- Initial release
- Action items task creation with due dates
- Missing information task creation
- Priority mapping (high/medium/low)
- Error handling and response formatting
- Comprehensive documentation

## Next Steps

1. Read [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for detailed setup
2. Run `Get-PlannerIDs.ps1` to get your IDs
3. Import flow and configure variables
4. Test with `test_webhook.py` or sample payload
5. Integrate into your application
6. Monitor flow runs and adjust as needed

## Additional Resources

- [Power Automate Documentation](https://docs.microsoft.com/en-us/power-automate/)
- [Microsoft Graph Planner API](https://docs.microsoft.com/en-us/graph/api/resources/planner-overview)
- [Webhook Best Practices](https://docs.microsoft.com/en-us/azure/connectors/connectors-native-reqres)
