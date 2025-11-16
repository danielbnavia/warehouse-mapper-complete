# PostgreSQL Setup Guide for Windows

## Step 1: Download PostgreSQL

1. **Visit the official PostgreSQL download page:**
   - Go to: https://www.postgresql.org/download/windows/
   - Click "Download the installer" (it will redirect to EnterpriseDB)
   - Download the latest version (PostgreSQL 15 or 16 recommended)

2. **Run the installer:**
   - Double-click the downloaded `.exe` file
   - Follow the installation wizard

## Step 2: Installation Settings

**Important settings during installation:**

1. **Installation Directory:**
   - Default: `C:\Program Files\PostgreSQL\16` (or your version)
   - Keep the default unless you have a specific reason to change it

2. **Select Components:**
   - ✅ PostgreSQL Server (required)
   - ✅ pgAdmin 4 (GUI tool - recommended for beginners)
   - ✅ Stack Builder (optional - for additional tools)
   - ✅ Command Line Tools (required)

3. **Data Directory:**
   - Default: `C:\Program Files\PostgreSQL\16\data`
   - Keep the default

4. **Password Setup:**
   - **This is VERY IMPORTANT - remember this password!**
   - Set a password for the `postgres` superuser account
   - Example: `postgres123` (use something secure!)
   - **Write this down - you'll need it for the .env file**

5. **Port:**
   - Default: `5432`
   - Keep the default (this is what the app expects)

6. **Advanced Options:**
   - Locale: Default (or your preference)
   - Precompiled binaries: Yes

7. **Complete Installation:**
   - Wait for installation to finish
   - **Don't uncheck "Launch Stack Builder"** if you want additional tools

## Step 3: Verify Installation

After installation, PostgreSQL should be running as a Windows service.

**Check if it's running:**
1. Press `Win + R`
2. Type `services.msc` and press Enter
3. Look for "postgresql-x64-16" (or your version)
4. Status should be "Running"

## Step 4: Create the Database

You have two options:

### Option A: Using pgAdmin (GUI - Easier for beginners)

1. **Open pgAdmin 4:**
   - Search for "pgAdmin 4" in Start menu
   - It should open in your browser

2. **Connect to Server:**
   - In the left panel, expand "Servers"
   - Click on "PostgreSQL 16" (or your version)
   - Enter the password you set during installation
   - Click "Save Password" if you want

3. **Create Database:**
   - Right-click on "Databases" → "Create" → "Database..."
   - Name: `warehouse_mapper`
   - Owner: `postgres` (default)
   - Click "Save"

### Option B: Using Command Line (psql)

1. **Open Command Prompt or PowerShell as Administrator**

2. **Navigate to PostgreSQL bin directory:**
   ```powershell
   cd "C:\Program Files\PostgreSQL\16\bin"
   ```

3. **Run psql:**
   ```powershell
   .\psql.exe -U postgres
   ```
   - Enter your password when prompted

4. **Create the database:**
   ```sql
   CREATE DATABASE warehouse_mapper;
   ```

5. **Verify it was created:**
   ```sql
   \l
   ```
   - You should see `warehouse_mapper` in the list

6. **Exit:**
   ```sql
   \q
   ```

## Step 5: Configure Your .env File

1. **Open the .env file** in the backend directory:
   ```powershell
   notepad .env
   ```

2. **Update the DATABASE_URL** with your password:
   ```
   DATABASE_URL=postgresql://postgres:YOUR_PASSWORD_HERE@localhost:5432/warehouse_mapper
   ```
   
   Replace `YOUR_PASSWORD_HERE` with the password you set during installation.

   **Example:**
   ```
   DATABASE_URL=postgresql://postgres:postgres123@localhost:5432/warehouse_mapper
   ```

3. **Save the file**

## Step 6: Test the Connection

After setting up, you can test if everything works:

```powershell
cd backend
python -c "from app.core.config import settings; print('Database URL configured:', settings.DATABASE_URL)"
```

## Troubleshooting

### "psql: command not found"
- PostgreSQL bin directory may not be in your PATH
- Use full path: `"C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres`
- Or add PostgreSQL bin to your system PATH (see installation guide)

### "Connection refused" or "Could not connect"
- Make sure PostgreSQL service is running (check services.msc)
- Verify the port is 5432
- Check Windows Firewall isn't blocking PostgreSQL

### "Password authentication failed"
- Double-check the password in your .env file
- Make sure there are no extra spaces
- Try resetting the postgres password in pgAdmin

### "Database does not exist"
- Make sure you created the `warehouse_mapper` database
- Check the database name matches exactly (case-sensitive)

## Next Steps

Once PostgreSQL is set up and your .env is configured:
1. Start the backend server: `cd backend/app && python main.py`
2. The database tables will be created automatically on first run
3. Check http://localhost:8000/api/docs to verify everything works

