# 🚀 Quick Start Guide - XbenchAutoQA

For de som vil i gang med én gang!

---

## 📦 Installasjon (2 minutter)

### 1. Pakk ut ZIP-filen
Pakk ut til f.eks. `C:\Tools\XbenchAutoQA\`

### 2. Kjør Setup
Høyreklikk på **`Setup-XbenchAutoQA.ps1`** → "Run with PowerShell"

**Hvis du får feilmelding:**
- Åpne PowerShell som administrator
- Kjør: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Svar **J**
- Prøv setup igjen

### 3. Følg wizarden
- Xbench-plassering: Trykk **Enter** (auto-detektert)
- Overvåkningsmappe: Trykk **Enter** (bruker standard)
- Auto-start QA: Trykk **N**
- Logging: Trykk **J**

✅ **Ferdig!**

---

## 🎯 Daglig bruk (30 sekunder)

### A. Start scriptet
Dobbeltklikk på **`XbenchAutoQA.ps1`**

La vinduet stå åpent!

### B. Eksporter fra MemoQ
1. MemoQ → **Translation → Export to XLIFF**
2. Velg **Bilingual MQXLIFF**
3. Lagre til: `C:\Translation\XbenchQA\`
4. Gi beskrivende navn: `Prosjekt123_no-NB.mqxliff`

### C. Velg handling
Scriptet oppdager filen automatisk (1-2 sek):

```
Velg handling:
  [1] Rask QA
  [2] Avansert oppsett
  [ESC] Ignorer
```

**For 99% av tilfellene:** Trykk **1**

### D. Kjør QA
Xbench åpnes automatisk:
- Trykk **F5** for å kjøre QA
- Se gjennom resultater
- Korriger feil

### E. Importer tilbake
1. Lagre i Xbench (Ctrl+S)
2. MemoQ → **Import → XLIFF**
3. Velg din oppdaterte fil

🎉 **Ferdig!**

---

## 💡 Pro Tips

**Tips 1:** La scriptet kjøre hele dagen - det bruker nesten ingen ressurser

**Tips 2:** Eksporter hele views fra MemoQ for å få alle filer på én gang

**Tips 3:** Bruk beskrivende filnavn: `Klient_Prosjekt_Språk.mqxliff`

**Tips 4:** Alternativ 2 (Avansert) hvis du trenger:
- Termlister
- Sjekklister
- Referansefiler

---

## ❌ Feilsøking (1 minutt)

**Problem:** Scriptet ser ikke filen min  
**Løsning:** Sjekk at du lagret til riktig mappe (`config.json`)

**Problem:** "Execution policy" feil  
**Løsning:** Se steg 2 under Installasjon

**Problem:** Xbench åpner ikke  
**Løsning:** Kjør setup på nytt

---

## 📖 Mer info?

Les den fullstendige **README.md** for:
- Detaljert dokumentasjon
- FAQ
- Avanserte innstillinger
- Logging og feilsøking

---

**Det var det! Lykke til med QA! 🎊**
