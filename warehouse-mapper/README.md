# Warehouse Visual Mapper

A drag-and-drop visual tool for mapping warehouse operations and data flow integrations.

**💡 Pro Tip:** Use [Intelligent Scope Mapper PRO](../power/intelligent-scope-mapper-pro.html) to analyze integration requirements first, then visualize them here!

## Project Structure

```
warehouse-mapper/
├── frontend/          # React + TypeScript + React Flow
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── store/         # Zustand state management
│   │   ├── services/      # API calls
│   │   ├── types/         # TypeScript definitions
│   │   └── lib/           # Constants and utilities
│   ├── package.json
│   └── vite.config.ts
│
└── backend/           # FastAPI + PostgreSQL
    ├── app/
    │   ├── api/          # API routes
    │   ├── core/         # Configuration
    │   ├── db/           # Database setup
    │   ├── models/       # SQLAlchemy models
    │   └── schemas/      # Pydantic schemas
    └── requirements.txt
```

## Features

✅ **Drag & Drop Interface**
- Component library with operations, messages, and systems
- Visual canvas with grid snapping
- Connect nodes with animated edges

✅ **Node Types**
- Physical Operations (receiving, storage, picking, packing, dispatch)
- Data Messages (ASN, Pick Orders, Manifests, etc.)
- System Integrations (CargoWise, Shopify, WMS, etc.)

✅ **Board Management**
- Save/load boards to database
- Pre-built templates
- Board validation
- Version control

✅ **Export Capabilities**
- JSON export
- Integration specification generation
- PDF export (frontend-based)

---

## 🔗 Integration with Scope Mapper PRO

**Recommended Workflow:**

```
1. Requirements Gathering
   ├─ Open ../power/intelligent-scope-mapper-pro.html
   ├─ Load template or paste integration scope
   ├─ Analyze and identify systems/processes
   └─ Export documentation + Power Automate flows

2. Visual Workflow Design (this tool)
   ├─ Create warehouse process diagram
   ├─ Map data flows between systems
   └─ Export integration specification

3. Deploy Automation
   ├─ Import PA flows to Power Automate
   └─ Configure system connections
```

**Why use both tools?**
- **Scope Mapper PRO:** Analyzes requirements, generates automation
- **Warehouse Mapper:** Visualizes operations, documents workflows
- **Together:** Complete integration documentation package

**See:** [Platform README](../README.md) for full workflow guide

## Quick Start

### Prerequisites

- Node.js 18+
- Python 3.11+
- PostgreSQL 15+

### 1. Database Setup

```bash
# Create PostgreSQL database
createdb warehouse_mapper

# Or using psql
psql -U postgres
CREATE DATABASE warehouse_mapper;
\q
```

### 2. Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Copy environment file
cp .env.example .env

# Edit .env with your database credentials
nano .env

# Run the server
cd app
python main.py
```

Backend will be available at: `http://localhost:8000`
API docs at: `http://localhost:8000/api/docs`

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Frontend will be available at: `http://localhost:5173`

## Usage

### Starting from Scope Document

**Recommended:** Analyze your integration scope first!

1. Open `../power/intelligent-scope-mapper-pro.html` in browser
2. Load a template (Shopify, Multi-Warehouse, Cross-Border, Email Bug Tracking)
3. Click "Analyze & Generate Flow" to identify systems and processes
4. Note the detected systems and processes
5. Use that information to build your visual workflow below

### Creating a Board

1. Open the application
2. Drag components from the left sidebar onto the canvas
3. Connect nodes by dragging from one node's handle to another
4. Click nodes to edit properties
5. Save the board using the toolbar

### Loading a Template

1. Click "Load Template" in the toolbar
2. Select a pre-built template (e.g., E-commerce Fulfillment)
3. Modify as needed
4. Save with a new name

### Exporting

- **JSON**: Click "Export JSON" to download board configuration
- **Integration Spec**: API endpoint generates structured integration requirements
- **PDF**: Use browser print or "Export PDF" for visual diagram

## API Endpoints

### Boards

```
GET    /api/boards?customer_id={id}      # List boards
GET    /api/boards/{board_id}            # Get board
POST   /api/boards                       # Create board
PUT    /api/boards/{board_id}            # Update board
DELETE /api/boards/{board_id}            # Delete board
POST   /api/boards/validate              # Validate board
```

### Templates

```
GET  /api/templates                      # List templates
GET  /api/templates/{template_id}        # Get template
POST /api/templates                      # Create template
```

### Export

```
GET  /api/export/json/{board_id}                # Export as JSON
GET  /api/export/integration-spec/{board_id}    # Export integration spec
```

## Database Schema

### boards table

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| customer_id | VARCHAR(255) | Customer identifier |
| board_name | VARCHAR(255) | Board name |
| board_type | VARCHAR(50) | Template type |
| nodes | JSONB | Node definitions |
| edges | JSONB | Connection definitions |
| metadata | JSONB | Additional data |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Last update |
| version | INTEGER | Version number |

### templates table

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| template_name | VARCHAR(255) | Template name |
| description | TEXT | Description |
| category | VARCHAR(100) | Category |
| nodes | JSONB | Node definitions |
| edges | JSONB | Connection definitions |
| is_active | BOOLEAN | Active status |

## Development

### Adding New Node Types

1. Add component definition to `frontend/src/lib/constants.ts`
2. Create node component in `frontend/src/components/nodes/`
3. Register in `nodeTypes` object in `Canvas.tsx`
4. Update TypeScript types in `types/index.ts`

### Creating Templates

Templates can be created through:
1. **UI**: Build a board and save as template
2. **API**: POST to `/api/templates`
3. **Database**: Direct SQL insert into templates table

### Deployment

**Frontend (Vercel)**:
```bash
cd frontend
npm run build
vercel deploy
```

**Backend (AWS ECS/Docker)**:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app/ ./app/
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Troubleshooting

### Frontend won't connect to backend

- Check CORS settings in `backend/app/core/config.py`
- Verify API_URL in frontend `.env` file
- Ensure backend is running on port 8000

### Database connection errors

- Verify PostgreSQL is running: `pg_isready`
- Check DATABASE_URL in `.env` file
- Ensure database exists: `psql -l | grep warehouse_mapper`

### Nodes not appearing after drag

- Check browser console for errors
- Verify React Flow is properly initialized
- Check that component data structure matches schema

## Related Tools

### **Intelligent Scope Mapper PRO** (`../power/`)
- Analyze integration requirements
- Generate Power Automate flows
- Export documentation
- **Start here** for new integration projects!

### **Scope Template** (`../scope.md`)
- Comprehensive 3PL integration scope template
- Fill in and analyze with Scope Mapper PRO
- Use as requirements checklist

### **Platform Overview** (`../README.md`)
- Complete platform capabilities
- Typical workflows by team
- ROI examples and use cases

---

## License

Proprietary - NaviaFreight Internal Use Only

## Support

For issues or questions:
- Email: daniel@naviafreight.com
- Internal Wiki: [link]
- Platform Docs: [../README.md](../README.md)
