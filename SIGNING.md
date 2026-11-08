# How to Configure Your Own Signing Certificates

This guide explains how to prepare your own Apple signing assets for building VisualGram.

---

## Prerequisites

1. **Apple Developer Account** (free or paid)
   - Free: Limited to 3 devices, 7-day certificate expiry, requires weekly re-signing
   - Paid ($99/year): Up to 100 devices, 1-year certificate, stable

2. **Your iPhone/iPad UDID**
   - Connect device to Mac
   - Open Finder → Select device → Click under device name to reveal UDID
   - Copy UDID (example: `00008130-001E253E1AD2001C`)

---

## Step 1: Create Provisioning Profile

### Option A: Xcode (Automatic)

1. Open Xcode
2. Preferences → Accounts → Add your Apple ID
3. Manage Certificates → + → iOS Development (or iOS Distribution)
4. Create new iOS project
5. Signing & Capabilities → Team: Select your team
6. Bundle Identifier: Enter unique ID (e.g., `com.yourname.visualgram`)
7. Xcode will automatically create provisioning profile

### Option B: Apple Developer Portal (Manual)

1. Go to https://developer.apple.com/account
2. **Certificates**:
   - Certificates → + → iOS App Development (or iOS Distribution)
   - Follow instructions to create Certificate Signing Request (CSR) in Keychain Access
   - Upload CSR → Download certificate (.cer)
   - Double-click to install in Keychain

3. **App ID**:
   - Identifiers → + → App IDs
   - Description: `VisualGram`
   - Bundle ID: `com.yourname.visualgram` (explicit, not wildcard)
   - Capabilities: Enable as needed
   - Register

4. **Devices**:
   - Devices → + → Register Device
   - Name: `My iPhone`
   - UDID: Paste your device UDID
   - Register

5. **Provisioning Profile**:
   - Profiles → + → iOS App Development (or Ad Hoc / App Store)
   - App ID: Select your `VisualGram` app
   - Certificates: Select your certificate
   - Devices: Select your device (for Development/Ad Hoc)
   - Profile Name: `VisualGram Dev`
   - Generate → Download (.mobileprovision)

---

## Step 2: Export P12 Certificate

1. Open **Keychain Access** on Mac
2. Find your certificate (e.g., "iPhone Developer: Your Name")
3. Expand certificate → Should see private key underneath
4. Select **both** certificate and private key (Cmd+Click)
5. Right-click → Export 2 items...
6. Save as: `signing.p12`
7. **Set password:** Use a strong password (you'll need this for GitHub Secrets)
8. Enter your Mac login password to allow export

**Important:** Keep this P12 file private. Never commit it to Git.

---

## Step 3: Encode for GitHub Secrets

### On Mac/Linux:

```bash
# Encode P12 certificate
base64 -i signing.p12 -o p12_base64.txt

# Encode provisioning profile
base64 -i VisualGram_Dev.mobileprovision -o profile_base64.txt
```

### On Windows PowerShell:

```powershell
# Encode P12 certificate
[Convert]::ToBase64String([IO.File]::ReadAllBytes("signing.p12")) | Out-File -Encoding ASCII p12_base64.txt

# Encode provisioning profile
[Convert]::ToBase64String([IO.File]::ReadAllBytes("VisualGram_Dev.mobileprovision")) | Out-File -Encoding ASCII profile_base64.txt
```

---

## Step 4: Add GitHub Secrets

1. Go to your **forked repository** on GitHub
2. Settings → Secrets and variables → Actions
3. Click **New repository secret** for each:

| Secret Name | Value |
|-------------|-------|
| `BUILD_CERTIFICATE_BASE64` | Content of `p12_base64.txt` (entire file, one line) |
| `BUILD_PROVISION_PROFILE_BASE64` | Content of `profile_base64.txt` (entire file, one line) |
| `P12_PASSWORD` | Password you set when exporting P12 |
| `TELEGRAM_API_ID` | Get from https://my.telegram.org/apps |
| `TELEGRAM_API_HASH` | Get from https://my.telegram.org/apps |
| `IPA_EXPORT_PASSWORD` | Generate random 32+ character password |

**Security Notes:**
- Never share these secrets
- GitHub Secrets are encrypted and only accessible during workflow runs
- Delete local `p12_base64.txt` and `profile_base64.txt` after adding to GitHub

---

## Step 5: Update Bundle ID

If you used a different Bundle ID than the default, update the workflow:

1. Edit `.github/workflows/visualgram-build-sign.yml`
2. Find the `prepare_native.py` step
3. The bundle ID is automatically extracted from your provisioning profile
4. No manual changes needed (it reads from `${{ steps.signing.outputs.bundle }}`)

---

## Step 6: Build

1. Go to **Actions** tab in your repository
2. Select **Build and Sign VisualGram IPA**
3. Click **Run workflow**
4. Select branch: `opensource-no-license`
5. Configuration: `release_arm64`
6. Click **Run workflow**

Wait 60-90 minutes for completion.

---

## Troubleshooting

### "Provisioning profile doesn't include signing certificate"

- Make sure the certificate in your P12 matches the one in the provisioning profile
- Regenerate provisioning profile and include your certificate

### "No devices match the profile"

- Make sure your device UDID is included in the provisioning profile
- For Ad Hoc/Development profiles, you must explicitly add devices

### "Signing certificate expired"

- Free accounts: Certificates expire after 7 days
- Solution: Re-create certificate and provisioning profile weekly, or upgrade to paid account

### "Code signing failed"

- Check P12 password is correct in GitHub Secrets
- Verify base64 encoding is correct (no extra newlines/spaces)
- Ensure P12 contains both certificate AND private key

---

## Free vs. Paid Apple Developer Account

| Feature | Free | Paid ($99/year) |
|---------|------|-----------------|
| **Devices** | 3 max | 100 max |
| **Certificate validity** | 7 days | 1 year |
| **Re-signing frequency** | Weekly | Annually |
| **App Store distribution** | ❌ No | ✅ Yes |
| **Enterprise distribution** | ❌ No | ❌ No (separate $299/year) |
| **TestFlight** | ❌ No | ✅ Yes |

For personal use, a **free account is sufficient** but requires weekly maintenance.

---

## Security Best Practices

1. **Never commit** `.p12`, `.mobileprovision`, or private keys to Git
2. **Use strong passwords** for P12 export
3. **Rotate secrets** if accidentally exposed
4. **Delete local copies** of base64-encoded secrets after adding to GitHub
5. **Use repository-level secrets**, not organization-level (for better isolation)
6. **Review Actions logs** — they should never print secret values

---

## Get Telegram API Credentials

1. Go to https://my.telegram.org
2. Log in with your phone number
3. API development tools → Create new application
4. App title: `VisualGram`
5. Short name: `visualgram`
6. Platform: iOS
7. Create application
8. Copy **App api_id** (e.g., `12345678`)
9. Copy **App api_hash** (e.g., `0123456789abcdef0123456789abcdef`)

Add these to GitHub Secrets as `TELEGRAM_API_ID` and `TELEGRAM_API_HASH`.

---

## Additional Resources

- [Apple Developer Portal](https://developer.apple.com/account)
- [Keychain Access Guide](https://support.apple.com/guide/keychain-access)
- [Xcode Signing Guide](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

**Remember:** Your signing assets are **personal and private**. Never share P12 files, passwords, or provisioning profiles publicly.
