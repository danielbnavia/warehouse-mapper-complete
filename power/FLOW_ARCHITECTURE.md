# Power Automate Flow Architecture
## Scope Mapper - Technical Design Document

---

## Flow Overview

**Name:** Scope Mapper – Create Planner Tasks from Webhook
**Type:** Automated Cloud Flow
**Trigger:** HTTP Request (Webhook)
**Target:** Microsoft Planner

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         WEBHOOK TRIGGER                          │
│                    HTTP POST Request Received                    │
│                   (Integration Scope Payload)                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   VARIABLE INITIALIZATION                        │
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐ │
│  │   Team ID        │  │   Plan ID        │  │ Project Title │ │
│  │ (Hard-coded)     │  │ (To Configure)   │  │ (From Payload)│ │
│  └──────────────────┘  └──────────────────┘  └───────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐                    │
│  │ Action Items     │  │ Missing Info     │                    │
│  │  Bucket ID       │  │   Bucket ID      │                    │
│  └──────────────────┘  └──────────────────┘                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
┌──────────────────────────┐  ┌──────────────────────────┐
│  LOOP: ACTION ITEMS      │  │  LOOP: MISSING INFO      │
│  (Parallel After Init)   │  │  (After Action Items)    │
└────────────┬─────────────┘  └────────────┬─────────────┘
             │                              │
             ▼                              ▼
┌──────────────────────────┐  ┌──────────────────────────┐
│  For Each Action Item:   │  │  For Each Missing Item:  │
│  ┌────────────────────┐  │  │  ┌────────────────────┐  │
│  │ 1. Create Task     │  │  │  │ 1. Create Task     │  │
│  │    - Title         │  │  │  │    - Prefixed      │  │
│  │    - Description   │  │  │  │      "Gather: "    │  │
│  │    - Due Date      │  │  │  │    - Description   │  │
│  │    - Bucket ID     │  │  │  │    - Bucket ID     │  │
│  └──────────┬─────────┘  │  │  └──────────┬─────────┘  │
│             ▼             │  │             ▼             │
│  ┌────────────────────┐  │  │  ┌────────────────────┐  │
│  │ 2. Set Priority    │  │  │  │ 2. Set Priority    │  │
│  │    - High = 1      │  │  │  │    - High = 1      │  │
│  │    - Medium = 5    │  │  │  │    - Medium = 5    │  │
│  │    - Low = 9       │  │  │  │    - Low = 9       │  │
│  └────────────────────┘  │  │  └────────────────────┘  │
└────────────┬─────────────┘  └────────────┬─────────────┘
             │                              │
             └──────────────┬───────────────┘
                            │
              ┌─────────────┴─────────────┐
              │         SUCCESS?          │
              └─────┬─────────────────┬───┘
                    │ YES             │ NO
                    ▼                 ▼
      ┌──────────────────────┐  ┌──────────────────────┐
      │  COMPOSE SUCCESS     │  │  COMPOSE ERROR       │
      │  RESPONSE            │  │  RESPONSE            │
      │  ┌────────────────┐  │  │  ┌────────────────┐  │
      │  │ - Status       │  │  │  │ - Status       │  │
      │  │ - Message      │  │  │  │ - Error Details│  │
      │  │ - Task Counts  │  │  │  │ - Timestamp    │  │
      │  │ - Timestamp    │  │  │  └────────────────┘  │
      │  └────────────────┘  │  └──────────┬───────────┘
      └──────────┬───────────┘             │
                 │                         │
                 ▼                         ▼
      ┌──────────────────────┐  ┌──────────────────────┐
      │  HTTP RESPONSE 200   │  │  HTTP RESPONSE 500   │
      └──────────────────────┘  └──────────────────────┘
```

---

## Component Details

### 1. Trigger: HTTP Request

**Type:** Request
**Method:** POST
**Authentication:** None (URL contains secret)

**Schema Validation:**
```json
{
  "type": "object",
  "properties": {
    "timestamp": { "type": "string" },
    "scopeDocument": {
      "type": "object",
      "properties": {
        "title": { "type": "string" },
        "rawText": { "type": "string" }
      }
    },
    "analysis": { "type": "object" },
    "workflows": { "type": "object" },
    "actionItems": { "type": "array" },
    "metadata": { "type": "object" }
  }
}
```

---

### 2. Variable Initialization (Parallel)

All variable initializations run in parallel:

| Variable | Type | Purpose | Default Value |
|----------|------|---------|---------------|
| TeamID | String | Microsoft Teams Group ID | `6cdbd2a2-7e69-492e-ad7e-a617ed1c6597` |
| PlanID | String | Target Planner Plan | `<UPDATE_PLAN_ID>` |
| ActionItemsBucketID | String | Bucket for action items | `<UPDATE_BUCKET_ID>` |
| MissingInfoBucketID | String | Bucket for missing info | `<UPDATE_BUCKET_ID>` |
| ProjectTitle | String | Project name from payload | `@{triggerBody()?['scopeDocument']?['title']}` |

---

### 3. Loop Through Action Items

**Type:** ForEach Loop
**Array:** `@triggerBody()?['actionItems']`
**Concurrency:** Default (sequential)
**Depends On:** All initialization actions

#### 3.1 Create Action Item Task

**API:** Microsoft Graph - Planner
**Method:** POST
**Endpoint:** `/v1.0/planner/tasks`

**Body:**
```json
{
  "planId": "@variables('PlanID')",
  "bucketId": "@variables('ActionItemsBucketID')",
  "title": "@{items('Loop_Through_Action_Items')?['title']}",
  "assignments": {},
  "percentComplete": 0,
  "dueDateTime": "@{addDays(utcNow(), items('Loop_Through_Action_Items')?['dueInDays'])}",
  "details": {
    "description": "[Combined description with priority, category, project]",
    "previewType": "description"
  }
}
```

#### 3.2 Set Task Priority

**API:** Microsoft Graph - Planner
**Method:** PATCH
**Endpoint:** `/v1.0/planner/tasks/{taskId}`

**Priority Mapping:**
- `high` → 1 (Urgent)
- `medium` → 5 (Important)
- `low` → 9 (Normal)

**Headers:** Includes `If-Match` with ETag from creation response

---

### 4. Loop Through Missing Information

**Type:** ForEach Loop
**Array:** `@triggerBody()?['analysis']?['missingInformation']`
**Depends On:** `Loop_Through_Action_Items` (Success)

#### 4.1 Create Missing Info Task

**API:** Microsoft Graph - Planner
**Method:** POST
**Endpoint:** `/v1.0/planner/tasks`

**Body:**
```json
{
  "planId": "@variables('PlanID')",
  "bucketId": "@variables('MissingInfoBucketID')",
  "title": "Gather: @{items('Loop_Through_Missing_Information')?['item']}",
  "assignments": {},
  "percentComplete": 0,
  "details": {
    "description": "[Category, priority, project context]",
    "previewType": "description"
  }
}
```

#### 4.2 Set Missing Info Priority

Same priority mapping and PATCH logic as action items.

---

### 5. Success Path

**Trigger Condition:** Both loops complete successfully

#### 5.1 Compose Success Response

**Type:** Compose
**Output:**
```json
{
  "status": "success",
  "message": "Tasks created successfully",
  "projectTitle": "@variables('ProjectTitle')",
  "tasksCreated": {
    "actionItems": "@length(triggerBody()?['actionItems'])",
    "missingInformation": "@length(triggerBody()?['analysis']?['missingInformation'])"
  },
  "timestamp": "@utcNow()"
}
```

#### 5.2 Response Success

**Type:** HTTP Response
**Status Code:** 200
**Body:** Output from Compose Success Response
**Headers:** `Content-Type: application/json`

---

### 6. Error Path

**Trigger Condition:** Either loop fails or times out

#### 6.1 Compose Error Response

**Type:** Compose
**Output:**
```json
{
  "status": "error",
  "message": "Failed to create tasks",
  "error": "[Combined result from failed actions]",
  "timestamp": "@utcNow()"
}
```

#### 6.2 Response Error

**Type:** HTTP Response
**Status Code:** 500
**Body:** Output from Compose Error Response
**Headers:** `Content-Type: application/json`

---

## Execution Flow

### Normal Execution

1. **Trigger receives webhook** (0s)
2. **Variables initialize** (parallel, ~1s)
3. **Action items loop** starts (~2s)
   - For each item: Create task + Set priority (~2-3s each)
4. **Missing info loop** starts after action items (~Ns)
   - For each item: Create task + Set priority (~2-3s each)
5. **Compose success response** (~0.5s)
6. **Send HTTP 200 response** (~0.5s)

**Total Duration:** Varies based on item count
**Typical:** 5-30 seconds for 2-10 items

### Error Handling

- **Invalid Payload:** Rejected at trigger with validation error
- **API Failures:** Caught by runAfter conditions, triggers error path
- **Timeouts:** Default timeout applies, triggers error path
- **Partial Success:** If one loop succeeds and one fails, error response sent

---

## Data Flow

### Input Data Sources

1. **Webhook Payload:**
   - `scopeDocument.title` → ProjectTitle variable
   - `actionItems[]` → Action Items loop
   - `analysis.missingInformation[]` → Missing Info loop

2. **Flow Variables:**
   - `TeamID` → Not currently used (reserved for future)
   - `PlanID` → Used in all task creation
   - Bucket IDs → Route tasks to correct buckets

### Output Data

1. **Created Tasks:** Stored in Microsoft Planner
2. **Response Payload:** Returned to webhook caller
3. **Flow Run History:** Logged in Power Automate

---

## Performance Considerations

### Throughput

- **Sequential Processing:** ForEach loops run sequentially by default
- **Rate Limits:** Microsoft Graph API has throttling limits
- **Batch Size:** Suitable for 1-50 items per request

### Optimization Opportunities

1. **Enable Concurrency:** Set ForEach concurrency to 20-50 for faster processing
2. **Batch Operations:** Use Graph batch API for large item sets
3. **Caching:** Cache Plan/Bucket IDs in variables (already done)

### Limits

- **Flow Timeout:** 30 days (default), configurable
- **HTTP Request Timeout:** 120 seconds by default
- **ForEach Limit:** 100,000 iterations
- **Graph API:** 10,000+ requests per 10 minutes per app

---

## Security Architecture

### Authentication

- **Flow Trigger:** URL-based security (secret in URL)
- **Planner API:** OAuth 2.0 via managed connection
- **User Context:** Flow runs as connection owner

### Data Protection

- **In Transit:** HTTPS required for all connections
- **At Rest:** Data stored in Planner follows Microsoft 365 compliance
- **Access Control:** Planner permissions apply to created tasks

### Audit Trail

- **Flow Runs:** 28-day history in Power Automate
- **Planner Changes:** Office 365 audit logs
- **Webhook Calls:** Can be logged separately if needed

---

## Monitoring & Observability

### Built-in Monitoring

1. **Run History:**
   - All flow runs logged for 28 days
   - Status: Succeeded, Failed, Cancelled
   - Duration and action details

2. **Analytics:**
   - Success/failure rate
   - Average run duration
   - Actions executed

### Recommended Alerts

1. **Failure Rate:** Alert if >10% runs fail
2. **Duration:** Alert if runs exceed expected time
3. **Volume:** Alert on unusual spike in webhook calls

---

## Error Scenarios & Recovery

| Error | Cause | Response | Recovery |
|-------|-------|----------|----------|
| 400 Bad Request | Invalid payload schema | HTTP 400 | Fix payload format |
| 401 Unauthorized | Expired connection | N/A | Reconnect Planner |
| 404 Not Found | Invalid Plan/Bucket ID | HTTP 500 | Update IDs in flow |
| 429 Too Many Requests | Rate limit exceeded | HTTP 500 | Implement retry logic |
| 500 Server Error | Graph API issue | HTTP 500 | Retry after delay |

---

## Extension Points

### Future Enhancements

1. **Assignment Logic:**
   - Add user assignment based on category
   - Round-robin assignment to team members

2. **Custom Fields:**
   - Add labels/categories as Planner labels
   - Store custom metadata in task checklist

3. **Notifications:**
   - Send Teams/Email notifications on task creation
   - Notify assigned users

4. **Workflow Integration:**
   - Trigger downstream flows on task creation
   - Update external systems

---

## Compliance & Governance

### Data Residency

- Follows Microsoft 365 tenant data location
- Flow runs in Azure region nearest to tenant

### Retention

- Flow history: 28 days
- Planner tasks: Until manually deleted
- Webhook payloads: Not persisted beyond flow run

### Compliance Standards

- SOC 2 Type II (Azure)
- ISO 27001 (Microsoft 365)
- GDPR compliant (configurable)

---

## Version Control

### Configuration Management

- **Flow Definition:** Exported as JSON
- **Variables:** Documented in deployment guide
- **Connections:** Managed separately per environment

### Change Management

1. **Dev → Test:** Export/Import flow
2. **Test → Prod:** Update variables, test with sample payload
3. **Rollback:** Reimport previous version

---

## Integration Points

### Upstream Systems

- Any system capable of HTTP POST
- Typical integrators:
  - Web applications
  - Serverless functions
  - Scheduled jobs
  - Other Power Automate flows

### Downstream Systems

- Microsoft Planner (primary)
- Potential extensions:
  - Microsoft Teams
  - SharePoint lists
  - Email notifications
  - Database logging

---

## Cost Analysis

### Power Automate Licensing

- **Required:** Power Automate Premium (HTTP trigger)
- **Cost:** ~$15/user/month or $500/flow/month
- **Included In:** Office 365 E5, Microsoft 365 E5

### API Consumption

- **Microsoft Graph:** Included with appropriate license
- **Actions per Run:**
  - 5 initializations
  - 2 × N task creations (N = item count)
  - 2 × N priority updates
  - 2 responses (success/error)
  - **Total:** ~9 + (4 × N) actions

### Cost Optimization

- Minimal action count already
- Consider batching for very large payloads
- Use concurrency for faster execution

---

## Testing Strategy

### Unit Testing

- Test each action independently
- Validate expressions and transformations
- Check error handling paths

### Integration Testing

1. **Valid Payload:** Confirm tasks created
2. **Empty Arrays:** Handle zero items gracefully
3. **Invalid Data:** Verify error responses
4. **Large Payloads:** Test with 50+ items
5. **Rate Limiting:** Simulate throttling

### Load Testing

- Use test_webhook.py script
- Send concurrent requests
- Monitor flow performance
- Check Graph API throttling

---

## Maintenance Procedures

### Regular Maintenance

1. **Weekly:** Review run history for failures
2. **Monthly:** Check connection health
3. **Quarterly:** Update documentation
4. **Annually:** Review and optimize flow logic

### Troubleshooting Steps

1. Check run history for error details
2. Verify Plan/Bucket IDs are correct
3. Test Planner connection
4. Review payload format
5. Check Graph API service health

---

## Support & Resources

### Internal Documentation

- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- [sample_webhook_payload.json](./sample_webhook_payload.json)
- [Get-PlannerIDs.ps1](./Get-PlannerIDs.ps1)
- [test_webhook.py](./test_webhook.py)

### External References

- [Power Automate Docs](https://docs.microsoft.com/en-us/power-automate/)
- [Microsoft Graph Planner API](https://docs.microsoft.com/en-us/graph/api/resources/planner-overview)
- [Workflow Definition Language](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-workflow-definition-language)
