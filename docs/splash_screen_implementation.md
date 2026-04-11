# Splash Screen Implementation Guide

This document explains how splash screens work in this Flutter application, covering both native (Android/iOS) and Flutter-based splash screens.

---

## Table of Contents

1. [Overview](#overview)
2. [How Android Splash Screens Work](#how-android-splash-screens-work)
3. [How iOS Splash Screens Work](#how-ios-splash-screens-work)
4. [Flutter Splash Screen (AppLoader)](#flutter-splash-screen-apploader)
5. [Splash Screen Flow](#splash-screen-flow)
6. [File Structure](#file-structure)
7. [Customization Guide](#customization-guide)
8. [Troubleshooting](#troubleshooting)

---

## Overview

This application uses a **two-stage splash screen** approach:

1. **Native Splash Screen** - Shows immediately when the app launches, before Flutter initializes
2. **Flutter Splash Screen (AppLoader)** - Shows while Flutter is initializing and the app is preparing to display content

### Why Two Splash Screens?

- **Native splash** appears instantly (no delay)
- **Flutter splash** provides a smooth transition with animations and theming
- **Native splash** hides the brief moment before Flutter renders

---

## How Android Splash Screens Work

### Android Splash Screen Architecture

Android displays a splash screen (launch screen) before your Flutter activity is fully loaded. This is controlled by:

1. **Theme Configuration** - `res/values/styles.xml`
2. **Drawable Resources** - `res/drawable/launch_background.xml`
3. **App Launcher Icon** - `mipmap-*` folders

### Key Files

```
android/app/src/main/res/
├── drawable/
│   ├── splash_logo.png          # Logo image for splash
│   └── launch_background.xml     # Splash background (light mode)
├── drawable-night/
│   ├── splash_logo.png          # Logo image for splash
│   └── launch_background.xml     # Splash background (dark mode)
├── drawable-v21/
│   ├── splash_logo.png          # Logo for Android 5+
│   └── launch_background.xml     # Splash background
├── values/
│   └── styles.xml               # Theme configuration
├── values-night/
│   └── styles.xml               # Dark mode theme
├── values-v31/
│   └── styles.xml               # Android 12+ theme
└── values-night-v31/
    └── styles.xml               # Android 12+ dark mode theme
```

### Theme Configuration (Standard - Android < 12)

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
    <!-- Background drawable for splash -->
    <item name="android:windowBackground">@drawable/launch_background</item>
    
    <!-- Prevent dark mode auto-conversion -->
    <item name="android:forceDarkAllowed">false</item>
    
    <!-- Fullscreen mode -->
    <item name="android:windowFullscreen">true</item>
    
    <!-- System bar handling -->
    <item name="android:windowDrawsSystemBarBackgrounds">false</item>
    
    <!-- Display cutout mode -->
    <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
</style>
```

### Modern Theme Configuration (Android 12+ / v31)

For Android 12 and above, the system uses a new Splash Screen API. Configuration is found in `values-v31/styles.xml`:

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
    <!-- Modern Splash Screen API attributes -->
    <item name="android:windowSplashScreenBackground">@color/splash_background</item>
    <item name="android:windowSplashScreenAnimatedIcon">@drawable/splash_logo</item>
    
    <!-- Layout and system bar handling -->
    <item name="android:forceDarkAllowed">false</item>
    <item name="android:windowFullscreen">true</item>
    <item name="android:windowDrawsSystemBarBackgrounds">false</item>
    <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
</style>
```

**Key Modern Attributes:**
- `windowSplashScreenBackground`: Solid background color (defined in `colors.xml`).
- `windowSplashScreenAnimatedIcon`: The icon displayed in the center.

### Drawable Background (`launch_background.xml`)

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Background color -->
    <item>
        <shape android:shape="rectangle">
            <solid android:color="#FFFFFF"/>
        </shape>
    </item>
    <!-- Centered logo -->
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/splash_logo"/>
    </item>
</layer-list>
```

### How Android Resolves Resources

Android automatically selects the correct resource based on:

1. **Screen density** - `drawable-mdpi`, `drawable-hdpi`, etc.
2. **Night mode** - `drawable-night/` folder
3. **Android version** - `drawable-v21/` for API 21+
4. **Theme** - Light vs Dark mode

### Dark Mode Support

For dark mode, Android uses:
- `drawable-night/` folder for night mode resources
- `values-night/` for night mode styles
- System automatically switches based on user preference

---

## How iOS Splash Screens Work

### iOS Splash Screen Architecture

iOS uses storyboard files to define the launch screen. Unlike Android, iOS doesn't support runtime theme switching for launch screens.

### Key Files

```
ios/Runner/
├── Base.lproj/
│   ├── LaunchScreen.storyboard       # Launch screen definition
│   └── Main.storyboard               # Main storyboard
└── Assets.xcassets/
    └── SplashLogo.imageset/
        ├── Contents.json              # Image set configuration
        └── splash_logo.png           # Logo image
```

### Storyboard Configuration (`LaunchScreen.storyboard`)

The storyboard defines the splash screen layout using XML. Key elements:

```xml
<!-- Background color -->
<color key="backgroundColor" systemColor="systemBackgroundColor"/>

<!-- Logo image -->
<imageView image="SplashLogo" contentMode="scaleAspectFit"/>

<!-- Constraints to center logo -->
<constraints>
    <constraint firstItem="logoImageView" firstAttribute="centerX" .../>
    <constraint firstItem="logoImageView" firstAttribute="centerY" .../>
</constraints>
```

### iOS Dark Mode Limitation

iOS launch screens **cannot** automatically switch between light and dark mode like Android. The launch screen:
- Uses static colors defined in the storyboard
- Or uses `systemBackgroundColor` which adapts to the current system appearance
- Cannot be changed programmatically

### Image Set Configuration (`Contents.json`)

```json
{
  "images" : [
    {
      "filename" : "splash_logo.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "splash_logo@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "splash_logo@3x.png",
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

---

## Flutter Splash Screen (AppLoader)

### What is AppLoader?

`AppLoader` is a Flutter widget that displays while the app is initializing. It's different from native splash screens because:

- Built with Flutter widgets (not native code)
- Supports animations
- Can access Flutter features (theme, context)
- Shows during Flutter engine initialization

### AppLoader Location

```
lib/PhoneBook/screens/app_loader.dart
```

### Code Structure

```dart
class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  
  // Animation controller for splash animations
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _controller = AnimationController(...);
    _bounceAnimation = Tween<double>(begin: -20, end: 0).animate(...);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(...);
    
    // Start animation
    _controller.forward();

    // Navigate to main app after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => const AdaptiveLayout()),
          (route) => false,  // Remove splash from navigation stack
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Detect system brightness for theming
  bool get _isDarkMode {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        // Theme-aware background color
        color: _isDarkMode
            ? DarkModeColors.primaryBackground
            : LightModeColors.primaryBackground,
        
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo with shadow
                      Image.asset(...),
                      
                      // App name
                      Text('ROLODEX', ...),
                      
                      // Tagline
                      Text('Your Digital Phonebook', ...),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```

### Key Features of AppLoader

1. **StatefulWidget** - Manages animation state
2. **SingleTickerProviderStateMixin** - Provides animation controller
3. **Theme-aware** - Adapts to light/dark mode
4. **Animation effects**:
   - Bounce animation (elastic out)
   - Fade in animation
   - Blue glow shadow around logo
5. **Auto-navigation** - Navigates to main app after delay
6. **Safe navigation** - Uses `mounted` check before navigating

---

## Splash Screen Flow

### Application Launch Sequence

```
┌─────────────────────────────────────────────────────────────────┐
│                     APPLICATION LAUNCH                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│ 1. SYSTEM BOOTSTRAP                                              │
│    - Android/iOS loads the app binary                            │
│    - Creates the Flutter activity/view controller                │
│    - Shows system default (brief white/black flash)              │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. NATIVE SPLASH SCREEN (Android/iOS)                           │
│    - Uses launch_background.xml (Android)                        │
│    - Uses LaunchScreen.storyboard (iOS)                         │
│    - Shows: Background color + centered logo                      │
│    - Duration: Until Flutter renders first frame                 │
│                                                                 │
│    ┌─────────────────────────────────────────────────────────┐   │
│    │              Native Splash Screen                         │   │
│    │                                                         │   │
│    │                        🧬                               │   │
│    │                                                         │   │
│    └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. FLUTTER INITIALIZATION                                        │
│    - Flutter engine starts                                       │
│    - Dart VM initializes                                        │
│    - Widgets start rendering                                     │
│    - AppLoader widget displayed                                  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. FLUTTER SPLASH SCREEN (AppLoader)                            │
│    - Shows during Flutter initialization                         │
│    - Displays animated logo + app name                          │
│    - Theme-aware (light/dark mode)                              │
│    - Duration: Configurable (default 2 seconds)                  │
│                                                                 │
│    ┌─────────────────────────────────────────────────────────┐   │
│    │              Flutter Splash Screen                        │   │
│    │                                                         │   │
│    │                        🧬                               │   │
│    │                     ROLODEX                             │   │
│    │              Your Digital Phonebook                      │   │
│    └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. MAIN APPLICATION (AdaptiveLayout)                             │
│    - Full app UI displayed                                       │
│    - Navigation stack cleared (splash removed)                   │
│    - User can interact with app                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Navigation Stack Management

The splash screen uses `pushAndRemoveUntil` to clean up the navigation stack:

```dart
Navigator.of(context).pushAndRemoveUntil(
  CupertinoPageRoute(builder: (_) => const AdaptiveLayout()),
  (route) => false,  // Remove ALL previous routes (including splash)
);
```

This prevents:
- Back button returning to splash screen
- Duplicate Hero widget conflicts
- Memory leaks from old routes

---

## File Structure

### Complete Splash Screen File Structure

```
basics/
├── lib/
│   └── PhoneBook/
│       ├── screens/
│       │   ├── app_loader.dart           # Flutter splash screen
│       │   ├── app_routes.dart            # Route definitions
│       │   └── adaptive_layout.dart       # Main app layout
│       └── theme/
│           └── app_theme.dart            # Theme colors (Light/Dark)
│
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── res/
│                   ├── drawable/
│                   │   ├── launch_background.xml    # Light mode
│                   │   └── splash_logo.png          # Logo
│                   ├── drawable-night/
│                   │   ├── launch_background.xml    # Dark mode
│                   │   └── splash_logo.png          # Logo
│                   ├── drawable-v21/
│                   │   ├── launch_background.xml    # Android 5+
│                   │   └── splash_logo.png          # Logo
│                   ├── values/
│                   │   └── styles.xml              # Light theme
│                   ├── values-night/
│                   │   └── styles.xml              # Dark theme
│                   ├── values-v31/
│                   │   └── styles.xml              # Android 12 theme
│                   └── values-night-v31/
│                       └── styles.xml              # Android 12 dark
│
└── ios/
    └── Runner/
        ├── Base.lproj/
        │   └── LaunchScreen.storyboard       # iOS splash
        └── Assets.xcassets/
            └── SplashLogo.imageset/
                ├── Contents.json             # Image config
                └── splash_logo.png          # Logo
```

### Theme Colors

Theme colors are defined in `lib/PhoneBook/theme/app_theme.dart`:

```dart
// Light Mode Colors
class LightModeColors {
  static const Color primaryBackground = CupertinoColors.systemBackground; // White
  static const Color secondaryBackground = Color(0xFFF2F2F7);
  static const Color primaryText = CupertinoColors.black;
  static const Color secondaryText = CupertinoColors.systemGrey;
}

// Dark Mode Colors  
class DarkModeColors {
  static const Color primaryBackground = CupertinoColors.black;
  static const Color secondaryBackground = Color(0xFF1C1C1E);
  static const Color primaryText = CupertinoColors.white;
  static const Color secondaryText = CupertinoColors.systemGrey;
}
```

---

## Customization Guide

### 1. Change Logo

**Steps:**
1. Replace the SVG file: `assets/images/genetic-research-svgrepo-com.svg`
2. Convert to PNG:
   ```bash
   # Using Node.js with sharp
   node convert.js
   ```
3. Copy to native folders:
   ```bash
   # Android
   cp assets/images/splash_logo.png android/app/src/main/res/drawable/
   cp assets/images/splash_logo.png android/app/src/main/res/drawable-night/
   cp assets/images/splash_logo.png android/app/src/main/res/drawable-v21/
   
   # iOS
   cp assets/images/splash_logo.png ios/Runner/Assets.xcassets/SplashLogo.imageset/
   ```

### 2. Change Splash Background Color

**Android (`res/drawable/launch_background.xml`):**
```xml
<solid android:color="#FFFFFF"/>  <!-- Change this hex color -->
```

**Android Dark Mode (`res/drawable-night/launch_background.xml`):**
```xml
<solid android:color="#000000"/>  <!-- Change this hex color -->
```

**iOS (`Base.lproj/LaunchScreen.storyboard`):**
```xml
<color key="backgroundColor" red="1" green="1" blue="1" .../>
<!-- Or use system color: -->
<color key="backgroundColor" systemColor="systemBackgroundColor"/>
```

### 3. Change Flutter Splash Animation

Edit `lib/PhoneBook/screens/app_loader.dart`:

```dart
// Animation duration
_duration: const Duration(milliseconds: 1500)

// Bounce animation
_bounceAnimation = Tween<double>(begin: -20, end: 0).animate(
  CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
)

// Fade animation
_fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
  CurvedAnimation(parent: _controller, curve: Curves.easeIn),
)
```

Available animation curves:
- `Curves.easeIn` - Slow start
- `Curves.easeOut` - Slow end
- `Curves.easeInOut` - Slow start and end
- `Curves.elasticOut` - Bounce effect
- `Curves.bounceOut` - Bouncing effect
- `Curves.linear` - Constant speed

### 4. Change Splash Display Duration

Edit `lib/PhoneBook/screens/app_loader.dart`:

```dart
// In initState()
Future.delayed(const Duration(seconds: 2), () {
  // Navigation code...
});
```

**Note:** This delay should be:
- Long enough for Flutter to initialize (usually 1-2 seconds)
- Short enough not to frustrate users

### 5. Change App Name on Splash

Edit `lib/PhoneBook/screens/app_loader.dart`:

```dart
Text(
  'ROLODEX',  // Change this
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 4,
    color: ...,
  ),
),

Text(
  'Your Digital Phonebook',  // Change tagline
  style: TextStyle(...),
),
```

### 6. Add More Animation Effects

```dart
// Rotation animation
late Animation<double> _rotationAnimation;
// In initState:
_rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
  CurvedAnimation(parent: _controller, curve: Curves.linear),
);

// Scale animation
late Animation<double> _scaleAnimation;
// In initState:
_scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
  CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
);

// In build():
Transform.scale(
  scale: _scaleAnimation.value,
  child: Transform.rotate(
    angle: _rotationAnimation.value,
    child: Image.asset(...),
  ),
)
```

---

## Troubleshooting

### Problem: Two Splash Screens Appearing

**Symptoms:** 
- Black screen with logo appears first
- Then white screen with logo appears
- Then app loads

**Cause:** 
- Multiple splash configurations conflicting
- Missing or misconfigured resources

**Solution:**
1. Ensure `splash_logo.png` exists in all drawable folders:
   ```bash
   ls android/app/src/main/res/drawable*/splash_logo.png
   ```

2. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   ```

3. Check for duplicate configurations in `pubspec.yaml`

### Problem: Splash Screen Doesn't Match Theme

**Symptoms:**
- Splash shows one theme but app shows another
- Colors don't match

**Cause:**
- Native splash uses different colors than Flutter splash
- Night mode not configured

**Solution:**
1. Check Android drawable folders exist:
   ```bash
   ls android/app/src/main/res/drawable-night/
   ```

2. Verify `values-night/styles.xml` exists and references `drawable-night`

3. Update AppLoader to detect theme:
   ```dart
   bool get _isDarkMode {
     final brightness = MediaQuery.platformBrightnessOf(context);
     return brightness == Brightness.dark;
   }
   ```

### Problem: App Stuck on Splash Screen

**Symptoms:**
- Splash screen never disappears
- App never loads

**Cause:**
- Navigation code not executing
- Mounted check preventing navigation
- Navigation stack issue

**Solution:**
1. Check browser console for errors
2. Verify navigation code in `initState()`
3. Ensure `pushAndRemoveUntil` is used (not `pushReplacement`)
4. Check `mounted` condition:
   ```dart
   Future.delayed(Duration(seconds: 2), () {
     if (mounted && context.mounted) {  // Double check
       Navigator.of(context).pushAndRemoveUntil(...);
     }
   });
   ```

### Problem: Hero Widget Error

**Error:**
```
There are multiple heroes that share the same tag within a subtree.
```

**Cause:**
- Using `pushReplacement` instead of `pushAndRemoveUntil`
- Multiple routes with Hero widgets

**Solution:**
```dart
// Instead of:
Navigator.of(context).pushReplacement(...);

// Use:
Navigator.of(context).pushAndRemoveUntil(
  CupertinoPageRoute(builder: (_) => const MainApp()),
  (route) => false,  // Remove all previous routes
);
```

### Problem: White Flash Before Splash

**Symptoms:**
- Brief white screen before native splash

**Cause:**
- System default background showing before app loads
- Missing `windowBackground` configuration

**Solution:**
1. Ensure `styles.xml` has:
   ```xml
   <item name="android:windowBackground">@drawable/launch_background</item>
   ```

2. Add splash screen to all configurations:
   ```bash
   # Android 12+
   cp splash_logo.png android/app/src/main/res/drawable/
   ```

### Problem: SVG Logo Not Displaying

**Symptoms:**
- Logo appears broken or wrong
- PNG was working

**Cause:**
- SVG needs conversion to PNG for Android/iOS
- Native platforms don't support SVG directly

**Solution:**
```bash
# Convert SVG to PNG (using Node.js sharp)
node convert.js

# Copy to native folders
cp assets/images/splash_logo.png android/app/src/main/res/drawable/
cp assets/images/splash_logo.png ios/Runner/Assets.xcassets/SplashLogo.imageset/
```

---

## Best Practices

### 1. Keep Splash Duration Short
- Native splash: As short as possible (handled by system)
- Flutter splash: 1.5-2.5 seconds maximum
- User attention span is limited

### 2. Match Theme Colors
- Ensure native and Flutter splash use same colors
- Test in both light and dark modes
- Use system colors where possible

### 3. Optimize Logo Image
- Use PNG format for native splash
- Provide multiple resolutions (1x, 2x, 3x for iOS)
- Keep file size small (<50KB)
- Use simple, recognizable icon

### 4. Animation Performance
- Use `AnimatedBuilder` for efficient rebuilds
- Avoid heavy computations in animation
- Test on lower-end devices

### 5. Handle Navigation Safely
- Always check `mounted` before navigation
- Use `pushAndRemoveUntil` to clean stack
- Handle edge cases (fast taps, back button)

---

## Summary

This implementation provides a smooth, professional splash screen experience:

1. **Native splash** appears instantly with logo
2. **Flutter splash** provides animated, themed transition
3. **Both work together** seamlessly
4. **Theme-aware** for light/dark modes
5. **Customizable** for colors, animations, and content

For any changes, follow the customization guide above. Always test on both platforms and in both themes (light/dark).

---

## Identical Splash UI (Future Enhancement)

### Goal
Make both native and Flutter splash screens look identical so users don't notice the transition.

### Current State
- **Native Android**: Shows logo + background color only
- **Flutter AppLoader**: Shows logo + "ROLODEX" + "Your Digital Phonebook" tagline

### Options Considered

| Option | Approach | Complexity | Status |
|--------|----------|------------|--------|
| A | Combined PNG image (logo + text merged) | Low | Pending |
| B | Jetpack Compose splash + cached FlutterEngine | High | Reverted (cross-platform complexity) |
| C | Keep current (different UI) | - | Current |

### Why Option B Was Reverted
The Compose approach would require restructuring the app as a native Android shell with Flutter module. While technically feasible, it would:
- Add complexity to the Android build
- Require maintaining separate entry points
- Not benefit iOS/Web/Desktop platforms

### Recommended: Option A
Create a combined PNG image for native splash that matches Flutter's full UI:
- Logo + "ROLODEX" text + "Your Digital Phonebook" tagline
- Use exact same colors from Flutter AppLoader
- This keeps native simple (just image swap) and maintains cross-platform compatibility

### Task List
- [ ] Create combined splash image with logo + text
- [ ] Add text using Android vector drawable
- [ ] Test both layers look identical
- [ ] Verify seamless transition
