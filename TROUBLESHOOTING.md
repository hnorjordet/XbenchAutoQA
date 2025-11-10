# Troubleshooting Guide - XbenchAutoQA

## Common Issues and Solutions

### Error: "not an xbench file (108)"

**Fixed in v1.1.1!** This error occurred when:

1. **UTF-8 BOM Issue** (RESOLVED)
   - Generated XBP files had UTF-8 Byte Order Mark
   - Xbench requires UTF-8 WITHOUT BOM
   - **Solution**: Update to v1.1.1 or later

2. **XML Character Escaping** (RESOLVED)
   - Filenames with `&` character broke XML parsing
   - Files like `MG_Cat_L&J_Autos_Setup.mqxliff` caused crashes
   - **Solution**: Update to v1.1.1 - now properly escapes XML entities

### Files Not Being Detected

**Check:**
1. File extensions: Must be `.xlf`, `.xliff`, or `.mqxliff`
2. Watch folder is correct in config.json
3. Script is running (look for dots appearing every 2 seconds)

**Solution:**
```powershell
# Restart the script
Ctrl+C
.\XbenchAutoQA.ps1
```

### Parallels Path Issues

**Symptom:** Xbench can't find files even though XBP opens

**Solution:** Update to v1.1.1
- Paths now automatically convert from `C:\Mac\` to `\\Mac\` format
- Works seamlessly with Parallels shared folders

### Template File Not Found

**Error Message:**
```
Template file not found: C:\Mac\Home\Downloads\goddamnfuckingshit.xbp
```

**Solution:**
The script uses a template file for generating batch projects. Either:
1. Place your working XBP file at that location, OR
2. Edit line 82 in XbenchAutoQA.ps1 to point to your template file

**To create a template:**
1. Create a simple Xbench project manually with 1-2 files
2. Save it as template.xbp
3. Update the path in the script

### Script Won't Start

**Check PowerShell Execution Policy:**
```powershell
Get-ExecutionPolicy
```

**If it says "Restricted":**
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### Xbench Doesn't Open Automatically

**Check:**
1. config.json has correct path to Xbench.exe
2. Xbench is installed and working

**Test Xbench path:**
```powershell
$config = Get-Content config.json | ConvertFrom-Json
& $config.xbenchPath
```

### Files With Special Characters in Names

**Supported special characters** (as of v1.1.1):
- `&` → Escaped as `&amp;`
- `<` → Escaped as `&lt;`
- `>` → Escaped as `&gt;`
- `"` → Escaped as `&quot;`
- `'` → Escaped as `&apos;`

All properly handled automatically!

---

## Debug Mode

### Enable Detailed Logging

Edit config.json:
```json
{
  "logEnabled": true,
  ...
}
```

Logs are saved to: `logs/XbenchAutoQA_YYYYMMDD.log`

### Check What Files Are Being Processed

Watch the console output:
- Dots (`.`) = Polling activity
- File detection messages show when files are found
- Error messages appear in RED

---

## Still Having Issues?

1. Check the [CHANGELOG.md](CHANGELOG.md) for known issues
2. Verify you're running v1.1.1 or later
3. Try the diagnostic script (if available)
4. Check logs folder for error details

---

## Technical Details

### XBP File Format Requirements

Generated XBP files must:
- Use UTF-8 encoding WITHOUT BOM
- Have XML special characters properly escaped
- Use Windows UNC paths for Parallels (`\\Mac\` not `C:\Mac\`)
- Match Xbench version format (2.9.438 / 3.0.1603)

### Byte-Level Diagnostics

To verify file encoding:
```powershell
$bytes = [System.IO.File]::ReadAllBytes("path\to\file.xbp")
$bytes[0..2] | ForEach-Object { "{0:X2}" -f $_ }
```

**Should show:**
- `3C 3F 78` (correct - `<?x` in UTF-8 without BOM)

**Should NOT show:**
- `EF BB BF` (wrong - UTF-8 BOM present)

---

**Last Updated:** 2025-11-10 (v1.1.1)
