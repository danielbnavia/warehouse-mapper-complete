# Scope Mapper - Quick Reference Card

## Setup Checklist

- [ ] Import `ScopeMapperFlow_Complete.zip` to Power Automate
- [ ] Run `Get-PlannerIDs.ps1` to retrieve Planner IDs
- [ ] Create "Action Items" bucket in Planner
- [ ] Create "Missing Information" bucket in Planner
- [ ] Update `PlanID` variable in flow
- [ ] Update `ActionItemsBucketID` variable in flow
- [ ] Update `MissingInfoBucketID` variable in flow
- [ ] Copy webhook URL from flow trigger
- [ ] Test with `test_webhook.py` or curl
- [ ] Verify tasks appear in Planner

---

## Command Reference

### Get Planner IDs
```powershell
.\Get-PlannerIDs.ps1
```

### Test Webhook (Python)
```bash
python test_webhook.py YOUR_WEBHOOK_URL
python test_webhook.py YOUR_WEBHOOK_URL --custom
```

### Test Webhook (Curl)
```bash
curl -X POST "YOUR_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @sample_webhook_payload.json
```

### Test Webhook (PowerShell)
```powershell
$payload = Get-Content sample_webhook_payload.json -Raw
Invoke-RestMethod -Uri "YOUR_WEBHOOK_URL" `
  -Method Post `
  -Body $payload `
  -ContentType "application/json"
```

---

## Required Variables

| Variable | Value | How to Get |
|----------|-------|------------|
| TeamID | Your Teams group ID | Run `Get-PlannerIDs.ps1` |
| PlanID | Your Planner plan ID | Run `Get-PlannerIDs.ps1` |
| ActionItemsBucketID | Action Items bucket ID | Run `Get-PlannerIDs.ps1` |
| MissingInfoBucketID | Missing Info bucket ID | Run `Get-PlannerIDs.ps1` |
| ProjectTitle | Auto from payload | `triggerBody()?['scopeDocument']?['title']` |

---

## Payload Fields

### Required Structure
```json
{
  "timestamp": "2025-11-14T10:30:00Z",
  "scopeDocument": {
    "title": "Project Name",
    "rawText": "Description"
  },
  "analysis": {
    "missingInformation": [...]
  },
  "actionItems": [...]
}
```

### Action Item Object
```json
{
  "title": "Task title",
  "description": "Task description",
  "priority": "high|medium|low",
  "category": "Category name",
  "dueInDays": 7
}
```

### Missing Information Object
```json
{
  "item": "What's missing",
  "priority": "high|medium|low",
  "category": "Category name"
}
```

---

## Priority Mapping

| Text Value | Planner Priority | Display |
|------------|------------------|---------|
| `"high"` | 1 | Urgent |
| `"medium"` | 5 | Important |
| `"low"` | 9 | Normal |

---

## Response Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Tasks created |
| 400 | Bad Request | Check payload format |
| 500 | Server Error | Check flow run history |

---

## Common Errors

### "Unauthorized"
**Fix:** Reconnect Planner in Power Automate connections

### "Plan not found"
**Fix:** Verify `PlanID` is correct, run `Get-PlannerIDs.ps1`

### "Bucket not found"
**Fix:** Verify bucket IDs, ensure buckets exist in Planner

### "Invalid schema"
**Fix:** Validate JSON against expected structure

---

## Monitoring URLs

### Flow Run History
```
https://make.powerautomate.com
→ My flows
→ Select your flow
→ 28-day run history
```

### Microsoft Graph Explorer
```
https://developer.microsoft.com/en-us/graph/graph-explorer
```

### Planner Direct Link
```
https://tasks.office.com
```

---

## File Reference

| File | Purpose |
|------|---------|
| `ScopeMapperFlow_Complete.zip` | Import package |
| `flow.json` | Flow definition |
| `sample_webhook_payload.json` | Test payload |
| `Get-PlannerIDs.ps1` | Get Planner IDs |
| `test_webhook.py` | Test script |
| `README.md` | Quick start |
| `DEPLOYMENT_GUIDE.md` | Full deployment |
| `FLOW_ARCHITECTURE.md` | Technical docs |

---

## Typical Workflow

1. **Setup Phase**
   - Import flow
   - Get IDs
   - Configure variables

2. **Testing Phase**
   - Test with sample payload
   - Verify tasks created
   - Check priorities set

3. **Integration Phase**
   - Add webhook URL to app
   - Send real payloads
   - Monitor for errors

4. **Monitoring Phase**
   - Review run history
   - Check task creation
   - Adjust as needed

---

## Troubleshooting Steps

1. **Check flow run history**
   - Look for red X (failed runs)
   - Click to see error details

2. **Verify configuration**
   - Plan ID correct?
   - Bucket IDs correct?
   - Connection healthy?

3. **Test payload**
   - Valid JSON?
   - Matches schema?
   - All required fields present?

4. **Check permissions**
   - Can create tasks in plan?
   - Connection authenticated?
   - Planner license active?

---

## Performance Tips

- Typical run: 5-30 seconds
- Best for: 1-50 items per request
- Enable concurrency for faster processing
- Monitor Graph API throttling

---

## Security Checklist

- [ ] Keep webhook URL confidential
- [ ] Use HTTPS only
- [ ] Review Planner permissions
- [ ] Monitor for unusual activity
- [ ] Consider adding authentication layer
- [ ] Rotate webhook URL periodically

---

## Quick Links

- **Power Automate Portal:** https://make.powerautomate.com
- **Graph Explorer:** https://developer.microsoft.com/graph/graph-explorer
- **Planner:** https://tasks.office.com
- **Documentation:** [README.md](./README.md)

---

## Support

1. Check [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
2. Review [FLOW_ARCHITECTURE.md](./FLOW_ARCHITECTURE.md)
3. Examine flow run history
4. Validate payload format
5. Check Microsoft 365 service health

---

**Version:** 1.0.0 | **Updated:** 2025-11-14
