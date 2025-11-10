# Changelog - XbenchAutoQA

All notable changes to this project will be documented in this file.

---

## [1.1.1] - 2025-11-10

### 🐛 Critical Bug Fixes

**XBP File Generation Issues Resolved:**
- ✅ Fixed UTF-8 encoding: Changed from UTF-8 WITH BOM to UTF-8 WITHOUT BOM
  - Xbench was rejecting files due to the BOM bytes (`EF BB BF`) at the start
  - Generated files now match the exact format Xbench expects
- ✅ Fixed XML character escaping in filenames
  - Special characters (`&`, `<`, `>`, `"`, `'`) now properly escaped
  - Files like `MG_Cat_L&J_Autos_Setup.mqxliff` now work correctly
  - Prevents "not an xbench file (108)" error
- ✅ Improved Parallels Desktop compatibility
  - Correctly converts `C:\Mac\` paths to `\\Mac\` format
  - Works seamlessly with Parallels shared folders

**Technical Details:**
- Added `Escape-XmlString` helper function for XML entity encoding
- All file paths now properly escaped before writing to XBP files
- Both batch and single-file project generation updated

**Impact:**
- Script now works reliably with any number of files
- No more mysterious failures with certain filenames
- Generated XBP files are byte-for-byte compatible with Xbench

---

## [1.1.0] - 2025-10-31

### 🎉 New Features

**Batch Processing at Startup:**
- ✅ Detects multiple MQXLIFF files when script starts
- ✅ Offers to create single Xbench project with all files
- ✅ Generates timestamped batch project name (e.g., `Batch_2025-10-31_14-30.xbp`)
- ✅ Option to skip existing files and start monitoring

**Improvements:**
- Better file tracking (uses filepath only, not timestamp)
- Simplified filtering logic
- Debug output (dots) to show polling activity

**Use Cases:**
- Export multiple files from MemoQ view → Start script → Batch QA all at once
- Leave script running → New files processed individually as before

---

## [1.0.4] - 2025-10-31

### 🔄 Architecture Change

**Switched from Event-based to Polling:**
- Changed from FileSystemWatcher to polling every 2 seconds
- More reliable and compatible with interactive prompts
- Uses `Read-Host` instead of `ReadKey()` for better stability

---

## [1.0.0] - 2025-10-30

### 🎉 Initial Release

**Features:**
- ✅ Automatic file monitoring for MQXLIFF/XLIFF files
- ✅ Interactive setup wizard with auto-detection
- ✅ Two modes: Quick QA and Advanced setup
- ✅ MemoQ-specific file type support in Xbench projects
- ✅ Optional logging system
- ✅ Configuration management via JSON
- ✅ Comprehensive Norwegian and English documentation

**Supported:**
- Windows 10/11
- PowerShell 5.1+
- Xbench 2.9 and 3.0
- MemoQ desktop version
- File types: .xlf, .xliff, .mqxliff

**Known Limitations:**
- Desktop MemoQ only (no API integration)
- Manual import back to MemoQ required
- No automatic termlist integration

---

## Future Considerations

### [1.2.0] - Planned
- [ ] Template system for common project setups
- [ ] Keyboard shortcuts for common actions
- [ ] Better error handling for locked files

### [1.3.0] - Ideas
- [ ] Automatic termlist detection and inclusion
- [ ] Integration with common termbase formats
- [ ] Project-based configuration profiles
- [ ] Statistics and QA history tracking

### [2.0.0] - Future
- [ ] GUI interface option
- [ ] MemoQ Server API integration (if available)
- [ ] Batch processing mode
- [ ] Cloud sync for configurations

---

## Version Format

This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality (backwards compatible)
- **PATCH** version for backwards compatible bug fixes

---

**Feedback and suggestions welcome!**
