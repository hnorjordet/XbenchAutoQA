# Xbench Auto-QA for MemoQ

Automatisk QA-kjøring av MemoQ XLIFF-filer i Xbench.

## 📋 Innholdsfortegnelse

- [Hva er dette?](#hva-er-dette)
- [Krav](#krav)
- [Installasjon](#installasjon)
- [Bruk](#bruk)
- [Feilsøking](#feilsøking)
- [FAQ](#faq)

---

## 🎯 Hva er dette?

Dette scriptet automatiserer prosessen med å kjøre QA-sjekk i Xbench på MQXLIFF-filer eksportert fra MemoQ. I stedet for å manuelt:
1. Eksportere fra MemoQ
2. Åpne Xbench
3. Opprette nytt prosjekt
4. Importere XLIFF-fil
5. Kjøre QA

...så gjør scriptet steg 2-4 automatisk når du eksporterer fra MemoQ!

### Fordeler
✅ Spar tid på repetitiv importering  
✅ Konsistent prosjektoppsett  
✅ Raskere QA-workflow  
✅ Ingen glemt QA-kjøring  

---

## 💻 Krav

- **Windows** (testet på Windows 10/11)
- **PowerShell 5.1** eller nyere (innebygd i Windows)
- **Xbench** (versjon 2.9 eller 3.0)
- **MemoQ** (desktop-versjon)

---

## 📦 Installasjon

### Trinn 1: Pakk ut filene

Pakk ut ZIP-filen til en mappe, for eksempel:
```
C:\Tools\XbenchAutoQA\
```

Du skal ha disse filene:
```
XbenchAutoQA/
├── Setup-XbenchAutoQA.ps1
├── XbenchAutoQA.ps1
└── README.md
```

### Trinn 2: Kjør setup

1. **Høyreklikk** på `Setup-XbenchAutoQA.ps1`
2. Velg **"Run with PowerShell"** / **"Kjør med PowerShell"**

   > ⚠️ **Viktig**: Hvis du får en feilmelding om "execution policy":
   > 1. Åpne PowerShell **som administrator**
   > 2. Kjør: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
   > 3. Svar **J** (Ja)
   > 4. Prøv setup igjen

3. **Følg setup-wizarden:**

   ```
   [1/3] Finner Xbench...
   ✓ Xbench funnet: C:\Program Files (x86)\ApSIC\Xbench\xbench.exe
   Er dette riktig? [J/n]:
   ```
   → Trykk **Enter** hvis stien er riktig

   ```
   [2/3] Velg overvåkningsmappe for XLIFF-filer
   Standard: C:\Translation\XbenchQA
   Trykk Enter for standard, eller skriv inn ønsket bane:
   ```
   → Trykk **Enter** for standard, eller skriv inn ønsket mappe

   ```
   [3/3] Tilleggsinnstillinger
   Vil du at QA skal starte automatisk etter prosjektoppretting? [j/N]:
   ```
   → **N** (nei) anbefales - du vil vanligvis se Xbench-prosjektet først

   ```
   Vil du aktivere logging? [J/n]:
   ```
   → **J** (ja) anbefales - hjelper med feilsøking

4. **Setup fullført!**
   ```
   ╔════════════════════════════════════════════════════════════╗
   ║                    Oppsett fullført!                       ║
   ╚════════════════════════════════════════════════════════════╝
   
   Konfigurasjon:
     • Overvåkningsmappe: C:\Translation\XbenchQA
     • Xbench: C:\Program Files (x86)\ApSIC\Xbench\xbench.exe
     • Auto-start QA: Nei
     • Logging: Aktivert
   ```

En `config.json` fil er nå opprettet med dine innstillinger.

---

## 🚀 Bruk

### Daglig workflow

#### 1. Start overvåking

Dobbeltklikk på **`XbenchAutoQA.ps1`** eller høyreklikk → "Run with PowerShell"

Du vil se:
```
╔════════════════════════════════════════════════════════════╗
║          Xbench Auto-QA Runner                             ║
║          Kjører og venter på MQXLIFF-filer                 ║
╚════════════════════════════════════════════════════════════╝

Konfigurasjon:
  • Overvåker: C:\Translation\XbenchQA
  • Xbench: C:\Program Files (x86)\ApSIC\Xbench\xbench.exe
  • Auto-start QA: Nei
  • Logging: Aktivert

Overvåker mappe for nye MQXLIFF/XLIFF-filer...
Trykk Ctrl+C for å avslutte
```

La dette vinduet stå åpent!

#### 2. Eksporter fra MemoQ

I MemoQ:
1. Åpne prosjektet ditt
2. Hvis flere filer: Opprett en **View** med alle filene du vil QA-sjekke
3. Gå til **Translation → Export to XLIFF**
4. **Viktig**: Velg riktig eksportformat:
   - **Bilingual MQXLIFF** (anbefalt)
   - Eller: **XLIFF 1.2 bilingual**
5. Lagre til overvåkningsmappen (f.eks. `C:\Translation\XbenchQA\`)
6. Gi filen et beskrivende navn (f.eks. `Prosjekt_ABC_no-NB.mqxliff`)

#### 3. Scriptet oppdager filen

I løpet av 1-2 sekunder vil scriptet oppdage filen:

```
╔════════════════════════════════════════════════════════════╗
  Ny fil oppdaget: Prosjekt_ABC_no-NB.mqxliff
╚════════════════════════════════════════════════════════════╝

Velg handling:
  [1] Rask QA (kun MQXLIFF, standardinnstillinger)
  [2] Avansert oppsett (legg til termlister/sjekklister)
  [ESC] Ignorer denne filen

Ditt valg:
```

#### 4. Velg handling

**Alternativ 1: Rask QA** (mest vanlig)
- Trykk **1**
- Xbench åpnes automatisk med filen
- Trykk **F5** i Xbench for å kjøre QA
- Rask og enkel!

**Alternativ 2: Avansert oppsett**
- Trykk **2**
- Xbench åpnes med prosjektet
- I Xbench: Legg til termlister, sjekklister, osv.
- Kjør QA når du er klar (F5)

**ESC: Ignorer**
- Trykk **ESC** hvis du eksporterte feil fil

#### 5. Kjør QA i Xbench

1. Xbench er nå åpent med din MQXLIFF
2. Trykk **F5** (eller velg **QA → Run Checklist**)
3. Se gjennom resultatene
4. Korriger feil om nødvendig

#### 6. Eksporter tilbake til MemoQ

Når du er ferdig i Xbench:
1. **Lagre** endringene i Xbench (Ctrl+S)
2. Gå tilbake til MemoQ
3. **Import → XLIFF**
4. Velg den oppdaterte MQXLIFF-filen
5. Ferdig! 🎉

---

## 🐛 Feilsøking

### "Execution policy" feil

**Problem:** 
```
File cannot be loaded because running scripts is disabled on this system.
```

**Løsning:**
1. Åpne PowerShell som administrator (høyreklikk → "Run as administrator")
2. Kjør: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Svar **J** (Ja)
4. Lukk og åpne PowerShell på nytt

### Scriptet oppdager ikke filen min

**Sjekkliste:**
- [ ] Er `XbenchAutoQA.ps1` kjørende? (Ser du "Overvåker mappe..." meldingen?)
- [ ] Eksporterte du til riktig mappe? (Sjekk `config.json` for overvåkningsmappe)
- [ ] Er filnavnet `.xlf`, `.xliff`, `.mqxliff`, eller `.mxliff`?
- [ ] Prøv å kopiere filen til mappen i stedet for å eksportere direkte

### Xbench åpner ikke

**Sjekkliste:**
- [ ] Er Xbench installert?
- [ ] Kjør setup på nytt: `.\Setup-XbenchAutoQA.ps1`
- [ ] Sjekk `config.json` - er `xbenchPath` riktig?

### Hvordan endre innstillinger?

**Metode 1: Kjør setup på nytt**
```powershell
.\Setup-XbenchAutoQA.ps1
```

**Metode 2: Rediger config.json manuelt**
Åpne `config.json` i Notepad:
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
Endre verdiene og lagre.

### Hvor finner jeg loggene?

Hvis logging er aktivert, finn loggfiler her:
```
XbenchAutoQA/logs/XbenchAutoQA_YYYYMMDD.log
```

Eksempel innhold:
```
[2025-10-30 14:23:15] [INFO] XbenchAutoQA startet - overvåker: C:\Translation\XbenchQA
[2025-10-30 14:25:42] [INFO] Ny fil oppdaget: C:\Translation\XbenchQA\test_no-NB.mqxliff
[2025-10-30 14:25:45] [INFO] Xbench-prosjekt opprettet: C:\Translation\XbenchQA\test_no-NB.xbp
[2025-10-30 14:25:45] [INFO] Starter Xbench (rask QA): C:\Translation\XbenchQA\test_no-NB.xbp
```

---

## ❓ FAQ

### Kan jeg bruke dette med flere prosjekter samtidig?

Ja! Scriptet behandler filer én om gangen, så du kan eksportere flere filer til overvåkningsmappen. Scriptet vil oppdage og behandle dem i rekkefølge.

### Fungerer dette med Xbench 2.9 og 3.0?

Ja, scriptet er testet med begge versjonene.

### Hva hvis jeg vil bruke andre mapper for forskjellige klienter?

Du kan:
1. Endre `watchFolder` i `config.json` til å peke på en felles mappe
2. Organisere med undermapper (f.eks. `C:\Translation\XbenchQA\KlientA\`)
3. Kopiere hele XbenchAutoQA-mappen og sette opp separate installasjoner

### Kan jeg legge til termlister automatisk?

Foreløpig ikke - men du kan:
1. Velge **Alternativ 2** (Avansert oppsett)
2. Legge til termlister manuelt i Xbench
3. Lagre Xbench-prosjektet som mal for gjenbruk

### Slettes filer automatisk?

Nei, scriptet sletter aldri filer. Alle eksporterte XLIFF-filer og opprettede Xbench-prosjektfiler blir liggende i overvåkningsmappen.

### Hvordan avinstallerer jeg?

Bare slett hele `XbenchAutoQA` mappen. Ingen systemfiler endres.

---

## 📝 Notater

### Filtypene som støttes

Scriptet overvåker for filer med disse endelsene:
- `.xlf` (XLIFF 1.2)
- `.xliff` (XLIFF 1.2/2.0)
- `.mqxliff` (MemoQ XLIFF)
- `.mxliff` (Phrase XLIFF)

### Xbench-prosjektfiler

For hver MQXLIFF opprettes en `.xbp` (Xbench Project) fil:
- Samme navn som XLIFF-filen
- Lagres i samme mappe
- Kan åpnes senere i Xbench for re-bruk
- Type: **MemoQ** (optimalisert for MQXLIFF-format)

### QA-innstillinger

Standard QA-sjekker som aktiveres:
- ✅ Stavekontroll
- ✅ Konsistenssjekk
- ✅ Nøkkeltermer
- ✅ Tag-validering
- ✅ Tall-sjekk

Du kan endre disse i Xbench-prosjektet.

---

## 🆘 Trenger du hjelp?

1. **Sjekk loggene** i `logs/` mappen
2. **Kjør setup på nytt** hvis noe er feil konfigurert
3. **Test manuelt** at Xbench kan åpne MQXLIFF-filen direkte
4. **Verifiser** at PowerShell execution policy er riktig satt

---

## 📄 Lisens

Dette scriptet er laget for intern bruk og deling blant oversettere.
Bruk og del fritt! 🎁

---

**Versjon:** 1.0  
**Sist oppdatert:** 30. oktober 2025  
**Kompatibilitet:** Windows 10/11, PowerShell 5.1+, Xbench 2.9/3.0
