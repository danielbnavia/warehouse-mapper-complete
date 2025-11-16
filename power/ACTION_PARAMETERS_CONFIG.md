# Action Parameters Configuration Guide

## ✅ You've Added All 4 Actions - Now Configure Them!

Copy these exact values into each action's parameters.

---

## LOOP 1: Action Items

### Action 1: Create Action Item Task (Planner: CreateTask_V4)

**Click on this action and fill in:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Group Id** | `TeamID` | Click "Dynamic content" → Select "TeamID" variable |
| **Plan Id** | `PlanID` | Click "Dynamic content" → Select "PlanID" variable |
| **Bucket Id** | `ActionItemsBucketID` | Click "Dynamic content" → Select "ActionItemsBucketID" variable |
| **Title** | `items('Apply_to_each')?['title']` | Click "Expression" tab, paste this |
| **Due Date Time** | `addDays(utcNow(), items('Apply_to_each')?['dueInDays'])` | Click "Expression" tab, paste this |
| **Percent Complete** | `0` | Type: 0 |
| **Task Details - Description** | See below ↓ | Use expression below |

**For Description field**, click "Expression" and paste:
```
concat(items('Apply_to_each')?['description'], char(10), char(10), 'Priority: ', items('Apply_to_each')?['priority'], char(10), 'Category: ', items('Apply_to_each')?['category'], char(10), 'Project: ', variables('ProjectTitle'))
```

**Or use this simpler version**:
```
items('Apply_to_each')?['description']
```
(You can add priority/category manually later)

---

### Action 2: Set Task Priority (Planner: UpdateTask_V3)

**Click on this action and fill in:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Task Id** | `body('Create_Action_Item_Task')?['id']` | Click "Expression" tab, paste this |
| **If-Match** | `body('Create_Action_Item_Task')?['@odata.etag']` | Click "Expression" tab, paste this |
| **Priority** | See below ↓ | Use expression below |

**For Priority field**, click "Expression" and paste:
```
if(equals(items('Apply_to_each')?['priority'], 'high'), 1, if(equals(items('Apply_to_each')?['priority'], 'medium'), 5, 9))
```

**IMPORTANT**: Configure "Run After" for this action:
- Click the **"..."** menu on this action
- Select **"Configure run after"**
- Check: **"is successful"** for "Create_Action_Item_Task"
- Click Done

---

## LOOP 2: Missing Information

### Action 3: Create Missing Info Task (Planner: CreateTask_V4)

**Click on this action and fill in:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Group Id** | `TeamID` | Click "Dynamic content" → Select "TeamID" variable |
| **Plan Id** | `PlanID` | Click "Dynamic content" → Select "PlanID" variable |
| **Bucket Id** | `MissingInfoBucketID` | Click "Dynamic content" → Select "MissingInfoBucketID" variable |
| **Title** | `concat('Gather: ', items('Apply_to_each_2')?['item'])` | Click "Expression" tab, paste this |
| **Percent Complete** | `0` | Type: 0 |
| **Task Details - Description** | See below ↓ | Use expression below |

**For Description field**, click "Expression" and paste:
```
concat('Missing Information Item', char(10), char(10), 'Category: ', items('Apply_to_each_2')?['category'], char(10), 'Priority: ', items('Apply_to_each_2')?['priority'], char(10), 'Project: ', variables('ProjectTitle'))
```

**Or use this simpler version**:
```
concat('Missing Information - ', items('Apply_to_each_2')?['item'])
```

---

### Action 4: Set Missing Info Priority (Planner: UpdateTask_V3)

**Click on this action and fill in:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Task Id** | `body('Create_Missing_Info_Task')?['id']` | Click "Expression" tab, paste this |
| **If-Match** | `body('Create_Missing_Info_Task')?['@odata.etag']` | Click "Expression" tab, paste this |
| **Priority** | See below ↓ | Use expression below |

**For Priority field**, click "Expression" and paste:
```
if(equals(items('Apply_to_each_2')?['priority'], 'high'), 1, if(equals(items('Apply_to_each_2')?['priority'], 'medium'), 5, 9))
```

**IMPORTANT**: Configure "Run After" for this action:
- Click the **"..."** menu on this action
- Select **"Configure run after"**
- Check: **"is successful"** for "Create_Missing_Info_Task"
- Click Done

---

## Quick Copy-Paste Reference

### Loop Name Detection:
Power Automate likely named your loops:
- First loop: **"Apply_to_each"**
- Second loop: **"Apply_to_each_2"**

**If your loop names are different**, replace `Apply_to_each` with your actual loop name in ALL expressions above.

---

## Expression Shortcuts

### For Title Fields:
**Action Items**:
```
items('Apply_to_each')?['title']
```

**Missing Info**:
```
concat('Gather: ', items('Apply_to_each_2')?['item'])
```

### For Due Date:
```
addDays(utcNow(), items('Apply_to_each')?['dueInDays'])
```

### For Priority (both loops):
```
if(equals(items('LOOP_NAME')?['priority'], 'high'), 1, if(equals(items('LOOP_NAME')?['priority'], 'medium'), 5, 9))
```
(Replace LOOP_NAME with Apply_to_each or Apply_to_each_2)

### For Task ID (Set Priority actions):
```
body('CREATE_ACTION_NAME')?['id']
```

### For ETag (Set Priority actions):
```
body('CREATE_ACTION_NAME')?['@odata.etag']
```

---

## Variables You Need:

Make sure these 5 variables are initialized BEFORE the loops:

1. **TeamID** (String): `6cdbd2a2-7e69-492e-ad7e-a617ed1c6597`
2. **PlanID** (String): `YOUR_PLAN_ID` ← Get from Get-PlannerIDs.ps1
3. **ActionItemsBucketID** (String): `YOUR_BUCKET_ID` ← Get from Get-PlannerIDs.ps1
4. **MissingInfoBucketID** (String): `YOUR_BUCKET_ID` ← Get from Get-PlannerIDs.ps1
5. **ProjectTitle** (String): `triggerBody()?['scopeDocument']?['title']`

---

## Step-by-Step Configuration Process

### For Each Action:

1. **Click on the action** in Power Automate designer
2. **For simple fields** (Group Id, Plan Id, Bucket Id):
   - Click in the field
   - Click **"Dynamic content"** button (lightning bolt icon)
   - Select the appropriate **variable** from the list

3. **For expression fields** (Title, Priority, Task ID, etc.):
   - Click in the field
   - Click **"Expression"** tab in the dynamic content panel
   - **Copy the expression** from this guide
   - **Paste it exactly** into the expression box
   - Click **"OK"**

4. **For "Run After" configuration**:
   - Click the **"..."** (three dots) menu on the action
   - Click **"Configure run after"**
   - Check **"is successful"** for the previous action
   - Click **"Done"**

---

## Common Issues & Fixes

### Issue: "items('Apply_to_each') not found"
**Fix**: Your loop might have a different name. Check the loop name and replace `Apply_to_each` in expressions.

### Issue: "Variable TeamID not found"
**Fix**: Make sure you've added the Initialize Variable actions BEFORE the loops.

### Issue: "Can't find Dynamic content"
**Fix**: Click inside the field first, then the lightning bolt icon should appear to open dynamic content panel.

### Issue: "Priority not setting"
**Fix**: Make sure you configured "Run After" on the Set Priority actions to run after the Create Task action succeeds.

### Issue: "Task ID is null"
**Fix**: The Create Task action must succeed first. Check that the Planner connection is configured correctly.

---

## Test Payload

After configuring all parameters, test with this:

```json
{
  "timestamp": "2025-11-14T10:30:00Z",
  "scopeDocument": {
    "title": "Test Project"
  },
  "actionItems": [
    {
      "title": "Test Action Item",
      "description": "This is a test action item",
      "priority": "high",
      "category": "Testing",
      "dueInDays": 3
    }
  ],
  "analysis": {
    "missingInformation": [
      {
        "item": "Test Missing Info",
        "priority": "medium",
        "category": "Testing"
      }
    ]
  }
}
```

**Expected Result**:
- 2 tasks created in your Planner plan
- 1 in Action Items bucket (title: "Test Action Item", due in 3 days, priority: 1)
- 1 in Missing Info bucket (title: "Gather: Test Missing Info", priority: 5)

---

## Checklist

Before saving:

- [ ] All 4 actions have parameters filled in
- [ ] Variables are initialized before loops
- [ ] Loop names in expressions match your actual loop names
- [ ] "Run After" configured on both Set Priority actions
- [ ] Planner connection is authenticated
- [ ] Plan ID and Bucket IDs are configured in variables
- [ ] Flow saved successfully

---

## Need Help?

If you get stuck on any parameter:
1. Check the loop name matches in your expressions
2. Make sure variables are initialized
3. Verify Planner connection is working
4. Test with the simple payload above

The expressions are all in this document - just copy/paste them into the Expression tab!
