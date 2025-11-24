# WFR TrailTriage Website

This is the GitHub Pages website for WFR TrailTriage - a wilderness medicine SOAP notes application.

## 🚀 Setting Up GitHub Pages

### Step 1: Create a GitHub Repository
1. Go to [GitHub](https://github.com) and sign in (or create an account)
2. Click the "+" icon in the top right and select "New repository"
3. Name it something like `wfr-trailtriage-website` or `trailtriage`
4. Make it **Public**
5. Click "Create repository"

### Step 2: Upload Your Website Files
You have two options:

#### Option A: Using GitHub Web Interface (Easiest)
1. In your new repository, click "uploading an existing file"
2. Drag and drop all the files from the `docs` folder:
   - `index.html`
   - `style.css`
   - `privacy.html`
   - `support.html`
   - `terms.html`
3. Scroll down and click "Commit changes"

#### Option B: Using Git Command Line
```bash
cd /path/to/your/docs/folder
git init
git add .
git commit -m "Initial website commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

### Step 3: Enable GitHub Pages
1. In your repository, click "Settings"
2. Scroll down and click "Pages" in the left sidebar
3. Under "Source", select "Deploy from a branch"
4. Under "Branch", select `main` and the root folder `/`
5. Click "Save"

### Step 4: Access Your Website
After a few minutes, your website will be live at:
```
https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/
```

For example: `https://lukealvarez.github.io/wfr-trailtriage/`

## 🌐 Using a Custom Domain

If you want to use `blackelkmountainmedicine.com`:

1. **Purchase the domain** from a registrar (GoDaddy, Namecheap, Google Domains, etc.)
2. **Add a CNAME file** to your repository with your domain name:
   ```
   blackelkmountainmedicine.com
   ```
3. **Configure DNS** at your domain registrar:
   - Add a CNAME record pointing to `YOUR_USERNAME.github.io`
   - Or add A records pointing to GitHub's IPs:
     ```
     185.199.108.153
     185.199.109.153
     185.199.110.153
     185.199.111.153
     ```
4. **Enable custom domain** in GitHub Pages settings

More info: [GitHub Pages Custom Domain Documentation](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)

## 📝 Updating Your Website

To make changes:
1. Edit the HTML/CSS files
2. Commit and push to GitHub (or upload via web interface)
3. Changes will appear within a few minutes

## 🔗 Update Your App

Once your website is live, update the URL in your app:

**File: `MainTabView.swift`**

Replace line 196:
```swift
Link(destination: URL(string: "https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/")!) {
```

For example:
```swift
Link(destination: URL(string: "https://lukealvarez.github.io/wfr-trailtriage/")!) {
```

## 📋 Website Structure

- **index.html** - Main landing page with features and download info
- **privacy.html** - Privacy policy (required for App Store)
- **support.html** - Support and FAQ page
- **terms.html** - Terms of service
- **style.css** - All styling for the website

## ✨ Customization

Feel free to customize:
- Colors in `style.css` (look for `:root` variables)
- App Store links (once your app is published)
- Contact email addresses
- Company/organization name
- Add screenshots or images
- Update text content

## 📱 For App Store Submission

Apple requires:
1. ✅ Privacy Policy URL - `https://your-site.com/privacy.html`
2. ✅ Support URL - `https://your-site.com/support.html`
3. Optional: Marketing website - `https://your-site.com/`

You're all set!

## 🆘 Need Help?

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Pages Troubleshooting](https://docs.github.com/en/pages/getting-started-with-github-pages/troubleshooting-404-errors-for-github-pages-sites)

---

**Note:** All content is copyright 2025 Black Elk Mountain Medicine. Modify as needed for your use.
