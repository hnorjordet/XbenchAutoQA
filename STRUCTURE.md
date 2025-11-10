# XbenchAutoQA - Filstruktur og oversikt

## 📁 Pakkeinnhold

```
XbenchAutoQA/
│
├── 🚀 Setup-XbenchAutoQA.ps1       # Setup-wizard (kjør først!)
├── ⚙️  XbenchAutoQA.ps1              # Hovedscript (kjør daglig)
│
├── 📖 INSTALLASJON.md               # → Start her! (for mottagere)
├── 📖 QUICKSTART.md                 # → Rask guide (2 min)
├── 📖 README.md                     # Fullstendig dokumentasjon (norsk)
├── 📖 README_EN.md                  # Full documentation (English)
│
├── 📋 CHANGELOG.md                  # Versjonshistorikk
├── 📋 LICENSE                       # MIT License
├── 📋 config.example.json           # Eksempel på konfigurasjon
│
└── [Genereres automatisk:]
    ├── config.json                  # Din konfigurasjon (lages av setup)
    └── logs/                        # Loggfiler (hvis aktivert)
        └── XbenchAutoQA_YYYYMMDD.log

```

---

## 📄 Dokumentasjonsguide

### For nye brukere:
1. **INSTALLASJON.md** - Les denne først!
2. **QUICKSTART.md** - Kom raskt i gang
3. **README.md** - Les når du trenger mer info

### For erfarne brukere:
- **README.md** - Fullstendig referanse
- **CHANGELOG.md** - Se hva som er nytt

### For engelsktalende:
- **README_EN.md** - Complete English documentation

---

## 🔧 Tekniske filer

### Setup-XbenchAutoQA.ps1
**Hva den gjør:**
- Auto-detekterer Xbench-installasjon
- Oppretter konfigurasjonsfil
- Verifiserer at alt fungerer
- Oppretter nødvendige mapper

**Når du bruker den:**
- Ved første gangs installasjon
- Når du vil endre innstillinger
- Hvis noe sluttet å fungere

### XbenchAutoQA.ps1
**Hva den gjør:**
- Overvåker mappe for nye XLIFF-filer
- Oppretter Xbench-prosjektfiler automatisk
- Starter Xbench med riktige innstillinger
- Logger aktivitet (hvis aktivert)

**Når du bruker den:**
- Hver gang du skal jobbe med QA
- La den kjøre i bakgrunnen hele dagen

### config.json
**Hva den inneholder:**
```json
{
  "watchFolder": "Mappe som overvåkes",
  "xbenchPath": "Sti til xbench.exe",
  "autoStartQA": "Om QA skal starte automatisk",
  "logEnabled": "Om logging er aktivert",
  "version": "Scriptversjon",
  "createdDate": "Når konfigurasjonen ble laget"
}
```

**Hvordan endre:**
- Kjør `Setup-XbenchAutoQA.ps1` på nytt
- Eller rediger filen manuelt i Notepad

---

## 📊 Workflow-oversikt

```
┌─────────────────────┐
│   Start scriptet    │
│  XbenchAutoQA.ps1   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Overvåker mappe for │
│   nye XLIFF-filer   │
└──────────┬──────────┘
           │
           ▼
    [Fil oppdaget]
           │
           ▼
┌─────────────────────┐
│  Velg handling:     │
│  [1] Rask QA        │
│  [2] Avansert       │
│  [ESC] Ignorer      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Opprett Xbench-     │
│ prosjektfil (.xbp)  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Start Xbench      │
│  med prosjektet     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Kjør QA i Xbench    │
│      (F5)           │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Importer tilbake    │
│   til MemoQ         │
└─────────────────────┘
```

---

## 🗂️ Anbefalt mappestruktur for prosjekter

```
C:\Translation\
├── XbenchQA\                    # Overvåkningsmappe
│   ├── Prosjekt_ABC_no-NB.mqxliff
│   ├── Prosjekt_ABC_no-NB.xbp   # Auto-generert
│   ├── Prosjekt_DEF_en-US.mqxliff
│   └── Prosjekt_DEF_en-US.xbp   # Auto-generert
│
└── [Andre mapper...]
```

**Tips:**
- Hold overvåkningsmappen ren
- Bruk beskrivende filnavn
- Arkiver gamle filer jevnlig

---

## 🔄 Versjonering

Følger [Semantic Versioning](https://semver.org/):
- **v1.0.0** = Første stabile versjon
- **v1.1.0** = Ny funksjonalitet
- **v1.0.1** = Feilrettinger

Se **CHANGELOG.md** for fullstendig historikk.

---

## 🛠️ Tilpasning

### Endre overvåkningsmappe
**Metode 1:** Kjør setup på nytt  
**Metode 2:** Rediger `config.json` → `watchFolder`

### Endre Xbench-sti
**Metode 1:** Kjør setup på nytt  
**Metode 2:** Rediger `config.json` → `xbenchPath`

### Aktivere/deaktivere logging
Rediger `config.json` → `logEnabled` → `true` eller `false`

### Auto-start QA
Rediger `config.json` → `autoStartQA` → `true` eller `false`

---

## 🔐 Sikkerhet og personvern

- Ingen data sendes ut av systemet ditt
- Ingen nettverkstilkobling brukes
- Alle filer forblir lokalt på din maskin
- Loggene inneholder bare filstier og tidsstempler
- Open source - du kan inspisere koden selv

---

## 📞 Support

For spørsmål eller problemer:
1. Les **README.md** (Feilsøking-seksjonen)
2. Sjekk loggfilene i `logs/`
3. Kontakt personen som ga deg denne pakken

---

**Versjon:** 1.0  
**Sist oppdatert:** 30. oktober 2025
