# 🎯 FINAL Domain & Email Setup
## Root Domain for Website, Mail Subdomain for Email

Last Updated: November 11, 2025

---

## ✅ **Your Final Configuration**

**Website (GitHub Pages)**:
- https://blackelkmountainmedicine.com (root domain)
- https://www.blackelkmountainmedicine.com (redirects to root)

**Email (iCloud+ Custom Domain)**:
- luke@mail.blackelkmountainmedicine.com
- support@mail.blackelkmountainmedicine.com
- info@mail.blackelkmountainmedicine.com

**No conflicts!** ✅

---

## 📋 **Step-by-Step Setup**

### **Step 1: Configure iCloud+ Email on Mail Subdomain**

You're already doing this! iCloud+ setup:

1. **On iPhone**: Settings → [Your Name] → iCloud → iCloud Mail → Custom Email Domain
2. **Add domain**: `mail.blackelkmountainmedicine.com`
3. **Create email addresses**:
   - luke@mail.blackelkmountainmedicine.com
   - support@mail.blackelkmountainmedicine.com
   - info@mail.blackelkmountainmedicine.com

4. **iCloud will provide DNS records** - write them down!

---

### **Step 2: Configure GitHub Pages for Root Domain**

1. Go to: https://github.com/mrlukealvarez/blackelkmountainmedicine.com
2. Click: **Settings** → **Pages**
3. **Custom domain** field:
   ```
   blackelkmountainmedicine.com
   ```
   (NO www, NO mail prefix - just the root)
4. Check: ☑ **Enforce HTTPS**
5. Click: **Save**

---

### **Step 3: Add ALL DNS Records**

Go to your domain registrar's DNS management page.

#### **A. GitHub Pages Records (Website on Root Domain)**

**Add 4 A Records:**

| Type | Name/Host | Value/Points To | TTL |
|------|-----------|-----------------|-----|
| A | @ | 185.199.108.153 | 3600 |
| A | @ | 185.199.109.153 | 3600 |
| A | @ | 185.199.110.153 | 3600 |
| A | @ | 185.199.111.153 | 3600 |

**Add 1 CNAME Record (www redirect):**

| Type | Name/Host | Value/Points To | TTL |
|------|-----------|-----------------|-----|
| CNAME | www | mrlukealvarez.github.io | 3600 |

---

#### **B. iCloud+ Email Records (Email on Mail Subdomain)**

**Add whatever records iCloud provides!** They'll look something like:

**MX Records (Mail Exchange):**
| Type | Name/Host | Value/Points To | Priority | TTL |
|------|-----------|-----------------|----------|-----|
| MX | mail | mx01.mail.icloud.com | 10 | 3600 |
| MX | mail | mx02.mail.icloud.com | 20 | 3600 |

**TXT Records (Verification):**
| Type | Name/Host | Value | TTL |
|------|-----------|-------|-----|
| TXT | mail | (verification code from iCloud) | 3600 |

**CNAME Records (if any):**
| Type | Name/Host | Value | TTL |
|------|-----------|-------|-----|
| CNAME | mail | (if iCloud provides one) | 3600 |

⚠️ **Use the EXACT records iCloud gives you!** These are examples only.

---

### **Step 4: Wait for DNS Propagation**

- **DNS changes take 1-24 hours** to propagate
- Email records usually propagate faster (1-4 hours)
- Website records may take longer

**Check propagation:**
- Website: https://dnschecker.org → Enter: blackelkmountainmedicine.com
- Email: Send test email to support@mail.blackelkmountainmedicine.com

---

### **Step 5: Verify Everything Works**

#### **Test Website:**
1. Visit: https://blackelkmountainmedicine.com
2. Should show your GitHub Pages site ✅
3. HTTPS should work (green padlock) ✅

4. Visit: https://www.blackelkmountainmedicine.com
5. Should redirect to blackelkmountainmedicine.com ✅

#### **Test Email:**
1. Send email TO: support@mail.blackelkmountainmedicine.com
2. Should arrive in your iCloud inbox ✅

3. Send email FROM: support@mail.blackelkmountainmedicine.com
4. Recipient should receive it ✅

---

## 📱 **App Code Updated**

I've updated your app to use the new URLs:

**SettingsView.swift:**
- ✅ Website: https://blackelkmountainmedicine.com
- ✅ Email: support@mail.blackelkmountainmedicine.com

**AboutView.swift:**
- ✅ Website: https://blackelkmountainmedicine.com
- ✅ Email: support@mail.blackelkmountainmedicine.com

---

## 📧 **Important Email Notes**

### **Your Email Addresses Changed!**

**Old (no longer works):**
- ❌ support@blackelkmountainmedicine.com
- ❌ luke@blackelkmountainmedicine.com

**New (active):**
- ✅ support@mail.blackelkmountainmedicine.com
- ✅ luke@mail.blackelkmountainmedicine.com

### **Update These:**
- [ ] Email signature
- [ ] Business cards
- [ ] Social media profiles
- [ ] Any marketing materials
- [ ] Contact forms on other sites

---

## 🎯 **DNS Records Summary**

Here's what your DNS should look like when complete:

```
Root Domain (@):
├─ A → 185.199.108.153 (GitHub)
├─ A → 185.199.109.153 (GitHub)
├─ A → 185.199.110.153 (GitHub)
└─ A → 185.199.111.153 (GitHub)

WWW Subdomain:
└─ CNAME → mrlukealvarez.github.io (GitHub)

Mail Subdomain:
├─ MX → mx01.mail.icloud.com (Apple)
├─ MX → mx02.mail.icloud.com (Apple)
├─ TXT → (Apple verification)
└─ (Any other records Apple provides)
```

---

## ✅ **Verification Checklist**

### **iCloud+ Email Setup:**
- [ ] Domain added: mail.blackelkmountainmedicine.com
- [ ] Email addresses created
- [ ] DNS records provided by iCloud (written down)
- [ ] DNS records added to registrar
- [ ] Email verification complete

### **GitHub Pages Setup:**
- [ ] Custom domain set: blackelkmountainmedicine.com
- [ ] HTTPS enforced
- [ ] A records added (4 GitHub IPs)
- [ ] CNAME record added (www → GitHub)

### **DNS Propagation:**
- [ ] Wait 1-24 hours
- [ ] Check dnschecker.org for website
- [ ] Send test email

### **App Updates:**
- [x] SettingsView.swift updated
- [x] AboutView.swift updated
- [ ] Test app with new URLs

### **Final Verification:**
- [ ] Website loads: https://blackelkmountainmedicine.com
- [ ] WWW redirects: https://www.blackelkmountainmedicine.com
- [ ] Email receives: support@mail.blackelkmountainmedicine.com
- [ ] Email sends: support@mail.blackelkmountainmedicine.com
- [ ] HTTPS working (green padlock)

---

## 🚀 **Timeline**

| Time | Action |
|------|--------|
| **Now** | Configure iCloud+ with mail subdomain |
| **Now + 5 mins** | Add DNS records (both website and email) |
| **Now + 10 mins** | Configure GitHub Pages |
| **Wait 1-4 hours** | DNS propagation (email usually first) |
| **Wait 4-24 hours** | Full DNS propagation (website) |
| **After propagation** | Test everything |

---

## 💡 **Pro Tips**

1. **Add DNS records BEFORE removing old iCloud+ domain** (if possible)
2. **Keep checking email** during transition to catch any issues
3. **Test website on phone data** (not WiFi) to see real DNS
4. **Be patient** - DNS propagation takes time!

---

## 🔧 **Troubleshooting**

### **"Website not loading"**
- Check A records are correct (4 GitHub IPs)
- Wait longer for DNS propagation
- Try different browser/device
- Check dnschecker.org

### **"Email not working"**
- Verify iCloud+ setup is complete
- Check MX records match what iCloud provided
- Send from different email provider to test
- Check spam folder

### **"HTTPS certificate error"**
- Wait 24 hours for GitHub to provision certificate
- Make sure "Enforce HTTPS" is checked in GitHub Pages
- Try in incognito/private mode

---

## 🎉 **You're All Set!**

Once DNS propagates:
- ✅ Website: blackelkmountainmedicine.com (clean root domain!)
- ✅ Email: support@mail.blackelkmountainmedicine.com (working on mail subdomain)
- ✅ App: Updated with correct URLs
- ✅ No conflicts!

**This is the proper way to set it up!** 💪

---

## 📞 **Need Help?**

If you run into issues:
1. Check iCloud+ setup is complete
2. Verify ALL DNS records are added correctly
3. Wait full 24 hours for propagation
4. Test from different devices/networks

Good luck! 🚀
