# Simple Flow Update Guide

## Option 1: Update Your Existing Flow (EASIEST)

You already have a flow with ID: `20db2fc2-1b67-4c77-b0e4-2dd42e611538`

### Steps:

1. **Open your existing flow**:
   - Go to: https://make.powerautomate.com/environments/Default-2131d362-e12d-44c1-843b-a1413d6b96a3/flows/20db2fc2-1b67-4c77-b0e4-2dd42e611538
   - Click **"Edit"**

2. **Add the missing actions manually**:

#### A. Add Variable Initializations (if not there):
- Click **"+ New step"**
- Search: **"Initialize variable"**
- Add 5 variables:
  - TeamID (String)
  - PlanID (String)
  - ActionItemsBucketID (String)
  - MissingInfoBucketID (String)
  - ProjectTitle (String): `triggerBody()?['scopeDocument']?['title']`

#### B. Add ForEach Loop for Action Items:
- Click **"+ New step"**
- Search: **"Apply to each"**
- Select value: `triggerBody()?['actionItems']`
- Inside loop, add:
  1. **Create a task (Planner)**
  2. **Update task details (Planner)** to set priority

#### C. Add ForEach Loop for Missing Information:
- Same as above but use: `triggerBody()?['analysis']?['missingInformation']`

#### D. Add Response Actions:
- Add **"Compose"** for success response
- Add **"Response"** action returning 200
- Add error handling with 500 response

---

## Option 2: Create New Flow from Blank (CLEANER)

1. **Go to Power Automate**:
   - https://make.powerautomate.com/environments/Default-2131d362-e12d-44c1-843b-a1413d6b96a3/flows

2. **Click "+ New flow"** → **"Instant cloud flow"**

3. **Name it**: "Scope Mapper - Create Planner Tasks from Webhook"

4. **Choose trigger**: "When an HTTP request is received"

5. **Add the schema** (click "Use sample payload to generate schema"):
```json
{
  "timestamp": "2025-11-14T10:30:00Z",
  "scopeDocument": {
    "title": "Project Name",
    "rawText": "Description"
  },
  "analysis": {
    "missingInformation": [
      {
        "item": "Missing item",
        "priority": "high",
        "category": "Category"
      }
    ]
  },
  "actionItems": [
    {
      "title": "Task title",
      "description": "Description",
      "priority": "high",
      "category": "Category",
      "dueInDays": 7
    }
  ]
}
```

6. **Add actions step by step** following the diagram:
   - 5 variable initializations
   - ForEach for actionItems
   - ForEach for missingInformation
   - Response actions

---

## Option 3: Copy Existing Flow (RECOMMENDED IF YOU HAVE ONE THAT WORKS)

1. Find a similar flow that works
2. Click **"..."** → **"Save As"**
3. Rename and modify

---

## Need the Exact Actions?

Here's what each Planner action needs:

### Create Task (Planner):
```
API: POST /v1.0/planner/tasks
Body:
{
  "planId": "@variables('PlanID')",
  "bucketId": "@variables('ActionItemsBucketID')",
  "title": "@{items('Loop_Through_Action_Items')?['title']}",
  "dueDateTime": "@{addDays(utcNow(), items('Loop_Through_Action_Items')?['dueInDays'])}"
}
```

### Set Priority (Planner):
```
API: PATCH /v1.0/planner/tasks/@{body('Create_Action_Item_Task')?['id']}
Headers:
  If-Match: @{body('Create_Action_Item_Task')?['@odata.etag']}
Body:
{
  "priority": "@{if(equals(items('Loop_Through_Action_Items')?['priority'], 'high'), 1, if(equals(items('Loop_Through_Action_Items')?['priority'], 'medium'), 5, 9))}"
}
```

---

## I'll Help You Build It Live

Tell me which option you prefer and I'll guide you through each click!
