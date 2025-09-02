#!/bin/bash

# Haptic Test App - Project Setup Script
echo "🎯 Setting up Haptic Test App..."

# Check if Xcode project exists
if [ ! -d "HapticsTestApp.xcodeproj" ]; then
    echo "❌ Please create the Xcode project first!"
    echo "📖 Follow the instructions in README.md"
    exit 1
fi

echo "📁 Copying custom source files..."

# Backup original files
echo "💾 Creating backup of original files..."
mkdir -p backup
cp HapticsTestApp/AppDelegate.swift backup/ 2>/dev/null || true
cp HapticsTestApp/SceneDelegate.swift backup/ 2>/dev/null || true
cp HapticsTestApp/ViewController.swift backup/ 2>/dev/null || true
cp HapticsTestApp/Base.lproj/Main.storyboard backup/ 2>/dev/null || true
cp HapticsTestApp/Base.lproj/LaunchScreen.storyboard backup/ 2>/dev/null || true
cp HapticsTestApp/Info.plist backup/ 2>/dev/null || true

# Check if our custom files exist
if [ ! -f "HapticsTestApp/AppDelegate.swift" ]; then
    echo "❌ Custom source files not found!"
    echo "📖 Make sure you're in the right directory"
    exit 1
fi

echo "✅ Custom files ready!"
echo "🔨 Files to replace in your Xcode project:"
echo "   • AppDelegate.swift"
echo "   • SceneDelegate.swift"  
echo "   • ViewController.swift"
echo "   • Main.storyboard"
echo "   • LaunchScreen.storyboard"
echo "   • Info.plist"
echo ""
echo "📱 Next steps:"
echo "1. Open HapticsTestApp.xcodeproj in Xcode"
echo "2. Replace the generated files with our custom versions"
echo "3. Connect your iPhone"
echo "4. Build and run (⌘+R)"
echo ""
echo "🎉 Ready to test haptics on your iPhone!"

chmod +x setup_project.sh
