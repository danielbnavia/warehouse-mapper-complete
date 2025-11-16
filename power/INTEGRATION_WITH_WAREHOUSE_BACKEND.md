# Integrating Scope Mapper PRO with Warehouse Backend

**How to connect Power Automate flows to your warehouse system APIs**

---

## 🎯 Overview

This guide shows how to use **Scope Mapper PRO** generated Power Automate flows to integrate with the **Warehouse Visual Mapper backend** and other warehouse systems.

**What you'll learn:**
1. Export PA flows from Scope Mapper PRO
2. Configure PA flows to call warehouse APIs
3. Connect to PostgreSQL database
4. Integrate with warehouse operations
5. End-to-end integration examples

---

## 🏗️ Architecture

```
┌─────────────────────────┐
│  Scope Mapper PRO       │
│  (Browser Tool)         │
└───────────┬─────────────┘
            │ Generates
            ▼
┌─────────────────────────┐
│  Power Automate Flow    │
│  - Email Parser         │
│  - Webhook Handler      │
│  - Bug Tracking         │
└───────────┬─────────────┘
            │ Calls APIs
            ▼
┌─────────────────────────┐      ┌──────────────────┐
│  Warehouse Backend      │◄────►│  PostgreSQL DB   │
│  (FastAPI)              │      │  warehouse_mapper│
│  Port: 8000             │      └──────────────────┘
└───────────┬─────────────┘
            │ Updates
            ▼
┌─────────────────────────┐
│  External Systems       │
│  - Shopify              │
│  - CargoWise            │
│  - ShipStation          │
└─────────────────────────┘
```

---

## 📋 Prerequisites

### **1. Warehouse Backend Running**

```bash
cd warehouse-mapper/backend
source venv/bin/activate
cd app
python main.py
```

Verify at: `http://localhost:8000/api/docs`

### **2. Power Automate License**

- Power Automate Per User (for HTTP connector)
- Or Power Automate Premium

### **3. Network Access**

- Warehouse API accessible from cloud (use ngrok for testing)
- Or deploy warehouse backend to Azure/AWS

---

## 🔧 Setup Steps

### **Step 1: Generate Flow from Scope Mapper PRO**

1. Open `intelligent-scope-mapper-pro.html`
2. Load template or paste integration scope
3. Ensure scope contains warehouse keywords:
   ```
   - "warehouse operations"
   - "inventory sync"
   - "order processing"
   - "receiving"
   - "shipping"
   ```
4. Click **"Analyze & Generate Flow"**
5. Click **"📥 Export Power Automate Flow"**
6. Save JSON file

---

### **Step 2: Prepare Warehouse API Endpoint**

#### **Option A: Local Testing with ngrok**

```bash
# In warehouse-mapper/backend terminal
ngrok http 8000

# Copy the https URL, e.g., https://abc123.ngrok.io
```

#### **Option B: Deploy to Azure**

```bash
# Deploy backend to Azure App Service
az webapp up --name naviafreight-warehouse-api --resource-group rg-naviafreight
```

#### **Option C: Use Public Cloud Deployment**

If already deployed, note your API URL:
```
https://warehouse-api.naviafreight.com
```

---

### **Step 3: Import to Power Automate**

1. Go to https://flow.microsoft.com
2. Click **"My flows"** → **"Import"** → **"Import Package (Legacy)"**
3. Upload the JSON file from Scope Mapper PRO
4. Click **"Import"**

---

### **Step 4: Configure Warehouse API Connection**

The exported PA flow will have placeholders. Update them:

#### **In the HTTP Action:**

**Before (placeholder):**
```json
{
  "uri": "YOUR_WAREHOUSE_API_ENDPOINT/api/boards",
  "method": "POST",
  "headers": {
    "Content-Type": "application/json"
  }
}
```

**After (configured):**
```json
{
  "uri": "https://abc123.ngrok.io/api/boards",
  "method": "POST",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json"
  },
  "body": {
    "customer_id": "@{variables('CustomerId')}",
    "board_name": "@{variables('BoardName')}",
    "board_type": "integration_flow",
    "nodes": @{variables('NodesArray')},
    "edges": @{variables('EdgesArray')}
  }
}
```

---

## 🔄 Integration Patterns

### **Pattern 1: Email → Warehouse Board Creation**

**Use Case:** Email arrives with integration requirements → Create visual workflow board

#### **Scope Mapper PRO Setup:**
1. Load **Email Bug Tracking** template
2. Customize for warehouse use case
3. Export PA flow

#### **Power Automate Flow:**

```
Trigger: When email arrives (Outlook)
├─ Extract requirements from email body
├─ Parse systems mentioned (Shopify, CargoWise, etc.)
├─ Initialize nodes array
├─ HTTP POST: Create board in warehouse backend
│  └─ URL: https://warehouse-api/api/boards
│  └─ Body: { customer_id, board_name, nodes, edges }
├─ Parse response (board_id)
├─ HTTP GET: Retrieve board
│  └─ URL: https://warehouse-api/api/boards/{board_id}
└─ Send confirmation email with board link
```

#### **Warehouse API Endpoints Used:**

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/boards` | POST | Create new board |
| `/api/boards/{board_id}` | GET | Retrieve board |
| `/api/boards/{board_id}` | PUT | Update board |
| `/api/export/json/{board_id}` | GET | Export board as JSON |

---

### **Pattern 2: Webhook → Warehouse Update**

**Use Case:** Shopify order created → Update warehouse board with order details

#### **Scope Mapper PRO Setup:**
1. Load **Multi-System Webhook Handler** template
2. Add warehouse as target system
3. Export PA flow

#### **Power Automate Flow:**

```
Trigger: HTTP request (webhook)
├─ Immediate response (202 Accepted)
├─ Parse webhook payload
├─ Compose order data
├─ Parallel Scope:
│   ├─ Branch 1: HTTP POST to Shopify
│   ├─ Branch 2: HTTP POST to CargoWise
│   └─ Branch 3: HTTP POST to Warehouse API
│       └─ URL: https://warehouse-api/api/boards/{board_id}
│       └─ Body: { metadata: { order_id, status, timestamp } }
├─ HTTP POST: Log to audit table (SharePoint)
└─ Error handling scope
```

#### **Warehouse API Request:**

```json
PUT /api/boards/{board_id}
Content-Type: application/json

{
  "metadata": {
    "last_order_id": "SO-12345",
    "last_order_status": "processing",
    "updated_at": "2025-11-16T10:30:00Z",
    "source": "shopify_webhook"
  }
}
```

---

### **Pattern 3: Scheduled Inventory Sync**

**Use Case:** Daily inventory sync from ERP → Warehouse board update

#### **Scope Mapper PRO Setup:**
1. Paste scope with inventory sync requirements
2. Analyze to detect systems
3. Export PA flow

#### **Power Automate Flow:**

```
Trigger: Recurrence (daily at 6 AM)
├─ HTTP GET: Fetch inventory from ERP
│  └─ URL: https://erp.customer.com/api/inventory
├─ Parse JSON response
├─ Apply to each inventory item:
│   └─ Compose node data
├─ HTTP PUT: Update warehouse board nodes
│  └─ URL: https://warehouse-api/api/boards/{board_id}
│  └─ Body: { nodes: @{variables('UpdatedNodes')} }
└─ Send status email
```

---

## 🗄️ Database Integration

### **Direct PostgreSQL Connection (Advanced)**

For scenarios where PA needs direct database access:

#### **1. Install PostgreSQL Connector in PA**

Power Automate supports PostgreSQL through:
- Premium connector (requires license)
- Custom connector (Azure SQL Data Gateway)

#### **2. Configure Connection**

```
Server: warehouse-db.postgres.database.azure.com
Database: warehouse_mapper
User: powerautomate_user
Password: [from Azure Key Vault]
SSL: Required
```

#### **3. Query Boards Table**

**Action:** PostgreSQL - Execute query

```sql
SELECT id, customer_id, board_name, nodes, edges, metadata
FROM boards
WHERE customer_id = 'CUST-12345'
ORDER BY updated_at DESC
LIMIT 10;
```

#### **4. Insert New Board**

**Action:** PostgreSQL - Insert row

```sql
INSERT INTO boards (id, customer_id, board_name, board_type, nodes, edges, metadata)
VALUES (
  gen_random_uuid(),
  'CUST-12345',
  'Shopify Integration Flow',
  'integration_flow',
  '[...]'::jsonb,
  '[...]'::jsonb,
  '{}'::jsonb
)
RETURNING id;
```

---

## 🔐 Security Best Practices

### **1. API Key Authentication**

Update warehouse backend to require API keys:

**Backend (FastAPI):**
```python
# backend/app/api/dependencies.py
from fastapi import Header, HTTPException

async def verify_api_key(x_api_key: str = Header(...)):
    if x_api_key != os.getenv("WAREHOUSE_API_KEY"):
        raise HTTPException(status_code=401, detail="Invalid API key")
    return x_api_key
```

**Power Automate HTTP Action:**
```json
{
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "@{parameters('WarehouseApiKey')}"
  }
}
```

Store API key as PA parameter or Azure Key Vault secret.

---

### **2. OAuth 2.0 (Production)**

For production deployments:

**Backend:**
```python
# Use Azure AD authentication
from fastapi_azure_auth import AzureADAuth

auth_scheme = AzureADAuth(
    tenant_id=os.getenv("AZURE_TENANT_ID"),
    client_id=os.getenv("AZURE_CLIENT_ID")
)
```

**Power Automate:**
Use Azure AD connector with service principal.

---

### **3. IP Whitelisting**

Restrict warehouse API to Power Automate IPs:

```python
# backend/app/middleware.py
ALLOWED_IPS = [
    "13.64.0.0/11",      # Power Automate US
    "13.104.0.0/14",     # Azure services
    "YOUR_NGROK_IP"      # For testing
]
```

---

## 📊 Example: Complete Integration

### **Scenario: Email-Triggered Warehouse Workflow Creation**

**Goal:** Support email arrives → Extract requirements → Create warehouse board → Export integration spec

#### **1. Setup in Scope Mapper PRO**

```
Template: Email Bug Tracking
Customization:
- Change "bug" to "integration request"
- Add warehouse-specific fields
- Export PA flow
```

#### **2. Import to Power Automate**

```
Flow Name: "Email to Warehouse Board"
Trigger: When email arrives (support@naviafreight.com)
```

#### **3. Configure Actions**

**Action 1: Initialize Variables**
```json
{
  "CustomerId": "@{triggerOutputs()?['body/from']}",
  "BoardName": "@{triggerOutputs()?['body/subject']}",
  "EmailBody": "@{triggerOutputs()?['body/bodyPreview']}"
}
```

**Action 2: Extract Requirements (Azure OpenAI)**
```json
POST https://YOUR_AZURE_OPENAI_ENDPOINT/openai/deployments/gpt-4/chat/completions?api-version=2024-02-15-preview
Headers: { "api-key": "YOUR_KEY" }
Body: {
  "messages": [
    {
      "role": "system",
      "content": "Extract warehouse integration requirements from email. Return JSON: { systems: [], processes: [], nodes: [] }"
    },
    {
      "role": "user",
      "content": "@{variables('EmailBody')}"
    }
  ]
}
```

**Action 3: Parse AI Response**
```json
Parse JSON: @{outputs('HTTP_Azure_OpenAI')?['body/choices'][0]['message']['content']}
Schema: { systems: [], processes: [], nodes: [] }
```

**Action 4: Create Warehouse Board**
```json
POST https://warehouse-api.naviafreight.com/api/boards
Headers: {
  "Content-Type": "application/json",
  "X-API-Key": "@{parameters('WarehouseApiKey')}"
}
Body: {
  "customer_id": "@{variables('CustomerId')}",
  "board_name": "@{variables('BoardName')}",
  "board_type": "email_generated",
  "nodes": @{body('Parse_AI_Response')?['nodes']},
  "edges": [],
  "metadata": {
    "source": "email",
    "email_subject": "@{triggerOutputs()?['body/subject']}",
    "created_by": "@{triggerOutputs()?['body/from']}"
  }
}
```

**Action 5: Export Integration Spec**
```json
GET https://warehouse-api.naviafreight.com/api/export/integration-spec/@{body('Create_Warehouse_Board')?['id']}
```

**Action 6: Send Confirmation**
```json
Send email (Outlook)
To: @{triggerOutputs()?['body/from']}
Subject: "Warehouse Board Created: @{variables('BoardName')}"
Body: "Your integration workflow has been created. View at: http://localhost:5173/board/@{body('Create_Warehouse_Board')?['id']}"
Attachments: @{body('Export_Integration_Spec')}
```

#### **4. Test**

Send email to support@naviafreight.com:
```
Subject: Shopify to BGI Integration
Body:
We need to integrate Shopify orders with BGI warehouse.
- Receive orders from Shopify
- Create picking tasks in warehouse
- Generate shipping labels
- Update Shopify with tracking numbers
```

**Expected Result:**
1. PA flow triggers
2. AI extracts: Systems=[Shopify, BGI], Processes=[Order processing, Shipping]
3. Warehouse board created with nodes
4. Integration spec exported
5. Confirmation email sent with board link

---

## 🧪 Testing & Debugging

### **1. Test Warehouse API**

```bash
# Test board creation
curl -X POST http://localhost:8000/api/boards \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "TEST-001",
    "board_name": "Test Integration",
    "board_type": "test",
    "nodes": [],
    "edges": []
  }'
```

### **2. Test PA Flow**

1. Go to flow.microsoft.com
2. Open flow → Click "Test"
3. Select "Manually"
4. Trigger (send email or HTTP POST)
5. Monitor run history

### **3. Debug Failed Actions**

Check PA flow run details:
- Inputs/Outputs for each action
- Error messages
- HTTP response codes

Common issues:
| Error | Cause | Fix |
|-------|-------|-----|
| 401 Unauthorized | Missing/invalid API key | Check X-API-Key header |
| 404 Not Found | Wrong endpoint URL | Verify warehouse API URL |
| 500 Server Error | Backend crash | Check backend logs |
| Timeout | ngrok expired | Restart ngrok |

---

## 📈 Monitoring & Analytics

### **1. Power Automate Analytics**

Track in flow.microsoft.com:
- ✅ Successful runs
- ❌ Failed runs
- ⏱️ Average run time
- 📊 Usage trends

### **2. Warehouse Backend Logs**

```python
# backend/app/main.py
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

@app.post("/api/boards")
async def create_board(board: BoardCreate):
    logging.info(f"Board created by PA flow: {board.board_name}")
    # ...
```

### **3. Database Metrics**

Query PostgreSQL for insights:

```sql
-- Boards created by Power Automate
SELECT COUNT(*), DATE(created_at)
FROM boards
WHERE metadata->>'source' = 'power_automate'
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC;

-- Most active customers
SELECT customer_id, COUNT(*) as board_count
FROM boards
GROUP BY customer_id
ORDER BY board_count DESC
LIMIT 10;
```

---

## 🚀 Deployment Checklist

**Before Production:**

- [ ] Warehouse backend deployed to cloud (Azure/AWS)
- [ ] PostgreSQL database secured with firewall rules
- [ ] API key authentication enabled
- [ ] HTTPS/SSL configured
- [ ] Power Automate flow tested end-to-end
- [ ] Error handling and retry logic added
- [ ] Monitoring and alerts configured
- [ ] Documentation updated with production URLs
- [ ] Team trained on flow operation
- [ ] Backup and recovery plan in place

---

## 📚 API Reference

### **Warehouse Backend Endpoints**

Full API docs: `http://localhost:8000/api/docs`

#### **Boards**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/boards` | GET | List all boards (query: `?customer_id=`) |
| `/api/boards` | POST | Create new board |
| `/api/boards/{board_id}` | GET | Get specific board |
| `/api/boards/{board_id}` | PUT | Update board |
| `/api/boards/{board_id}` | DELETE | Delete board |
| `/api/boards/validate` | POST | Validate board structure |

#### **Export**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/export/json/{board_id}` | GET | Export board as JSON |
| `/api/export/integration-spec/{board_id}` | GET | Export integration spec |

#### **Templates**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/templates` | GET | List templates |
| `/api/templates/{template_id}` | GET | Get template |

---

## 🎓 Next Steps

1. **Start Simple:** Test email → board creation flow
2. **Add Complexity:** Integrate with external systems (Shopify, CargoWise)
3. **Scale Up:** Deploy to production with monitoring
4. **Optimize:** Add caching, batch processing, parallel execution
5. **Extend:** Build custom connectors for proprietary systems

---

## 💡 Pro Tips

### **Tip 1: Use Correlation IDs**

Track requests across systems:
```json
{
  "metadata": {
    "correlation_id": "@{guid()}",
    "flow_run_id": "@{workflow()?['run']['name']}"
  }
}
```

### **Tip 2: Implement Retry Logic**

```json
HTTP Action Settings:
- Retry Policy: Exponential backoff
- Count: 3
- Interval: 10 seconds
```

### **Tip 3: Cache API Responses**

Store frequently accessed data in PA variables to reduce API calls.

### **Tip 4: Version Your Flows**

Use flow versioning in PA:
- v1.0: Basic email → board
- v1.1: Added AI extraction
- v2.0: Multi-system integration

---

**Version:** 1.0
**Last Updated:** November 16, 2025
**Status:** ✅ Ready to Integrate

**Questions?** See [Platform README](../README.md) or [Scope Mapper PRO Guide](SCOPE_MAPPER_PRO_GUIDE.md)
