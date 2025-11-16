# Warehouse Visual Mapper - Complete Implementation Guide

## Executive Summary

This document provides complete implementation details for the Warehouse Visual Mapper application - a drag-and-drop tool for visualizing warehouse operations and data integration flows.

---

## Architecture Overview

### System Components

```
┌──────────────────────────────────────────────────────────┐
│                    User Browser                           │
│  ┌────────────────────────────────────────────────────┐  │
│  │  React SPA (Port 5173/3000)                        │  │
│  │  - React Flow Canvas                               │  │
│  │  - Zustand State Management                        │  │
│  │  - Component Library                               │  │
│  │  - Export Functions                                │  │
│  └─────────────────┬──────────────────────────────────┘  │
└────────────────────┼─────────────────────────────────────┘
                     │ REST API (HTTP/JSON)
                     ▼
┌──────────────────────────────────────────────────────────┐
│         FastAPI Backend (Port 8000)                       │
│  ┌────────────────────────────────────────────────────┐  │
│  │  API Endpoints                                     │  │
│  │  /api/boards      - CRUD operations               │  │
│  │  /api/templates   - Template management           │  │
│  │  /api/export      - Export functionality          │  │
│  └─────────────────┬──────────────────────────────────┘  │
└────────────────────┼─────────────────────────────────────┘
                     │ SQLAlchemy ORM
                     ▼
┌──────────────────────────────────────────────────────────┐
│         PostgreSQL Database (Port 5432)                   │
│  - boards table         (board storage)                   │
│  - templates table      (template definitions)            │
│  - exports table        (export history)                  │
└──────────────────────────────────────────────────────────┘
```

---

## Installation & Setup

### Step 1: System Prerequisites

**Required Software:**
- Node.js 18.x or higher
- Python 3.11 or higher
- PostgreSQL 15 or higher
- Git

**Optional:**
- Docker & Docker Compose (for containerized deployment)
- AWS CLI (for cloud deployment)

### Step 2: Database Setup

```sql
-- Connect to PostgreSQL
psql -U postgres

-- Create database
CREATE DATABASE warehouse_mapper;

-- Create user (optional)
CREATE USER warehouse_admin WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE warehouse_mapper TO warehouse_admin;

-- Exit
\q
```

### Step 3: Backend Setup

```bash
# Navigate to project
cd warehouse-mapper/backend

# Create Python virtual environment
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env

# Edit .env with your database credentials
# DATABASE_URL=postgresql://postgres:password@localhost:5432/warehouse_mapper
nano .env

# Initialize database tables (automatic on first run)
# Tables will be created when you start the server

# Start development server
cd app
python main.py
```

**Verify backend is running:**
- Open browser to http://localhost:8000
- Visit http://localhost:8000/api/docs for Swagger UI

### Step 4: Frontend Setup

```bash
# Open new terminal
cd warehouse-mapper/frontend

# Install Node dependencies
npm install

# Create .env file (optional)
echo "VITE_API_URL=http://localhost:8000/api" > .env

# Start development server
npm run dev
```

**Verify frontend is running:**
- Open browser to http://localhost:5173
- Should see the Warehouse Visual Mapper interface

---

## Configuration

### Backend Configuration

**`backend/app/core/config.py`**

Key settings to customize:

```python
class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql://..."
    
    # CORS - Add your production domain
    BACKEND_CORS_ORIGINS: list[str] = [
        "http://localhost:3000",
        "http://localhost:5173",
        "https://your-production-domain.com"
    ]
    
    # Security
    SECRET_KEY: str = "generate-with-openssl-rand-hex-32"
    
    # File uploads
    MAX_UPLOAD_SIZE: int = 10 * 1024 * 1024  # 10MB
```

### Frontend Configuration

**`frontend/vite.config.ts`**

Configure proxy for local development:

```typescript
export default defineConfig({
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      },
    },
  },
});
```

---

## Usage Guide

### Creating Your First Board

1. **Start Application**
   - Frontend: http://localhost:5173
   - Backend should be running on port 8000

2. **Drag Components**
   - From left sidebar, drag "Receiving Dock" onto canvas
   - Drag "Storage Area" below it
   - Drag "ASN" message above Receiving Dock

3. **Connect Nodes**
   - Click and drag from the bottom handle of ASN
   - Drop on top handle of Receiving Dock
   - An animated line appears showing the connection

4. **Edit Node Properties**
   - Click any node to select it
   - Properties panel appears (if implemented)
   - Or double-click to edit label

5. **Save Board**
   - Click "Save Board" in toolbar
   - Board is saved to database
   - Note the board ID for future reference

### Using Templates

**Load E-commerce Template:**
1. Click "Load Template" button
2. Pre-configured workflow appears:
   - Shopify → Pick Order → Picking → Packing → Dispatch
   - Storage areas, WMS system included

**Customize Template:**
1. Move nodes by dragging
2. Add new connections by dragging between handles
3. Delete connections by selecting and pressing Delete
4. Save as new board

### Exporting

**JSON Export:**
```bash
# Via UI
Click "Export JSON" button → Downloads board-name.json

# Via API
curl http://localhost:8000/api/export/json/{board_id}
```

**Integration Specification:**
```bash
# Via API
curl http://localhost:8000/api/export/integration-spec/{board_id}
```

Returns structured document with:
- All system connections
- Message types and frequencies
- Integration requirements

---

## API Reference

### Boards Endpoints

**List Boards**
```http
GET /api/boards?customer_id=demo-customer
```

Response:
```json
[
  {
    "id": "uuid",
    "board_name": "My Warehouse",
    "customer_id": "demo-customer",
    "nodes": [...],
    "edges": [...],
    "created_at": "2025-01-15T10:00:00Z"
  }
]
```

**Create Board**
```http
POST /api/boards
Content-Type: application/json

{
  "board_name": "New Warehouse Flow",
  "customer_id": "demo-customer",
  "board_type": "ecommerce",
  "nodes": [...],
  "edges": [...]
}
```

**Update Board**
```http
PUT /api/boards/{board_id}
Content-Type: application/json

{
  "board_name": "Updated Name",
  "nodes": [...]
}
```

**Validate Board**
```http
POST /api/boards/validate
Content-Type: application/json

{
  "board_name": "Test",
  "customer_id": "demo",
  "nodes": [...],
  "edges": [...]
}
```

Response:
```json
{
  "valid": true,
  "errors": [],
  "warnings": [
    "2 nodes are not connected to any others"
  ]
}
```

### Templates Endpoints

**List Templates**
```http
GET /api/templates?category=ecommerce
```

**Get Template**
```http
GET /api/templates/{template_id}
```

---

## Data Structures

### Node Structure

```typescript
{
  "id": "operation-1234567890",
  "type": "operation",  // or "message" or "system"
  "position": { "x": 100, "y": 200 },
  "data": {
    "label": "Receiving Dock A",
    "icon": "🚪",
    "category": "receiving",
    "properties": {
      "capacity": "50 pallets/day",
      "hours": "6am-10pm"
    }
  }
}
```

### Edge Structure

```typescript
{
  "id": "e-asn-1-receiving-1",
  "source": "asn-1",
  "target": "receiving-1",
  "type": "smoothstep",
  "animated": true,
  "style": { "stroke": "#64748b", "strokeWidth": 2 }
}
```

---

## Customization

### Adding New Node Types

1. **Define Component** (`frontend/src/lib/constants.ts`):
```typescript
export const OPERATION_COMPONENTS: ComponentItem[] = [
  // Existing components...
  {
    id: 'kitting',
    label: 'Kitting Station',
    icon: '🔧',
    type: 'operation',
    category: 'kitting',
  },
];
```

2. **Update TypeScript Types** (`frontend/src/types/index.ts`):
```typescript
export type NodeCategory = 
  | 'receiving' 
  | 'kitting'  // Add new category
  | ...
```

3. **Optional: Create Custom Node Component**
If default styling isn't sufficient, create:
```typescript
// frontend/src/components/nodes/KittingNode.tsx
import { memo } from 'react';
import { Handle, Position, NodeProps } from 'reactflow';

const KittingNode = ({ data, selected }: NodeProps) => {
  return (
    <div className="custom-kitting-style">
      {/* Custom rendering */}
    </div>
  );
};

export default memo(KittingNode);
```

4. **Register Node Type**:
```typescript
// frontend/src/components/Canvas.tsx
const nodeTypes = {
  operation: OperationNode,
  message: MessageNode,
  system: SystemNode,
  kitting: KittingNode,  // Add new type
};
```

### Creating Custom Templates

**Option 1: Via Database**
```sql
INSERT INTO templates (
  template_name,
  description,
  category,
  nodes,
  edges
) VALUES (
  'Cross-Dock Operations',
  'Direct dock-to-dock transfer',
  'crossdock',
  '[{"id": "receiving-1", ...}]'::jsonb,
  '[{"id": "e1", ...}]'::jsonb
);
```

**Option 2: Via API**
```bash
curl -X POST http://localhost:8000/api/templates \
  -H "Content-Type: application/json" \
  -d @template.json
```

**Option 3: Via UI** (Future Enhancement)
- Build board in UI
- Click "Save as Template"
- Provide template name and description

---

## Production Deployment

### Docker Deployment

**`docker-compose.yml`:**
```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: warehouse_mapper
      POSTGRES_USER: warehouse_admin
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  backend:
    build: ./backend
    environment:
      DATABASE_URL: postgresql://warehouse_admin:${DB_PASSWORD}@db:5432/warehouse_mapper
      SECRET_KEY: ${SECRET_KEY}
    ports:
      - "8000:8000"
    depends_on:
      - db

  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

volumes:
  postgres_data:
```

**Deploy:**
```bash
docker-compose up -d
```

### AWS Deployment

**Backend (ECS Fargate):**
1. Build Docker image
2. Push to ECR
3. Create ECS task definition
4. Deploy to Fargate service

**Frontend (S3 + CloudFront):**
```bash
cd frontend
npm run build
aws s3 sync dist/ s3://your-bucket-name
aws cloudfront create-invalidation --distribution-id XXX --paths "/*"
```

**Database (RDS):**
- Create PostgreSQL RDS instance
- Update DATABASE_URL in backend environment

---

## Troubleshooting

### Common Issues

**Issue: "CORS error when calling API"**
```
Solution:
1. Check BACKEND_CORS_ORIGINS in backend/app/core/config.py
2. Add your frontend URL to allowed origins
3. Restart backend server
```

**Issue: "Database connection failed"**
```
Solution:
1. Verify PostgreSQL is running: pg_isready
2. Check DATABASE_URL format
3. Test connection: psql $DATABASE_URL
```

**Issue: "Nodes not draggable after drop"**
```
Solution:
1. Check React Flow is properly initialized
2. Verify node structure matches schema
3. Check browser console for errors
```

**Issue: "Frontend can't find backend"**
```
Solution:
1. Verify backend is running on port 8000
2. Check VITE_API_URL in frontend/.env
3. Test: curl http://localhost:8000/health
```

---

## Performance Optimization

### Frontend

1. **React Flow Performance:**
   - Use `memo()` for custom node components
   - Implement `shouldComponentUpdate` for complex nodes
   - Use `fitView` sparingly

2. **State Management:**
   - Keep Zustand store lean
   - Don't store derived state
   - Use selectors for computed values

3. **Bundle Size:**
   ```bash
   npm run build
   npx vite-bundle-visualizer
   ```

### Backend

1. **Database Indexing:**
   ```sql
   CREATE INDEX idx_boards_customer ON boards(customer_id);
   CREATE INDEX idx_boards_type ON boards(board_type);
   ```

2. **Query Optimization:**
   - Use pagination for large result sets
   - Add database connection pooling
   - Implement caching for templates

3. **API Response Time:**
   - Add Redis caching
   - Implement CDN for static assets
   - Use async/await for I/O operations

---

## Security Considerations

### Authentication (Future Enhancement)

```python
# Add to backend
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

async def get_current_user(token: str = Depends(oauth2_scheme)):
    # Verify JWT token
    # Return user object
    pass
```

### Input Validation

- All inputs validated via Pydantic schemas
- JSONB fields sanitized before storage
- File uploads restricted by size and type

### Database Security

- Use prepared statements (SQLAlchemy handles this)
- Never expose raw SQL errors to clients
- Implement row-level security for multi-tenancy

---

## Testing

### Frontend Tests (Future Implementation)

```bash
npm install -D @testing-library/react vitest
npm run test
```

### Backend Tests

```bash
pip install pytest pytest-asyncio httpx

# Run tests
pytest
```

**Example Test:**
```python
def test_create_board(client):
    response = client.post(
        "/api/boards",
        json={
            "board_name": "Test Board",
            "customer_id": "test",
            "nodes": [],
            "edges": []
        }
    )
    assert response.status_code == 201
    assert response.json()["board_name"] == "Test Board"
```

---

## Roadmap

### Phase 1 (Current - MVP)
- ✅ Drag-and-drop canvas
- ✅ Basic node types
- ✅ Save/load boards
- ✅ JSON export

### Phase 2 (Next 2 months)
- [ ] Node property editor panel
- [ ] Template library UI
- [ ] PDF export (frontend)
- [ ] User authentication
- [ ] Multi-tenant support

### Phase 3 (3-6 months)
- [ ] Real-time collaboration (WebSockets)
- [ ] AI-powered integration suggestions
- [ ] Cost estimation calculator
- [ ] Integration with CargoWise API
- [ ] Automated validation rules

### Phase 4 (6-12 months)
- [ ] Mobile app
- [ ] Advanced analytics
- [ ] Integration marketplace
- [ ] White-label options

---

## Support & Maintenance

### Backup Strategy

**Database Backups:**
```bash
# Daily automated backup
pg_dump warehouse_mapper > backup_$(date +%Y%m%d).sql

# Restore
psql warehouse_mapper < backup_20250115.sql
```

**Application Backups:**
- Source code: Git repository
- Environment configs: Encrypted vault
- User data: Database backups

### Monitoring

**Recommended Tools:**
- Application: Sentry for error tracking
- Infrastructure: DataDog or New Relic
- Uptime: UptimeRobot or Pingdom

**Key Metrics:**
- API response time (< 200ms)
- Database query time (< 50ms)
- Error rate (< 0.1%)
- User session duration

### Update Procedure

1. **Test in staging environment**
2. **Create database backup**
3. **Deploy backend** (zero-downtime deployment)
4. **Deploy frontend** (invalidate CDN cache)
5. **Monitor logs** for 1 hour post-deployment
6. **Rollback plan** ready if issues arise

---

## Contact & Resources

**Project Owner:** Daniel - Product Development Manager
**Email:** daniel@naviafreight.com

**Internal Resources:**
- Wiki: [Internal link]
- Slack: #warehouse-mapper
- Support: support@naviafreight.com

**External Resources:**
- React Flow Docs: https://reactflow.dev
- FastAPI Docs: https://fastapi.tiangolo.com
- PostgreSQL Docs: https://www.postgresql.org/docs/

---

*Document Version: 1.0*
*Last Updated: January 2025*
