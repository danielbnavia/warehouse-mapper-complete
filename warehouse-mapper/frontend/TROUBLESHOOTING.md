# Frontend Troubleshooting Guide

## Issue: "Static Page" or "Blank Page"

### Solution 1: Check Dev Server is Running

1. **Open Terminal/PowerShell**
2. **Navigate to frontend directory:**
   ```bash
   cd M:\warehouse-mapper-complete\warehouse-mapper\frontend
   ```

3. **Start the development server:**
   ```bash
   npm run dev
   ```

4. **You should see:**
   ```
   VITE v5.x.x  ready in XXX ms

   ➜  Local:   http://localhost:5173/
   ➜  Network: use --host to expose
   ➜  press h + enter to show help
   ```

5. **Open browser to:** `http://localhost:5173`
   - ✅ Use: `http://localhost:5173`
   - ❌ NOT: `file:///M:/warehouse-mapper-complete/...`

### Solution 2: Check Browser Console for Errors

1. **Press F12** (or right-click → Inspect)
2. **Click "Console" tab**
3. **Look for RED error messages**

**Common Errors:**

#### Error: "Failed to resolve module specifier"
**Fix:** Make sure you ran `npm install`
```bash
cd frontend
npm install
```

#### Error: "Cannot read properties of null"
**Fix:** React isn't mounting. Check that `div#root` exists in index.html

#### Error: Network/CORS errors
**Fix:** Backend isn't running (this is OK for now - frontend will still show UI)

### Solution 3: Clear Cache and Restart

```bash
# Stop the dev server (Ctrl+C)
# Clear Vite cache
rm -rf node_modules/.vite

# Restart
npm run dev
```

### Solution 4: Check Port Conflict

If port 5173 is already in use:

```bash
# Try a different port
npm run dev -- --port 3000
```

Then access: `http://localhost:3000`

### Solution 5: Verify Installation

```bash
# Check Node.js version (should be 18+)
node --version

# Check if dependencies are installed
ls node_modules | wc -l
# Should show ~370+ packages

# Rebuild if needed
rm -rf node_modules package-lock.json
npm install
npm run dev
```

## What You Should See

When working correctly, you should see:

1. **Left Sidebar:** Component Library with draggable items
   - Physical Operations (Receiving Dock, Storage Area, etc.)
   - Data Messages (ASN, Pick Order, etc.)
   - Systems (CargoWise, Shopify, etc.)

2. **Main Canvas:** Grid background with React Flow controls
   - Mini-map in bottom-right
   - Zoom controls in bottom-left
   - Empty canvas ready for dragging components

3. **Top Toolbar:** Buttons for Save, Export, Load Template, Clear

## Still Not Working?

### Check these files exist:
```bash
ls -la frontend/src/main.tsx
ls -la frontend/src/App.tsx
ls -la frontend/src/components/Canvas.tsx
ls -la frontend/src/components/Sidebar.tsx
ls -la frontend/src/components/Toolbar.tsx
```

### Verify package.json has scripts:
```bash
cat frontend/package.json | grep -A 5 '"scripts"'
```

Should show:
```json
"scripts": {
  "dev": "vite",
  "build": "tsc && vite build",
  "preview": "vite preview"
}
```

## Quick Test

Create a minimal test to verify React is working:

1. Stop the dev server (Ctrl+C)
2. Temporarily rename App.tsx:
   ```bash
   cd frontend/src
   mv App.tsx App.tsx.backup
   ```

3. Create simple test App:
   ```bash
   echo 'function App() { return <div style={{padding: "20px"}}><h1>✅ React is Working!</h1></div> } export default App;' > App.tsx
   ```

4. Start dev server:
   ```bash
   cd ../..
   npm run dev
   ```

5. If you see "✅ React is Working!" - React works, restore your app:
   ```bash
   cd src
   rm App.tsx
   mv App.tsx.backup App.tsx
   ```

## Need More Help?

**Share this info:**
1. Terminal output when running `npm run dev`
2. Browser console errors (F12 → Console tab)
3. What you see when you visit http://localhost:5173
4. Screenshot if possible
