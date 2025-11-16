# Scope Mapper PRO - Quick Start Cheat Sheet

**⚡ 1-Page Reference Guide | Print Me! | Pin Me!**

---

## 🚀 60-Second Setup

```
1. Open: intelligent-scope-mapper-pro.html
2. Load template: Email Bug Tracking
3. Click: Analyze & Generate Flow
4. Click: Export Power Automate Flow
5. Import to Power Automate
6. Configure connections
7. DONE! ✅
```

**Total Time:** 1 minute (plus 15 min for PA config)

---

## 🎯 When to Use Each Template

| **Template** | **Use When...** | **Time** |
|-------------|----------------|---------|
| 📦 Shopify → BGI | Standard 3PL e-commerce | 2 min |
| 🌍 Multi-Warehouse | 3+ locations, cross-border | 3 min |
| ✈️ Cross-Border | International + customs | 3 min |
| 📧 Email Bug Tracking | **NEW!** Email automation | **1 min** |

---

## 🔍 Magic Keywords for PA Detection

**Type these to trigger automation detection:**

| **Want This Flow** | **Include These Words** |
|-------------------|----------------------|
| Email Parser | "email parse" OR "email monitor" |
| Bug Tracking | "bug tracking" OR "issue tracking" |
| Webhook Handler | "webhook" OR "api integration" |
| Invoice Processing | "invoice" + "extract" OR "process" |

---

## 📥 Export Decision Tree

```
Need workflow docs? 
├─ Yes → Export Markdown
└─ No
    ↓
    Need structured data?
    ├─ Yes → Export JSON
    └─ No
        ↓
        Need automation?
        ├─ Yes → Export PA Flow ⚡
        └─ No → Generate Questions
```

---

## 🎨 UI Quick Reference

### **Left Panel Icons:**
- 📝 = Input area
- 📄 = File upload
- 🔍 = Analyze button
- 📦🌍✈️📧 = Quick templates
- ⚡ = **Power Automate export** (NEW!)

### **Right Panel Sections:**
- 📊 = Analysis cards
- ⚡ = **PA Opportunities** (NEW!)
- 🔄 = 4-column workflow
- 💾📄❓⚡ = Export buttons

---

## 🔢 Analysis Card Colors

| **Color** | **Meaning** |
|-----------|-----------|
| White | Normal |
| Yellow | Warning (missing info) |
| Red | Error (critical gaps) |
| **Blue** | **PA Automation detected!** (NEW!) |

---

## 💾 What Each Export Does

| **Export** | **Format** | **Opens In** | **Use For** |
|-----------|-----------|-------------|-----------|
| JSON | `.json` | Code editor | Data processing |
| Markdown | `.md` | Text editor | Documentation |
| Questions | `.md` | Text editor | Client follow-up |
| **PA Flow** | `.json` | **Power Automate** | **Automation!** ⚡ |

---

## 🛠️ PA Flow Import (5 Steps)

```
1. flow.microsoft.com
2. My flows → Import → Import Package (Legacy)
3. Upload exported JSON
4. Click Import
5. Configure connections
```

**Gotcha:** Use "Import Package (Legacy)" NOT "Import Flow"!

---

## ⚙️ Connection Types by Flow

| **Flow Type** | **Needs** |
|--------------|-----------|
| Email Parser | Outlook + SharePoint + HTTP |
| Bug Tracking | Outlook + Planner + SharePoint |
| Webhook Handler | HTTP only |
| Invoice Processing | Outlook + AI Builder |

---

## 🔑 Required Customization

**Every exported PA flow needs these updates:**

```
⚠️ BEFORE USING:

1. Replace: YOUR_AZURE_OPENAI_ENDPOINT
2. Replace: YOUR_API_KEY
3. Replace: YOUR_SITE (SharePoint)
4. Replace: YOUR_LIST (SharePoint)
5. Replace: YOUR_PLAN_ID (Planner)

✅ Then test!
```

---

## 🐛 Troubleshooting (30-Second Fixes)

| **Problem** | **Fix** |
|------------|---------|
| Export button gray | Run analysis first |
| No PA opportunities | Add keywords (see above) |
| Import failed | Use "Import Package (Legacy)" |
| Flow runs then fails | Update placeholder values |
| Can't find exported file | Check Downloads folder |

---

## 📞 Emergency Contacts

**Need help?**
- Check: SCOPE_MAPPER_PRO_GUIDE.md (full manual)
- Check: WHATS_DIFFERENT_PRO.md (comparison)
- Power Automate docs: flow.microsoft.com/docs

---

## 💡 Pro Tips

1. **Combo Templates:** Load multiple, merge in text box
2. **AI Prompts:** Edit after export for better accuracy
3. **Version Control:** Save exports with v1, v2, v3
4. **Test First:** Always test with sample data
5. **Error Handling:** Add Scope blocks for production

---

## 🎯 Most Common Workflows

### **1. Bug Tracking (Most Popular!)**
```
Load: Email Bug Tracking template
Export: PA Flow
Time: 30 min total
Savings: 8 hrs/week
```

### **2. Multi-System Integration**
```
Load: Shopify → BGI template
Customize: Add your systems
Export: Markdown (for docs) + PA Flow (for dev)
Time: 45 min total
Savings: 2 days development
```

### **3. Client Proposals**
```
Load: Relevant template
Customize: Client specifics
Export: Markdown + Questions
Time: 15 min
Use: Attach to proposal email
```

---

## 🏆 Success Metrics

**Track these after deploying PA flows:**

- ⏱️ Time saved per task
- 📊 Flow run count
- ✅ Success rate (%)
- 🐛 Errors caught
- 💰 ROI ($saved)

**Example:**
```
Email Bug Tracking Flow
├─ Runs: 150/week
├─ Success: 98%
├─ Time saved: 8 hrs/week
└─ ROI: $400/week @ $50/hr
```

---

## 📋 Pre-Flight Checklist

**Before exporting PA flow:**

- [ ] Analysis completed
- [ ] Systems detected correctly
- [ ] PA opportunity shown
- [ ] Blue automation card visible
- [ ] Export button enabled

**Before importing to PA:**

- [ ] Power Automate license active
- [ ] Permissions to create flows
- [ ] Required connections available
- [ ] Placeholder values ready

**Before going live:**

- [ ] Tested with sample data
- [ ] All connections configured
- [ ] Error handling added
- [ ] Team notified

---

## 🎨 Color Key

**In the tool:**
- 🟦 Blue = Power Automate feature
- 🟩 Green = Success/Complete
- 🟨 Yellow = Warning
- 🟥 Red = Error/Missing

**In this guide:**
- ⚡ = NEW in PRO version
- ✅ = Recommended
- ⚠️ = Important
- 🚀 = Quick win

---

## 🔄 Typical Day Using PRO

### **Morning:**
```
09:00 - Client call (discovery)
09:30 - Load Multi-Warehouse template
09:35 - Customize for client
09:40 - Export Markdown → Proposal
09:45 - Export Questions → Email
```

### **Afternoon:**
```
14:00 - Support team: "automate bug emails?"
14:05 - Load Email Bug Tracking template
14:10 - Export PA Flow
14:15 - Import to Power Automate
14:30 - Configure Outlook/Planner
14:45 - Test with sample email
15:00 - Go live ✅
```

**Total time:** 2 hours  
**Value created:** 8 hrs/week saved = $400/week = $20K/year ROI!

---

## 🎁 Bonus: Keyboard Shortcuts

**In the tool:**
- `Ctrl/Cmd + A` (in text box) = Select all
- `Ctrl/Cmd + V` = Paste scope
- `Enter` (in text box) = New line
- `Tab` = Navigate fields

**In Power Automate:**
- `Ctrl/Cmd + S` = Save flow
- `Ctrl/Cmd + Z` = Undo
- `F5` = Refresh

---

## 🌟 Remember

**The goal isn't perfection - it's automation!**

Even a 90% accurate flow saves hours of manual work.

You can always refine later. 

**Ship it! 🚀**

---

**Version:** 3.0 PRO  
**Print Date:** November 16, 2025  
**Keep this handy!** 📌
