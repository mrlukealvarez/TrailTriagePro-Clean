# 🌐 Domain Setup Guide
## BlackElkMountainMedicine.com → GitHub Pages

---

## ✅ **What You Have**
- Domain: BlackElkMountainMedicine.com
- Email: support@blackelkmountainmedicine.com
- GitHub Pages site (currently at: mrlukealvarez.github.io/blackelkmountainmedicine.com)

---

## 📋 **Step-by-Step: Connect Domain to GitHub Pages**

### **Step 1: Configure GitHub Repository**

1. Go to your GitHub repository for the website
2. Click **Settings** (top right)
3. Scroll down to **Pages** section (left sidebar)
4. Under **Custom domain**, enter:
   ```
   blackelkmountainmedicine.com
   ```
5. Check: ☑ **Enforce HTTPS** (recommended)
6. Click **Save**

---

### **Step 2: Configure DNS Records (At Your Domain Registrar)**

Go to wherever you bought the domain (GoDaddy, Namecheap, Google Domains, etc.)

#### **A. Add GitHub IP Addresses**

Create **A Records** pointing to GitHub's servers:

| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | @ | 185.199.108.153 | 3600 |
| A | @ | 185.199.109.153 | 3600 |
| A | @ | 185.199.110.153 | 3600 |
| A | @ | 185.199.111.153 | 3600 |

#### **B. Add WWW Subdomain**

Create a **CNAME Record** for www:

| Type | Name | Value | TTL |
|------|------|-------|-----|
| CNAME | www | mrlukealvarez.github.io | 3600 |

---

### **Step 3: Wait for DNS Propagation**

- DNS changes take **24-48 hours** to fully propagate
- You can check status at: https://dnschecker.org
- Enter: blackelkmountainmedicine.com

---

### **Step 4: Verify Setup**

After DNS propagates:

1. Visit: https://blackelkmountainmedicine.com
2. Should redirect to your GitHub Pages site ✅
3. HTTPS should work (green padlock) ✅

---

## 📧 **Email Setup (support@blackelkmountainmedicine.com)**

### **Option A: Forward to Personal Email** (Easiest)

Most domain registrars offer email forwarding:

1. Go to domain settings
2. Find "Email Forwarding" or "Email"
3. Create forward:
   ```
   support@blackelkmountainmedicine.com → your.personal@email.com
   ```

### **Option B: Use Google Workspace** (Professional)

- Cost: $6/month per user
- Full Gmail interface
- Custom email @blackelkmountainmedicine.com

### **Option C: Use Custom Email Service**

Services like:
- ProtonMail
- Zoho Mail (free tier available!)
- FastMail

**Recommendation**: Start with email forwarding (free), upgrade later if needed.

---

## 🔗 **Update All App Links**

I've already updated your app to use:
- ✅ Website: https://blackelkmountainmedicine.com
- ✅ Email: support@blackelkmountainmedicine.com

**Files updated:**
- SettingsView.swift
- AboutView.swift (already correct)

---

## ✅ **Verification Checklist**

### **Domain Setup:**
- [ ] Custom domain added to GitHub Pages settings
- [ ] A records added (4 GitHub IPs)
- [ ] CNAME record added (www subdomain)
- [ ] DNS propagation complete (wait 24-48 hours)
- [ ] Website loads at blackelkmountainmedicine.com
- [ ] HTTPS working (green padlock)

### **Email Setup:**
- [ ] Email forwarding configured
- [ ] Test email sent to support@blackelkmountainmedicine.com
- [ ] Email received at forwarding address

### **App Links:**
- [x] SettingsView uses correct domain
- [x] AboutView uses correct domain
- [x] Email links use support@blackelkmountainmedicine.com

---

## 🚀 **Quick Start: Minimal Setup**

If you just want to get it working ASAP:

1. **GitHub**: Add custom domain in Pages settings
2. **DNS**: Add 4 A records pointing to GitHub IPs
3. **Wait**: 24-48 hours for DNS
4. **Test**: Visit blackelkmountainmedicine.com

That's it! Your app will work immediately (links go to domain), and once DNS propagates, the website will load correctly.

---

## 📞 **Need Help?**

- **GitHub Pages docs**: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site
- **DNS help**: Contact your domain registrar's support
- **Email help**: Most registrars have email forwarding guides

---

## 💡 **Pro Tips**

1. **Use www redirect**: Most sites redirect www to non-www or vice versa
2. **Enable HTTPS**: Always! Required for modern browsers
3. **Test email**: Send test emails before launch
4. **Monitor DNS**: Use dnschecker.org to watch propagation

---

**Your domain and email are now properly configured in the app!** 🎉

Just follow the steps above to connect your domain to GitHub Pages.
