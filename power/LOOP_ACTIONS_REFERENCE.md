# Loop Actions Reference - Complete Details

## ✅ CONFIRMATION: Both Loops Have Both Steps!

Your flow package **ScopeMapperFlow_FIXED.zip** contains all required actions.

---

## Loop 1: Action Items (Loop_Through_Action_Items)

### Step 1: Create_Action_Item_Task

**Action Type**: ApiConnection
**API**: POST /v1.0/planner/tasks
**Connection**: @parameters('$connections')['planner']['connectionId']

**What It Does**: Creates a new task in Microsoft Planner for each action item

**Body Parameters**:
```json
{
  "planId": "@variables('PlanID')",
  "bucketId": "@variables('ActionItemsBucketID')",
  "title": "@{items('Loop_Through_Action_Items')?['title']}",
  "assignments": {},
  "percentComplete": 0,
  "dueDateTime": "@{addDays(utcNow(), items('Loop_Through_Action_Items')?['dueInDays'])}",
  "details": {
    "description": "@{items('Loop_Through_Action_Items')?['description']}\n\nPriority: @{items('Loop_Through_Action_Items')?['priority']}\nCategory: @{items('Loop_Through_Action_Items')?['category']}\nProject: @{variables('ProjectTitle')}",
    "previewType": "description"
  }
}
```

**Field Mapping**:
- **Plan ID**: From PlanID variable (you configure this)
- **Bucket ID**: From ActionItemsBucketID variable (you configure this)
- **Title**: From payload → actionItems[].title
- **Due Date**: Calculated as today + dueInDays from payload
- **Description**: Includes description, priority, category, project name
- **Assignments**: Empty (task unassigned initially)
- **% Complete**: 0 (task not started)

**Returns**: Task object with ID and etag

---

### Step 2: Set_Task_Priority

**Action Type**: ApiConnection
**API**: PATCH /v1.0/planner/tasks/{taskId}
**Connection**: @parameters('$connections')['planner']['connectionId']
**Depends On**: Create_Action_Item_Task (must succeed first)

**What It Does**: Updates the task priority based on the priority value in payload

**Path**:
```
/v1.0/planner/tasks/@{encodeURIComponent(body('Create_Action_Item_Task')?['id'])}
```

**Headers**:
```json
{
  "If-Match": "@body('Create_Action_Item_Task')?['@odata.etag']"
}
```

**Body**:
```json
{
  "priority": "@{if(equals(items('Loop_Through_Action_Items')?['priority'], 'high'), 1, if(equals(items('Loop_Through_Action_Items')?['priority'], 'medium'), 5, 9))}"
}
```

**Priority Mapping Logic**:
- If priority = "high" → Set priority = **1** (Urgent)
- If priority = "medium" → Set priority = **5** (Important)
- If priority = "low" OR any other value → Set priority = **9** (Normal)

**Why Separate Step?**:
- Planner API requires task to be created first, then priority set in separate call
- If-Match header with etag ensures we're updating the correct version
- RunAfter ensures this only runs if Create succeeds

---

## Loop 2: Missing Information (Loop_Through_Missing_Information)

### Step 1: Create_Missing_Info_Task

**Action Type**: ApiConnection
**API**: POST /v1.0/planner/tasks
**Connection**: @parameters('$connections')['planner']['connectionId']

**What It Does**: Creates a new task in Microsoft Planner for each missing information item

**Body Parameters**:
```json
{
  "planId": "@variables('PlanID')",
  "bucketId": "@variables('MissingInfoBucketID')",
  "title": "Gather: @{items('Loop_Through_Missing_Information')?['item']}",
  "assignments": {},
  "percentComplete": 0,
  "details": {
    "description": "Missing Information Item\n\nCategory: @{items('Loop_Through_Missing_Information')?['category']}\nPriority: @{items('Loop_Through_Missing_Information')?['priority']}\nProject: @{variables('ProjectTitle')}",
    "previewType": "description"
  }
}
```

**Field Mapping**:
- **Plan ID**: From PlanID variable (you configure this)
- **Bucket ID**: From MissingInfoBucketID variable (you configure this)
- **Title**: "Gather: " + item name from payload → analysis.missingInformation[].item
- **Due Date**: Not set (no due date for missing info tasks)
- **Description**: Includes category, priority, project name
- **Assignments**: Empty (task unassigned initially)
- **% Complete**: 0 (task not started)

**Returns**: Task object with ID and etag

---

### Step 2: Set_Missing_Info_Priority

**Action Type**: ApiConnection
**API**: PATCH /v1.0/planner/tasks/{taskId}
**Connection**: @parameters('$connections')['planner']['connectionId']
**Depends On**: Create_Missing_Info_Task (must succeed first)

**What It Does**: Updates the task priority based on the priority value in payload

**Path**:
```
/v1.0/planner/tasks/@{encodeURIComponent(body('Create_Missing_Info_Task')?['id'])}
```

**Headers**:
```json
{
  "If-Match": "@body('Create_Missing_Info_Task')?['@odata.etag']"
}
```

**Body**:
```json
{
  "priority": "@{if(equals(items('Loop_Through_Missing_Information')?['priority'], 'high'), 1, if(equals(items('Loop_Through_Missing_Information')?['priority'], 'medium'), 5, 9))}"
}
```

**Priority Mapping Logic**:
- If priority = "high" → Set priority = **1** (Urgent)
- If priority = "medium" → Set priority = **5** (Important)
- If priority = "low" OR any other value → Set priority = **9** (Normal)

---

## Execution Flow

### For Each Action Item:
```
1. Webhook receives actionItems array
2. Loop starts
3. For item #1:
   a. Create_Action_Item_Task → POST creates task
   b. Wait for success
   c. Set_Task_Priority → PATCH updates priority using task ID from step a
4. For item #2:
   a. Create_Action_Item_Task → POST creates task
   b. Wait for success
   c. Set_Task_Priority → PATCH updates priority using task ID from step a
5. ... continues for all items
```

### For Each Missing Information:
```
1. After Action Items loop completes
2. Loop starts
3. For item #1:
   a. Create_Missing_Info_Task → POST creates task
   b. Wait for success
   c. Set_Missing_Info_Priority → PATCH updates priority using task ID from step a
4. For item #2:
   a. Create_Missing_Info_Task → POST creates task
   b. Wait for success
   c. Set_Missing_Info_Priority → PATCH updates priority using task ID from step a
5. ... continues for all items
```

---

## Example Payloads

### Action Item Example:
```json
{
  "title": "Configure EDI for Orders",
  "description": "Set up EDI mapping for order transmission between ERP and WMS",
  "priority": "high",
  "category": "Integration",
  "dueInDays": 7
}
```

**Results in**:
- **Task Title**: "Configure EDI for Orders"
- **Task Description**: "[description]\n\nPriority: high\nCategory: Integration\nProject: [project name]"
- **Due Date**: 7 days from now
- **Priority**: 1 (Urgent)
- **Bucket**: Action Items

---

### Missing Information Example:
```json
{
  "item": "EDI Mapping Details",
  "priority": "high",
  "category": "Technical"
}
```

**Results in**:
- **Task Title**: "Gather: EDI Mapping Details"
- **Task Description**: "Missing Information Item\n\nCategory: Technical\nPriority: high\nProject: [project name]"
- **Due Date**: None
- **Priority**: 1 (Urgent)
- **Bucket**: Missing Information

---

## API Endpoints Used

### Create Task:
```
POST https://graph.microsoft.com/v1.0/planner/tasks
```

**Required Permissions**: Tasks.ReadWrite

**Response**:
```json
{
  "id": "task-guid-here",
  "@odata.etag": "W/\"JzEtVGFzayAgQEBAQEBAQEBAQEBARCc=\"",
  "planId": "plan-guid",
  "bucketId": "bucket-guid",
  "title": "Task title",
  ...
}
```

### Update Task Priority:
```
PATCH https://graph.microsoft.com/v1.0/planner/tasks/{taskId}
Headers:
  If-Match: {etag}
```

**Required Permissions**: Tasks.ReadWrite

**Response**:
```json
{
  "id": "task-guid-here",
  "@odata.etag": "W/\"NEW-ETAG-HERE\"",
  "priority": 1
  ...
}
```

---

## Error Handling

### If Create Task Fails:
- Set Priority step is skipped (runAfter dependency)
- Loop continues to next item
- Error captured in error response at end

### If Set Priority Fails:
- Task is created but has default priority (5)
- Loop continues to next item
- Error captured in error response at end

### If Entire Loop Fails:
- Triggers error response path
- Returns HTTP 500 with error details
- Includes result() of failed actions

---

## Verification

To confirm both steps are working in Power Automate:

1. **Open your flow in edit mode**
2. **Click on "Loop_Through_Action_Items"**
3. **You should see**:
   - Create_Action_Item_Task (first step)
   - Set_Task_Priority (second step, with "run after" arrow from first)
4. **Click on "Loop_Through_Missing_Information"**
5. **You should see**:
   - Create_Missing_Info_Task (first step)
   - Set_Missing_Info_Priority (second step, with "run after" arrow from first)

---

## Testing

After import, test with this minimal payload:

```json
{
  "timestamp": "2025-11-14T10:30:00Z",
  "scopeDocument": {
    "title": "Test Project"
  },
  "actionItems": [
    {
      "title": "Test Action",
      "description": "Test description",
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
- 2 tasks created in Planner
- 1 in Action Items bucket (due date 3 days, priority 1)
- 1 in Missing Information bucket (no due date, priority 5)

---

## Summary

✅ **Loop 1** (Action Items): 2 steps
  - Create task (POST)
  - Set priority (PATCH)

✅ **Loop 2** (Missing Info): 2 steps
  - Create task (POST)
  - Set priority (PATCH)

✅ **Total actions in each loop**: 2
✅ **Total loops**: 2
✅ **Total loop actions**: 4

**All steps are present and correctly configured in ScopeMapperFlow_FIXED.zip!**
