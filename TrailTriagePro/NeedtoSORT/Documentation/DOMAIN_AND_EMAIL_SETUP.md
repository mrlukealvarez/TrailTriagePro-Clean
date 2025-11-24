# ✅ Your Domain & Email Setup - Quick Reference

## 🌐 **Your Domain**
```
blackelkmountainmedicine.com
```
**Status:** ✅ Purchased from Namecheap

---

## 📧 **Email Addresses to Create**

### **Required (Must Have):**
```
support@blackelkmountainmedicine.com  ← REQUIRED for App Store
```

### **Recommended (Should Have):**
```
luke@blackelkmountainmedicine.com     ← Your primary email
info@blackelkmountainmedicine.com     ← General inquiries
```

### **Optional (Nice to Have):**
```
press@blackelkmountainmedicine.com    ← Media inquiries
feedback@blackelkmountainmedicine.com ← User feedback
```

---

## ✅ **What's Already Updated in Your App**

### **AboutView.swift:**
- ✅ Website URL: `https://blackelkmountainmedicine.com`
- ✅ Support email: `support@blackelkmountainmedicine.com`
- ✅ Safe optional binding (no force unwraps)

### **Documentation:**
- ✅ All guides reference correct domain
- ✅ Privacy policy template ready
- ✅ App Store metadata pre-written

---

## 🚀 **Your Immediate Next Steps**

### **Step 1: Set Up iCloud+ Custom Domain** (TODAY)

1. **Go to:** [iCloud.com](https://www.icloud.com) → Settings → Custom Email Domain
2. **Click:** "Add Custom Domain"
3. **Enter:** `blackelkmountainmedicine.com`
4. **Follow Apple's DNS instructions** - You'll need to add:
   - MX records (for mail routing)
   - TXT records (for domain verification)

5. **Update Namecheap DNS:**
   - Log in to Namecheap
   - Go to Domain List → Manage → Advanced DNS
   - Add the records Apple provides
   - **Example records from Apple:**
     ```
     Type: MX
     Host: @
     Value: mx01.mail.icloud.com
     Priority: 10
     
     Type: MX  
     Host: @
     Value: mx02.mail.icloud.com
     Priority: 20
     
     Type: TXT
     Host: @
     Value: [Apple will provide this verification code]
     ```

6. **Wait for verification:** 
   - Can take 24-48 hours
   - Apple will email you when ready
   - Check status in iCloud Settings

7. **Create email addresses:**
   - Once verified, create:
     - `support@blackelkmountainmedicine.com`
     - `luke@blackelkmountainmedicine.com`
     - `info@blackelkmountainmedicine.com`

---

### **Step 2: Build Your Website Pages** (THIS WEEK)

You need these pages live before App Store submission:

**Required Pages:**

1. **Privacy Policy**
   - URL: `https://blackelkmountainmedicine.com/privacy`
   - Content: Use `PRIVACY_POLICY_TEMPLATE.md` I created
   - **Status:** 🔴 NOT YET CREATED

2. **Support Page**
   - URL: `https://blackelkmountainmedicine.com/support`
   - Content: Basic contact info and FAQ
   - **Status:** 🔴 NOT YET CREATED

**Recommended Pages:**

3. **Home Page**
   - URL: `https://blackelkmountainmedicine.com`
   - Content: App overview, features, download link
   - **Status:** 🔴 NOT YET CREATED

4. **Terms of Service**
   - URL: `https://blackelkmountainmedicine.com/terms`
   - Content: Basic terms (optional for v1.0)
   - **Status:** 🟡 OPTIONAL

---

## 🌐 **Simple Website Option**

If you need to get pages up quickly, here's the easiest approach:

### **Option 1: GitHub Pages** (FREE, 10 minutes)
Since you already have a GitHub account:
1. Create repo: `blackelkmountainmedicine-website`
2. Add markdown files:
   - `index.md` (home)
   - `privacy.md` (privacy policy - use my template)
   - `support.md` (support page)
3. Enable GitHub Pages
4. Point your Namecheap domain to GitHub Pages
5. Done!

### **Option 2: Carrd.co** (FREE/$19/year, 30 minutes)
- Super simple drag-and-drop
- Custom domain support
- Mobile-responsive
- Perfect for a simple landing page

### **Option 3: WordPress.com** ($4/month, 1 hour)
- More features if you want a blog
- Easy content management
- Custom domain included

---

## 📝 **Quick Support Page Template**

Here's a minimal support page you can use:

```markdown
# TrailTriage Support

**Need help with TrailTriage?**

## Contact Us
- **Email:** support@blackelkmountainmedicine.com
- **Response Time:** We typically respond within 48 hours

## Frequently Asked Questions

### How do I create a SOAP note?
Tap the "New Note" tab and fill in the patient information. The app will guide you through the SOAP format.

### How do I export a note as PDF?
Open any note and tap the share button in the top right corner. Select "Export as PDF."

### Does the app work offline?
Yes! All content is available offline once downloaded. No internet connection required.

### How do I delete a note?
In the "My Notes" tab, swipe left on any note and tap "Delete."

### Where is my data stored?
All data is stored locally on your device. We do not collect or transmit any data to external servers.

### How do I update my responder information?
Go to Settings → Responder Information to update your name, agency, and certifications.

## Report a Bug
Found a bug? Email us at support@blackelkmountainmedicine.com with:
- Device model (e.g., iPhone 15 Pro)
- iOS version
- Description of the issue
- Steps to reproduce

## Feature Requests
We'd love to hear your ideas! Email feedback@blackelkmountainmedicine.com

---

**TrailTriage**  
Black Elk Mountain Medicine  
Black Hills, South Dakota  

© 2025 Black Elk Mountain Medicine. All rights reserved.
```

---

## ✅ **Current Status Summary**

### **✅ DONE (No Action Needed):**
- ✅ Domain purchased: blackelkmountainmedicine.com
- ✅ AboutView.swift updated with correct URLs
- ✅ Safe URL handling (no crashes)
- ✅ Documentation uses correct domain
- ✅ Privacy policy template created
- ✅ Support page template created (above)

### **🔴 TODO (Must Do Before App Store):**
- 🔴 Set up iCloud+ custom domain
- 🔴 Create support@blackelkmountainmedicine.com
- 🔴 Publish privacy policy page online
- 🔴 Publish support page online
- 🔴 Test all email addresses work
- 🔴 Test all website links work

### **🟡 TODO (Should Do Soon):**
- 🟡 Create home page for domain
- 🟡 Take App Store screenshots
- 🟡 Fill out App Store Connect
- 🟡 Submit app for review

---

## ⏱️ **Realistic Timeline**

**Day 1 (Today):**
- Set up iCloud+ custom domain (30 mins setup, 24-48 hours DNS propagation)

**Day 2-3 (Waiting for DNS):**
- Build simple website pages
- Write support page content
- Copy privacy policy template to website

**Day 3-4 (After DNS Verified):**
- Create email addresses
- Test sending/receiving emails
- Verify all links work

**Day 4-5 (Website Live):**
- Take screenshots on real iPhone
- Fill out App Store Connect
- Archive and upload from Xcode

**Day 5-7 (Submitted!):**
- Submit for Apple review
- Wait 1-3 days typically
- Respond to any questions from Apple

**Week 2:**
- App goes live! 🎉

---

## 💡 **Pro Tips**

1. **DNS propagation takes time** - Start the iCloud+ domain setup TODAY so DNS changes propagate while you work on other stuff

2. **Keep pages simple** - Apple just needs to see you have a privacy policy and support contact. Doesn't need to be fancy.

3. **Test emails immediately** - As soon as emails are created, send test emails to/from each address to verify they work

4. **Use templates** - I've given you templates for everything. Don't reinvent the wheel!

5. **Screenshots on real device** - Simulator screenshots look fake. Apple prefers real device screenshots.

---

## 📧 **Email Forwarding Option**

If you want emails to go to your existing personal email:

1. In iCloud Settings, set up forwarding:
   - `support@blackelkmountainmedicine.com` → forwards to your personal email
   - Still shows as "from support@" when you reply
   - Easiest way to manage during launch

2. Later, you can use a proper email client if volume increases

---

## 🎯 **Your Checklist for RIGHT NOW**

**Open these tabs:**
1. ✅ [iCloud.com Settings](https://www.icloud.com) - To set up custom domain
2. ✅ [Namecheap Domain Management](https://www.namecheap.com) - To update DNS
3. ✅ Your website hosting (GitHub Pages/Carrd/etc) - To publish privacy policy

**Do this today:**
1. Start iCloud+ custom domain setup
2. Add DNS records to Namecheap
3. Wait for verification (happens in background)

**Do tomorrow while DNS propagates:**
1. Build simple website pages
2. Publish privacy policy (use my template)
3. Publish support page (use template above)

**Do this week once emails work:**
1. Test all email addresses
2. Take screenshots
3. Fill out App Store Connect
4. Submit!

---

## ✅ **Summary**

**Your domain is correct everywhere!**
- ✅ Code: `blackelkmountainmedicine.com`
- ✅ Docs: `blackelkmountainmedicine.com`
- ✅ Emails: `@blackelkmountainmedicine.com`

**What you need to do:**
1. 📧 Set up iCloud+ custom domain (START TODAY)
2. 🌐 Create privacy policy page (USE MY TEMPLATE)
3. 🌐 Create support page (USE TEMPLATE ABOVE)
4. ✅ Test everything works
5. 🚀 Submit to App Store!

**Estimated time:** 1-2 days of work, 3-5 days total with DNS propagation

**You've got this!** The hard part (building the app) is done. This is just admin work. 💪

