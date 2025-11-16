# Visio Template Guide - Scope Mapper Flow

## Files Created

1. **`ScopeMapper-Flow-Diagram.drawio`** - Interactive flow diagram
   - Open with: https://app.diagrams.net (free, no install)
   - Or: Microsoft Visio (can import .drawio files)
   - Or: VS Code with Draw.io Integration extension

## How to Use

### Option 1: Open in Draw.io (Easiest - Free Online)

1. Go to: **https://app.diagrams.net**
2. Click **"Open Existing Diagram"**
3. Select **"ScopeMapper-Flow-Diagram.drawio"**
4. Edit and export as needed

### Option 2: Import to Microsoft Visio

1. Open **Microsoft Visio**
2. File → Open → Browse
3. Select **"ScopeMapper-Flow-Diagram.drawio"**
4. Visio will convert it automatically

### Option 3: VS Code

1. Install extension: **"Draw.io Integration"** by Henning Dieterichs
2. Open **ScopeMapper-Flow-Diagram.drawio** in VS Code
3. Edit inline with full diagram support

---

## Diagram Components

### 1. HTTP Trigger (Blue)
- Receives webhook POST requests
- Validates JSON schema
- Entry point for the flow

### 2. Variable Initialization (Yellow Box)
- 5 variables initialized in parallel
- Configuration values for Planner
- Runs in ~1 second

### 3. ForEach Loops (Green Boxes)
- **Action Items Loop** (Left)
  - Processes each action item from payload
  - Creates task with due date
  - Sets priority

- **Missing Information Loop** (Right)
  - Processes each missing information item
  - Creates task with "Gather:" prefix
  - Sets priority

### 4. API Actions (Purple)
- **Create Task**: POST to `/v1.0/planner/tasks`
- **Set Priority**: PATCH to `/v1.0/planner/tasks/{id}`

### 5. Decision Diamond (Orange)
- Checks if both loops succeeded
- Routes to success or error path

### 6. Response Actions
- **Success Path** (Light Blue): HTTP 200 with task counts
- **Error Path** (Red): HTTP 500 with error details

---

## Visio Stencils Used

If creating from scratch in Visio, use these stencils:

### Basic Flowchart Shapes
- **Process**: Rectangle (Variables, Actions, Compose)
- **Decision**: Diamond (Success check)
- **Terminator**: Rounded rectangle (Trigger, Responses)
- **Connector**: Circle (Split/merge points)

### Colors (Hex Codes)
- **Trigger**: #DAE8FC (Light Blue)
- **Variables**: #F8CECC (Light Red)
- **Containers**: #D5E8D4 (Light Green)
- **API Actions**: #E1D5E7 (Light Purple)
- **Success**: #B1DDF0 (Blue)
- **Error**: #F8CECC (Red)
- **Decision**: #FFE6CC (Orange)

---

## Creating Custom Visio Template

### Step 1: Set Up Page
```
Page Size: Letter (8.5" x 11") or A4
Orientation: Portrait
Grid: 0.25" or 0.5cm
Margins: 0.5" all sides
```

### Step 2: Add Shapes

**Layer 1: Trigger**
- Shape: Rounded Rectangle
- Size: 3" wide x 0.6" tall
- Fill: #DAE8FC
- Border: #6C8EBF (2pt)
- Text: "HTTP REQUEST TRIGGER\n(Webhook)"
- Font: 14pt Bold

**Layer 2: Variables Container**
- Shape: Rectangle
- Size: 7" wide x 1.8" tall
- Fill: #FFF2CC
- Border: #D6B656 (2pt)
- Text: "VARIABLE INITIALIZATION (Parallel)" at top

**Inside Variables Container:**
- 5 rectangles (1.2" x 0.5" each)
- Spaced evenly
- Fill: #F8CECC
- Labels: Team ID, Plan ID, Action Items Bucket, Missing Info Bucket, Project Title

**Layer 3: Split Connector**
- Shape: Small circle (0.2" diameter)
- Fill: Black
- Connects variables to both loops

**Layer 4: Action Items Loop (Left)**
- Outer Box: 3.8" x 2.4"
- Fill: #D5E8D4
- Border: #82B366
- Title: "FOR EACH: ACTION ITEMS"

**Inside Action Items Loop:**
- Create Task box: 3.4" x 0.85"
  - Fill: #E1D5E7
  - Text left-aligned with bullet points
- Arrow (dashed)
- Set Priority box: same size and style

**Layer 5: Missing Info Loop (Right)**
- Mirror of Action Items Loop
- Same dimensions and styling
- Title: "FOR EACH: MISSING INFORMATION"

**Layer 6: Merge Connector**
- Shape: Small circle
- Arrows from both loops converge here

**Layer 7: Decision Diamond**
- Shape: Diamond
- Size: 1.3" x 1.3"
- Fill: #FFE6CC
- Border: #D79B00
- Text: "Success?"

**Layer 8: Success Path (Left)**
- Compose box: 2.4" x 1"
  - Fill: #B1DDF0
  - Border: #10739E
- Arrow (green, thick)
- Response box: 2.4" x 0.7"
  - Same colors

**Layer 9: Error Path (Right)**
- Mirror of success path
- Fill: #F8CECC
- Border: #B85450
- Arrow (red, thick)

**Layer 10: Legend Box**
- Position: Bottom left
- Size: 2.8" x 2.8"
- Contains color samples with labels

**Layer 11: Stats Box**
- Position: Bottom center
- Size: 3" x 2.8"
- Lists flow statistics

**Layer 12: Notes Box**
- Position: Bottom right
- Size: 4" x 2.8"
- Configuration requirements

### Step 3: Add Connectors

**Connector Styles:**
- Normal flow: Solid black arrow, 2pt width
- Within loop: Dashed arrow, 2pt width
- Success: Solid green arrow (#00CC00), 2pt width
- Error: Solid red arrow (#CC0000), 2pt width

**Connector Type:**
- Use "Right Angle Connectors" for clean orthogonal routing
- Enable "Snap to Connection Points"

### Step 4: Add Text Annotations

**Font Specifications:**
- Headers: Segoe UI, 14pt, Bold
- Body text: Segoe UI, 11pt, Regular
- Small notes: Segoe UI, 10pt, Italic
- Code/technical: Courier New, 10pt, Regular

---

## Export Options

### For Documentation
```
Format: PDF
Quality: High (300 DPI)
Include: All pages
Embed fonts: Yes
```

### For Web/Presentations
```
Format: PNG
Size: 1920x2480 pixels
Transparency: No
Background: White
```

### For Editing
```
Format: .vsdx (Visio) or .drawio
Include all layers: Yes
Preserve formatting: Yes
```

---

## Template Customization

### To Modify for Your Organization

1. **Update Colors**: Change to match corporate branding
2. **Add Logo**: Insert in header or footer
3. **Change Labels**: Rename buckets to match your setup
4. **Add Details**: Include specific environment info
5. **Expand Sections**: Add more detail to any component

### To Create Variants

- **Simplified Version**: Remove legend and stats, focus on flow only
- **Detailed Version**: Add data types, field names, API endpoints
- **Presentation Version**: Larger fonts, simpler colors, focus on key steps

---

## Printing Guidelines

### For Letter Size (8.5" x 11")
```
Orientation: Portrait
Scale: 100%
Margins: 0.5" all sides
Print quality: High
```

### For Poster Size (24" x 36")
```
Scale: 200%
Print quality: Maximum
Use professional printer
Laminate for durability
```

---

## Related Files

- **flow.json**: Actual flow definition
- **FLOW_ARCHITECTURE.md**: Text-based architecture doc
- **README.md**: Quick start guide
- **DEPLOYMENT_GUIDE.md**: Full deployment instructions

---

## Tips for Effective Diagrams

### Do's
✅ Use consistent colors for similar elements
✅ Maintain consistent spacing and alignment
✅ Include a legend for color meanings
✅ Add annotations for complex sections
✅ Keep text concise and readable
✅ Use arrows to show clear flow direction

### Don'ts
❌ Overcrowd the diagram with too much detail
❌ Use too many different colors
❌ Cross connectors unnecessarily
❌ Use tiny fonts (minimum 10pt)
❌ Forget to include version info
❌ Mix different diagramming styles

---

## Version History

**v1.0.0** (2025-11-14)
- Initial Visio template
- Complete flow visualization
- Legend and statistics included
- Deployment notes added

---

## Support

For questions about the diagram:
1. Refer to FLOW_ARCHITECTURE.md for technical details
2. Check DEPLOYMENT_GUIDE.md for setup info
3. Review README.md for quick reference

For Visio/Draw.io help:
- Draw.io: https://desk.draw.io/support/solutions
- Visio: https://support.microsoft.com/en-us/visio

---

**File Location**: `M:\warehouse-mapper-complete\power\ScopeMapper-Flow-Diagram.drawio`

**Last Updated**: 2025-11-14
