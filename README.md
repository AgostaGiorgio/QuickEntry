# QuickEntry

QuickEntry is a simple **Android-only** Flutter app designed to fetch bank transaction SMS, let the user tweak details, and send them to [Coda](https://coda.io) via webhooks.  
No charts, no statistics — just **fetch → edit → send**.

---

## 📱 Features

- **Fetch SMS** from the device  
- Configurable:
  - Chat/thread to look into
  - Regex rules to extract fields from the message body
- Automatically map extracted data into a transaction object:
  - **Timestamp** (`gg/mm/yyyy, hh:mm`)
  - **CardAccount** (nullable, configurable list of card endings)
  - **Amount**
  - **Description**
  - **Primary Category** (configurable list)
  - **Secondary Category** (nullable, list mapped to primary categories)
  - **Exclude** (boolean)
  - **Reimbursed** (real number)
- Edit or complete any field before sending
- Apply regex-based category assignment automatically during fetch
- Define default regex rules in config

---

## 🔄 Workflow

1. **Fetch SMS** from the specified chat/thread
2. **Extract data** using regex patterns from config
3. **Auto-assign categories** where possible
4. **Review & edit** transaction details
5. **Send to Coda** via webhook (requires URL & token in config)  
   - Option to **ignore** transactions instead of sending

---

## 💾 Local Storage

Configuration is stored locally and includes:
- Chat/thread ID to fetch SMS from
- Regex patterns for:
- Extracting timestamp, amount, description, etc.
- Auto-assigning categories
- Card account endings list
- Categories & subcategories
- Coda webhook URL & token

---

## ⚠️ Limitations

- Works **only on Android** (iOS SMS fetching is restricted)
- Requires SMS read permissions

---

## 🚀 Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/quick_entry.git
cd quick_entry
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run on Android
```bash
flutter run
```