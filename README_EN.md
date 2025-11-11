# Xbench Auto-QA for MemoQ

Automatic QA execution of MemoQ XLIFF files in Xbench.

## 📋 Table of Contents

- [What is this?](#what-is-this)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## 🎯 What is this?

This script automates the process of running QA checks in Xbench on MQXLIFF files exported from MemoQ. Instead of manually:
1. Exporting from MemoQ
2. Opening Xbench
3. Creating a new project
4. Importing XLIFF file
5. Running QA

...the script automates steps 2-4 when you export from MemoQ!

### Benefits
✅ Save time on repetitive imports  
✅ Consistent project setup  
✅ Faster QA workflow  
✅ Never forget to run QA  

---

## 💻 Requirements

- **Windows** (tested on Windows 10/11)
- **PowerShell 5.1** or newer (built into Windows)
- **Xbench** (version 2.9 or 3.0)
- **MemoQ** (desktop version)

---

## 📦 Installation

### Step 1: Extract files

Extract the ZIP file to a folder, for example:
```
C:\Tools\XbenchAutoQA\
```

You should have these files:
```
XbenchAutoQA/
├── Setup-XbenchAutoQA.ps1
├── XbenchAutoQA.ps1
├── README.md
└── README_EN.md
```

### Step 2: Run setup

1. **Right-click** on `Setup-XbenchAutoQA.ps1`
2. Select **"Run with PowerShell"**

   > ⚠️ **Important**: If you get an "execution policy" error:
   > 1. Open PowerShell **as administrator**
   > 2. Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
   > 3. Answer **Y** (Yes)
   > 4. Try setup again

3. **Follow the setup wizard:**

   ```
   [1/3] Finding Xbench...
   ✓ Xbench found: C:\Program Files (x86)\ApSIC\Xbench\xbench.exe
   Is this correct? [Y/n]:
   ```
   → Press **Enter** if the path is correct

   ```
   [2/3] Select watch folder for XLIFF files
   Default: C:\Translation\XbenchQA
   Press Enter for default, or enter desired path:
   ```
   → Press **Enter** for default, or type your preferred folder

   ```
   [3/3] Additional settings
   Should QA start automatically after project creation? [y/N]:
   ```
   → **N** (no) is recommended - you usually want to see the Xbench project first

   ```
   Enable logging? [Y/n]:
   ```
   → **Y** (yes) is recommended - helps with troubleshooting

4. **Setup complete!**
   ```
   ╔════════════════════════════════════════════════════════════╗
   ║                    Setup completed!                        ║
   ╚════════════════════════════════════════════════════════════╝
   
   Configuration:
     • Watch folder: C:\Translation\XbenchQA
     • Xbench: C:\Program Files (x86)\ApSIC\Xbench\xbench.exe
     • Auto-start QA: No
     • Logging: Enabled
   ```

A `config.json` file has now been created with your settings.

---

## 🚀 Usage

### Daily workflow

#### 1. Start monitoring

Double-click **`XbenchAutoQA.ps1`** or right-click → "Run with PowerShell"

You will see:
```
╔════════════════════════════════════════════════════════════╗
║          Xbench Auto-QA Runner                             ║
║          Running and waiting for MQXLIFF files             ║
╚════════════════════════════════════════════════════════════╝

Configuration:
  • Watching: C:\Translation\XbenchQA
  • Xbench: C:\Program Files (x86)\ApSIC\Xbench\xbench.exe
  • Auto-start QA: No
  • Logging: Enabled

Monitoring folder for new MQXLIFF/XLIFF files...
Press Ctrl+C to exit
```

Leave this window open!

#### 2. Export from MemoQ

In MemoQ:
1. Open your project
2. If multiple files: Create a **View** with all files you want to QA
3. Go to **Translation → Export to XLIFF**
4. **Important**: Select the right export format:
   - **Bilingual MQXLIFF** (recommended)
   - Or: **XLIFF 1.2 bilingual**
5. Save to the watch folder (e.g., `C:\Translation\XbenchQA\`)
6. Give the file a descriptive name (e.g., `Project_ABC_en-US.mqxliff`)

#### 3. The script detects the file

Within 1-2 seconds, the script will detect the file:

```
╔════════════════════════════════════════════════════════════╗
  New file detected: Project_ABC_en-US.mqxliff
╚════════════════════════════════════════════════════════════╝

Choose action:
  [1] Quick QA (MQXLIFF only, default settings)
  [2] Advanced setup (add termlists/checklists)
  [ESC] Ignore this file

Your choice:
```

#### 4. Choose action

**Option 1: Quick QA** (most common)
- Press **1**
- Xbench opens automatically with the file
- Press **F5** in Xbench to run QA
- Quick and simple!

**Option 2: Advanced setup**
- Press **2**
- Xbench opens with the project
- In Xbench: Add termlists, checklists, etc.
- Run QA when ready (F5)

**ESC: Ignore**
- Press **ESC** if you exported the wrong file

#### 5. Run QA in Xbench

1. Xbench is now open with your MQXLIFF
2. Press **F5** (or select **QA → Run Checklist**)
3. Review the results
4. Correct errors as needed

#### 6. Export back to MemoQ

When finished in Xbench:
1. **Save** changes in Xbench (Ctrl+S)
2. Return to MemoQ
3. **Import → XLIFF**
4. Select the updated MQXLIFF file
5. Done! 🎉

---

## 🐛 Troubleshooting

### "Execution policy" error

**Problem:** 
```
File cannot be loaded because running scripts is disabled on this system.
```

**Solution:**
1. Open PowerShell as administrator (right-click → "Run as administrator")
2. Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Answer **Y** (Yes)
4. Close and reopen PowerShell

### Script doesn't detect my file

**Checklist:**
- [ ] Is `XbenchAutoQA.ps1` running? (Do you see the "Monitoring folder..." message?)
- [ ] Did you export to the correct folder? (Check `config.json` for watch folder)
- [ ] Is the filename `.xlf`, `.xliff`, `.mqxliff`, or `.mxliff`?
- [ ] Try copying the file to the folder instead of exporting directly

### Xbench doesn't open

**Checklist:**
- [ ] Is Xbench installed?
- [ ] Run setup again: `.\Setup-XbenchAutoQA.ps1`
- [ ] Check `config.json` - is `xbenchPath` correct?

### How do I change settings?

**Method 1: Run setup again**
```powershell
.\Setup-XbenchAutoQA.ps1
```

**Method 2: Edit config.json manually**
Open `config.json` in Notepad:
```json
{
  "watchFolder": "C:\\Translation\\XbenchQA",
  "xbenchPath": "C:\\Program Files (x86)\\ApSIC\\Xbench\\xbench.exe",
  "autoStartQA": false,
  "logEnabled": true,
  "version": "1.0",
  "createdDate": "2025-10-30 12:00:00"
}
```
Change values and save.

### Where are the logs?

If logging is enabled, find log files here:
```
XbenchAutoQA/logs/XbenchAutoQA_YYYYMMDD.log
```

Example content:
```
[2025-10-30 14:23:15] [INFO] XbenchAutoQA started - watching: C:\Translation\XbenchQA
[2025-10-30 14:25:42] [INFO] New file detected: C:\Translation\XbenchQA\test_en-US.mqxliff
[2025-10-30 14:25:45] [INFO] Xbench project created: C:\Translation\XbenchQA\test_en-US.xbp
[2025-10-30 14:25:45] [INFO] Starting Xbench (quick QA): C:\Translation\XbenchQA\test_en-US.xbp
```

---

## ❓ FAQ

### Can I use this with multiple projects simultaneously?

Yes! The script processes files one at a time, so you can export multiple files to the watch folder. The script will detect and process them in sequence.

### Does this work with Xbench 2.9 and 3.0?

Yes, the script has been tested with both versions.

### What if I want to use different folders for different clients?

You can:
1. Change `watchFolder` in `config.json` to point to a common folder
2. Organize with subfolders (e.g., `C:\Translation\XbenchQA\ClientA\`)
3. Copy the entire XbenchAutoQA folder and set up separate installations

### Can I add termlists automatically?

Not yet - but you can:
1. Choose **Option 2** (Advanced setup)
2. Add termlists manually in Xbench
3. Save the Xbench project as a template for reuse

### Are files deleted automatically?

No, the script never deletes files. All exported XLIFF files and created Xbench project files remain in the watch folder.

### How do I uninstall?

Just delete the entire `XbenchAutoQA` folder. No system files are modified.

---

## 📝 Notes

### Supported file types

The script monitors for files with these extensions:
- `.xlf` (XLIFF 1.2)
- `.xliff` (XLIFF 1.2/2.0)
- `.mqxliff` (MemoQ XLIFF)
- `.mxliff` (Phrase XLIFF)

### Xbench project files

For each MQXLIFF, an `.xbp` (Xbench Project) file is created:
- Same name as the XLIFF file
- Saved in the same folder
- Can be reopened later in Xbench for reuse
- Type: **MemoQ** (optimized for MQXLIFF format)

### QA settings

Default QA checks that are enabled:
- ✅ Spell check
- ✅ Consistency check
- ✅ Key terms
- ✅ Tag validation
- ✅ Number check

You can modify these in the Xbench project.

---

## 🆘 Need help?

1. **Check the logs** in the `logs/` folder
2. **Run setup again** if something is misconfigured
3. **Test manually** that Xbench can open the MQXLIFF file directly
4. **Verify** that PowerShell execution policy is set correctly

---

## 📄 License

This script is created for internal use and sharing among translators.
Use and share freely! 🎁

---

**Version:** 1.0  
**Last updated:** October 30, 2025  
**Compatibility:** Windows 10/11, PowerShell 5.1+, Xbench 2.9/3.0
