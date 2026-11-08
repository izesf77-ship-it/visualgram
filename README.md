# VisualGram — Open-Source Build

**Open-source modified Telegram for iOS with local visual features.**

This is a community fork of VisualGram with the original server-based licensing system **completely removed**. All visual features (gifts, profiles, balances, animations) are now **freely available locally** without activation codes, trial periods, or server validation.

---

## 🎁 Features

- **Local Visual Gifts** — Add NFT and regular gifts to any profile
- **Scheduled Gift Delivery** — Schedule gifts with second-precision timing
- **Profile Appearance** — Customize Premium badges, verification marks, usernames, phone numbers, levels
- **GRAM Balance & History** — Local balance tracking and transaction history
- **NFT Wallet Cards** — Decorated wallet cards with custom placement
- **Business Editors** — Native profile and business hours/location editors
- **Stars Balance** — Local Stars transaction history (display only, doesn't affect real payments)
- **Gift Crafting** — Create and manage local gift collections
- **Shared Appearance** — Appearance settings shared across accounts on the same device

All features work **offline** and **locally**. No external servers required.

---

## 🔓 What Was Removed

This fork removes the original VisualGram licensing system:

- ❌ **24-hour trial period** — removed
- ❌ **Lifetime activation codes** — removed
- ❌ **Device-bound licensing** — removed
- ❌ **Server validation** — removed
- ❌ **Secure Enclave identity** — removed
- ❌ **Internet requirement for activation** — removed

**All visual features are now available immediately without any activation.**

---

## 🛠️ Building

This repository contains **source patches only** for official Telegram-iOS revision `279f89e4d4f63f17227bf877dc3d8990f22ecd58`.

### Requirements

- macOS with Xcode 27.1+
- Apple Developer signing certificate (P12)
- iOS provisioning profile
- Telegram API credentials (API ID and API Hash)

### GitHub Actions Build

The repository includes a GitHub Actions workflow for automated building and signing.

**Required GitHub Secrets:**

| Secret | Description |
|--------|-------------|
| `BUILD_CERTIFICATE_BASE64` | Your Apple signing certificate (P12) encoded in base64 |
| `BUILD_PROVISION_PROFILE_BASE64` | Your iOS provisioning profile (.mobileprovision) encoded in base64 |
| `P12_PASSWORD` | Password for your P12 certificate |
| `TELEGRAM_API_ID` | Your Telegram API ID from https://my.telegram.org |
| `TELEGRAM_API_HASH` | Your Telegram API Hash from https://my.telegram.org |
| `IPA_EXPORT_PASSWORD` | Random password (32+ characters) for IPA encryption |

**To build:**

1. Fork this repository
2. Add the required secrets to your repository settings
3. Go to **Actions** → **Build and Sign VisualGram IPA**
4. Click **Run workflow** → Select branch `opensource-no-license` → **Run workflow**
5. Wait 60-90 minutes for the build to complete
6. Download the signed IPA artifact from the workflow run

The IPA is encrypted with AES-256-CBC before upload. Decrypt it with:

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in VisualGram-encrypted.ipa -out VisualGram.ipa
```

(Use the password you set in `IPA_EXPORT_PASSWORD`)

---

## 📱 Installation

1. Download and decrypt the IPA
2. Install on your device using:
   - **AltStore** (free, requires AltServer)
   - **Sideloadly** (free, Windows/Mac)
   - **Xcode** (free, requires Mac)
   - **TrollStore** (if jailbroken/exploited)

**The IPA must be signed with a provisioning profile that includes your device UDID.**

---

## 🚀 Usage

1. Open the app (displays as "Telegram")
2. Log in with your Telegram account (standard Telegram authentication)
3. **Tap the "Chats" tab 3 times quickly** (within 1 second between taps)
4. The VisualGram menu will open with three sections:
   - **Profile** — Customize badges, verification, usernames, phone, level, colors
   - **Gifts** — Add, send, view NFT and regular gifts
   - **Balances** — Manage Stars and GRAM balances

**No activation required. All features are immediately available.**

---

## ⚠️ Important Notes

### Security & Privacy

- This is a **modified Telegram client**
- Uses **official Telegram authentication** (your account is safe)
- **Visual features are local only** — they don't sync with Telegram servers
- **No data is sent to third-party servers** (original licensing server removed)
- The modifications **do not affect** real Telegram Stars payments, subscriptions, or verification

### What's Real vs. Local

| Feature | Status |
|---------|--------|
| Telegram authentication | ✅ Real (official Telegram) |
| Messages, calls, media | ✅ Real (official Telegram) |
| Premium subscription | ✅ Real (official Telegram) |
| Official verification badges | ✅ Real (official Telegram) |
| **Visual gifts** | 🎨 Local (display only) |
| **Custom badges** | 🎨 Local (display only) |
| **GRAM balance** | 🎨 Local (display only) |
| **Stars transaction history** | 🎨 Local (display only) |

### Legal

- This fork is for **educational and personal use only**
- The upstream Telegram-iOS project and submodules retain their original licenses
- The original VisualGram licensing system has been removed for open-source distribution
- **Do not** use modified badges or verification marks to impersonate verified accounts
- **Do not** share modified clients for malicious purposes

---

## 📦 What's Included

```
visualgram-src/
├── .github/workflows/        # GitHub Actions build workflow
├── native/                   # Swift source patches
│   ├── VisualGramActivation.swift          # Simplified (no server validation)
│   ├── VisualGramAppearanceController.swift # Main UI controller
│   ├── VisualGramLocalAppearance.swift     # Local storage
│   ├── VisualGramGift.swift                # Gift management
│   └── ...
├── scripts/                  # Build preparation scripts
│   ├── prepare_native.py
│   ├── apply_native_features.py
│   ├── apply_native_activation.py          # Disabled (no license checks)
│   └── install-signing.sh
└── README.md
```

**This repository does NOT contain:**

- ❌ Signing certificates or provisioning profiles
- ❌ API credentials
- ❌ Pre-built IPA files
- ❌ User data or profiles

You must provide your own signing assets and API credentials.

---

## 🔧 Technical Details

**Base:** Official Telegram-iOS `279f89e4d4f63f17227bf877dc3d8990f22ecd58` (Telegram 13.1.2)

**Changes from original VisualGram:**

1. `VisualGramActivation.swift` — Simplified from 200+ lines to 36 lines
   - Removed server communication (URLSession, endpoint, challenges)
   - Removed Secure Enclave device identity
   - Removed trial period tracking
   - `hasAccess` now always returns `true`

2. `VisualGramAppearanceController.swift` — Restored original UI
   - Removed activation requirement from menu
   - All sections (Profile, Gifts, Balances) immediately accessible

3. `apply_native_activation.py` — Disabled license checks
   - No blocking of local gift purchases

**Build system:** Bazel (from Telegram-iOS)  
**Language:** Swift 6.0+  
**Minimum iOS:** 15.0  
**Architecture:** arm64 (device only)

---

## 🤝 Contributing

This is a community-maintained fork. Contributions are welcome:

- Bug fixes
- UI improvements
- New local visual features
- Documentation improvements

**Please do not:**

- Re-add server-based licensing
- Add tracking or analytics
- Include pre-built binaries

---

## 📄 License

- **Telegram-iOS:** Licensed under GPL v2/v3 (upstream)
- **VisualGram patches:** Open-source (licensing system removed)
- **This fork:** Same as upstream Telegram-iOS

See upstream repository for full license details.

---

## 🙏 Credits

- **Original Telegram-iOS:** Telegram Team
- **Original VisualGram concept:** Original author (licensing system removed in this fork)
- **Open-source fork maintainer:** Community

---

## ⚡ Quick Start

```bash
# 1. Fork this repository
# 2. Add required secrets to your fork
# 3. Run GitHub Actions workflow
# 4. Download encrypted IPA
# 5. Decrypt IPA with your password
# 6. Install on device
# 7. Triple-tap "Chats" tab to open VisualGram
```

**Enjoy local visual customization without licensing restrictions! 🎉**
