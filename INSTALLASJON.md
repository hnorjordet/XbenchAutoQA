# Installasjonsinstrukser for XbenchAutoQA
**For kolleger som mottar denne pakken**

---

## 📩 Du har mottatt

En ZIP-fil som heter: **XbenchAutoQA.zip**

Dette er et verktøy som automatiserer QA-kjøring i Xbench for MemoQ XLIFF-filer.

---

## 🚀 Kom i gang på 3 minutter

### Steg 1: Pakk ut filen
1. Høyreklikk på **XbenchAutoQA.zip**
2. Velg "Extract All..." / "Pakk ut alle..."
3. Velg en plassering, f.eks.: `C:\Tools\XbenchAutoQA\`
4. Klikk "Extract" / "Pakk ut"

### Steg 2: Kjør setup
1. Gå inn i mappen du pakket ut til
2. **Høyreklikk** på filen **`Setup-XbenchAutoQA.ps1`**
3. Velg **"Run with PowerShell"** / **"Kjør med PowerShell"**

**⚠️ Viktig hvis du får feilmelding:**

Hvis du ser:
```
cannot be loaded because running scripts is disabled on this system
```

Gjør dette:
1. Trykk Windows-tasten
2. Søk etter "PowerShell"
3. **Høyreklikk** på "Windows PowerShell"
4. Velg **"Run as administrator"** / **"Kjør som administrator"**
5. I PowerShell-vinduet som åpnes, skriv inn:
   ```
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
6. Trykk **Enter**
7. Skriv **J** (for Ja) og trykk **Enter**
8. Lukk PowerShell-vinduet
9. Prøv setup igjen (steg 2 over)

### Steg 3: Følg setup-wizarden
Setup vil stille deg noen enkle spørsmål:

**Spørsmål 1:** "Er dette riktig?" (Xbench-plassering)
- Hvis Xbench-plasseringen er riktig: Trykk **Enter**
- Hvis ikke: Skriv **n**, trykk Enter, og skriv inn riktig sti

**Spørsmål 2:** "Trykk Enter for standard..." (Overvåkningsmappe)
- Standard er `C:\Translation\XbenchQA`
- Trykk **Enter** for å bruke standard
- Eller skriv inn ønsket mappe

**Spørsmål 3:** "Vil du at QA skal starte automatisk?"
- Anbefalt: **N** (nei)
- Dette gir deg mer kontroll

**Spørsmål 4:** "Vil du aktivere logging?"
- Anbefalt: **J** (ja)
- Dette hjelper hvis noe går galt

**✅ Setup er nå ferdig!**

---

## 📖 Hvordan bruke verktøyet

### Daglig bruk:

1. **Start scriptet:**
   - Dobbeltklikk på **`XbenchAutoQA.ps1`**
   - La vinduet stå åpent

2. **Eksporter fra MemoQ:**
   - MemoQ → Translation → Export to XLIFF
   - Velg **Bilingual MQXLIFF**
   - Lagre til mappen scriptet overvåker (f.eks. `C:\Translation\XbenchQA\`)

3. **Velg handling når scriptet oppdager filen:**
   - Trykk **1** for Rask QA (vanligst)
   - Trykk **2** for Avansert oppsett (med termlister)

4. **Kjør QA i Xbench:**
   - Xbench åpnes automatisk
   - Trykk **F5** for å kjøre QA
   - Se gjennom resultatene

5. **Importer tilbake til MemoQ:**
   - Lagre i Xbench (Ctrl+S)
   - MemoQ → Import → XLIFF
   - Velg den oppdaterte filen

---

## 📚 Dokumentasjon

I mappen finner du:

- **QUICKSTART.md** - Rask guide (anbefalt å lese først!)
- **README.md** - Fullstendig dokumentasjon på norsk
- **README_EN.md** - Full documentation in English
- **CHANGELOG.md** - Versjonsoversikt

---

## 🆘 Trenger du hjelp?

### Problem: Scriptet ser ikke filen min
**Løsning:** Sjekk at du lagret til riktig mappe. Åpne `config.json` i mappen for å se hvilken mappe som overvåkes.

### Problem: Xbench åpner ikke
**Løsning:** Kjør setup på nytt (steg 2 over).

### Problem: Annet
**Løsning:** Les **README.md** for omfattende feilsøkingsveiledning, eller kontakt personen som sendte deg denne pakken.

---

## ✉️ Tilbakemelding

Hvis du opplever problemer eller har forslag til forbedringer, gi beskjed til personen som sendte deg denne pakken!

---

**Lykke til med QA! 🎉**
