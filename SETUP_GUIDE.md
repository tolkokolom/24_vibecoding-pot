# 🚀 Quick Setup Guide for Friends

## **📋 Prerequisites**

- ✅ **Xcode 14.0+** installed
- ✅ **iPhone** running **iOS 15.0+**
- ✅ **Apple ID** (free account works)

## **⚡ 3-Minute Setup**

### **1. Clone & Open**

```bash
git clone [YOUR_GITHUB_REPO_URL]
cd HapticsTestApp
open HapticsTestApp.xcodeproj
```

### **2. Configure in Xcode**

1. 📱 Select **HapticsTestApp** project → **Signing & Capabilities**
2. ✅ Check **"Automatically manage signing"**
3. 👤 Select your **Team** (Apple ID)
4. 📦 Change **Bundle Identifier** to:
   ```
   com.yourname.HapticsTestApp
   ```
   (Replace `yourname` with your name)

### **3. Connect iPhone & Run**

1. 🔌 Connect iPhone via USB
2. 📱 Trust computer when prompted
3. ⚙️ **Settings** → **Privacy & Security** → **Developer Mode** → **ON**
4. 📱 Select iPhone in Xcode (top-left)
5. ⌘ Press **Cmd+R**

## **🎮 Testing Haptics**

### **Essential Settings Check:**

- ⚙️ **Settings** → **Sounds & Haptics** → **System Haptics** → **ON**
- 🔋 Turn OFF **Low Power Mode**
- 🔇 Device NOT in Silent Mode

### **Best Test Sequence:**

1. 🎛️ Enable haptics toggle in app
2. 🔨 **Impact** → **Heavy Impact** (strongest)
3. 📢 **Notification** → **Success** (distinct pattern)
4. 👆 **Selection** → **Multiple Selections** (rapid sequence)

## **🔧 Common Issues**

| Problem               | Solution                                     |
| --------------------- | -------------------------------------------- |
| "No Account for Team" | Add Apple ID in Xcode → Settings → Accounts  |
| "No profiles found"   | Make Bundle ID unique + automatic signing    |
| No haptics felt       | Check System Haptics ON + Low Power Mode OFF |
| Can't connect iPhone  | Restart Xcode + reconnect device             |

## **🎯 That's it!**

The app should install and run. Test different haptic patterns and enjoy!

**Remember**: Haptics only work on real iPhones, not the Simulator! 📱✨
