# Backend Installation Guide (Python 3.13+)

## Quick Start

### 1. Create Virtual Environment
```bash
cd backend
python -m venv venv
```

### 2. Activate Virtual Environment

**Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1
```

**Windows (Command Prompt):**
```cmd
venv\Scripts\activate.bat
```

**Git Bash/WSL:**
```bash
source venv/Scripts/activate
```

### 3. Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. Configure Environment
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your database credentials
# Make sure to use the psycopg3 format:
# DATABASE_URL=postgresql+psycopg://postgres:your_password@localhost:5432/warehouse_mapper
```

### 5. Run the Server
```bash
cd app
python main.py
```

The backend will be available at:
- API: http://localhost:8000
- API Docs: http://localhost:8000/api/docs
- Health Check: http://localhost:8000/health

## Troubleshooting

### Issue: "Defaulting to user installation"
**Solution:** Make sure you activated the virtual environment (see step 2)

### Issue: "psycopg2-binary build error"
**Solution:** We've updated to use `psycopg` (version 3) which is compatible with Python 3.13+

### Issue: "Database connection failed"
**Solution:**
1. Make sure PostgreSQL is installed and running
2. Check your DATABASE_URL format in .env uses `postgresql+psycopg://`
3. Verify database exists: `psql -U postgres -l | grep warehouse_mapper`

### Issue: "Module not found"
**Solution:** Make sure you're in the `backend/app` directory when running `python main.py`

## Database Setup

### Create PostgreSQL Database
```bash
# Option 1: Using psql
psql -U postgres
CREATE DATABASE warehouse_mapper;
\q

# Option 2: Using createdb
createdb -U postgres warehouse_mapper
```

### Verify Connection
```bash
psql -U postgres -d warehouse_mapper -c "SELECT version();"
```

## Development Tips

- Always activate the virtual environment before working
- Tables are created automatically on first run
- Use `uvicorn app.main:app --reload` for auto-reload during development
- Check logs if the server doesn't start properly
