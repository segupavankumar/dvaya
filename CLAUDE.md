# Dvaya — Premium Gym Management SaaS (Flutter)

## What This Is

A multi-role gym management demo app targeting 2 gym owners in Hyderabad, India. Built with Flutter, runs on Web (GitHub Pages), Android (APK), and desktop browsers. All data is currently dummy/hardcoded — no backend yet.

**Live URL:** https://segupavankumar.github.io/dvaya/
**GitHub:** https://github.com/segupavankumar/dvaya
**Working branch:** `claude/fervent-thompson-yidyrd`

---

## Critical Security Constraint

**Coach role MUST NOT see any payment data, financial info, or other members' confidential information.**

- Coach has limited data access, NOT admin-level
- Coach can ONLY see their assigned members (`assignedMemberIds`), never all gym members
- The `coachAssignedMembersProvider` in `lib/providers/auth_provider.dart` enforces this
- Never expose `Member.payments`, `Member.planAmount`, `Gym.monthlyRevenue` to coach screens
- When adding new coach features, always filter through `assignedMemberIds`

---

## Architecture

### State Management — Riverpod

- `themeModeProvider = StateProvider<ThemeMode>` — dark mode default
- `authProvider = StateNotifierProvider<AuthNotifier, AuthState>` — role, gym, member/coach selection
- `ownerTabProvider`, `memberTabProvider`, `soloTabProvider`, `coachTabProvider` — `StateProvider<int>` for shell tab indices
- `dashboardConfigProvider = StateNotifierProvider` — owner dashboard widget toggles
- `selectedMemberFilterProvider`, `memberSearchProvider` — member list filtering

### Theme System — Static Color Getters

`lib/theme/app_theme.dart` uses a static `AppColors` class with a `_isDark` boolean:

```
AppColors.updateBrightness(isDark)  // called in DvayaApp.build()
AppColors.background                // getter — returns dark/light color
AppColors.warning                   // getter — darker amber in light mode
AppColors.accent                    // const — same in both themes
```

**Key rules:**
- `AppColors.warning` is a **getter** (not const) — returns `0xFFFBBF24` dark, `0xFFD97706` light
- You CANNOT use `const` on any widget that references `AppColors.warning` (it's not compile-time constant)
- Shell files (`*_shell.dart`) must NOT use `const` on screen lists — prevents theme rebuild
- `accent` (`0xFFFF6B2C`), `success` (`0xFF22C55E`), `danger` (`0xFFEF4444`) are `static const`
- All other colors (`background`, `surface`, `textPrimary`, `border`, etc.) are getters

### Responsive Layout — 3-tier System

`lib/widgets/responsive.dart` provides:

- **`DesktopAwareCenter`** — the primary layout wrapper. 3-tier width: mobile (<600px), tablet (600-900px), desktop (>900px)
- **`Responsive.isDesktop(context)`** — `width > 900`, used for multi-column layouts
- **`Responsive.isWide(context)`** — `width > 600`, used by `AdaptiveShell` for NavigationRail vs BottomNav
- **`responsiveGridCount(context)`** — returns 2/3/4 columns for GridView
- **`ResponsiveCenter`** — legacy, single-width constraint. Prefer `DesktopAwareCenter`

**Desktop widths by role:**

| Screen | Desktop Max Width |
|--------|------------------|
| Owner dashboard, members_list | 1200px |
| Owner settings, member_detail | 1000px |
| Coach home, members, member_detail | 1000px |
| Coach profile, checkin | 800px |
| Member home | 1000px |
| Member qr_checkin | 600px |
| Member workouts, diet, progress, profile | 800px |
| Solo home | 1000px |
| Solo workouts, diet, progress, profile | 800px |
| Login | 420px (intentionally narrow) |

### Navigation — AdaptiveShell

`lib/widgets/adaptive_shell.dart` — auto-switches between:
- **>=600px:** `NavigationRail` (side) + `IndexedStack`
- **<600px:** `BottomNavigationBar` + `IndexedStack`

Each role has a shell file that wires tabs to screens:

- `OwnerShell`: Dashboard(0), Members(1), Settings(2)
- `MemberShell`: Home(0), QrCheckin(1), Workouts(2), DietPlan(3), Progress(4), Profile(5)
- `CoachShell`: Home(0), Members(1), Checkin(2), Profile(3)
- `SoloShell`: Home(0), Workouts(1), Diet(2), Progress(3), Profile(4)

### Charts — fl_chart

`fl_chart` library used for `LineChart` in:
- `lib/screens/member/progress.dart` — Weight Trend + BMI Trend
- `lib/screens/solo/progress.dart` — Weight Trend
- `lib/screens/owner/member_detail.dart` — Weight Trend in Progress tab
- `lib/screens/coach/coach_member_detail.dart` — Weight Trend + BMI Trend in Progress tab

### Fonts

Google Fonts Poppins throughout via `google_fonts` package. Always use `GoogleFonts.poppins(...)`.

---

## Data Layer

All data is hardcoded in `lib/data/dummy_data.dart`. No API calls.

### Models (`lib/data/models.dart`)

- **`Gym`** — id, name, ownerName, location, address, phone, timings, totalMembers, monthlyRevenue, trainers, bannerUrls
- **`Member`** — id, gymId, name, age, gender, phone, email, joinDate, status, plan, planAmount, planExpiry, trainer, currentWeight, startWeight, bmi, fatPercent, musclePercent, streak, goal, goalProgress, bodyMetrics, payments, attendance
- **`Coach`** — id, gymId, name, phone, email, specialization, yearsExperience, assignedMemberIds, attendance
- **`SoloUser`** — id, name, age, gender, phone, email, currentWeight, startWeight, bmi, fatPercent, musclePercent, streak, goal, goalProgress, bodyMetrics
- **`BodyMetric`** — date, weight, bmi, fatPercent, musclePercent
- **`Payment`** — id, memberId, amount, date, plan, method, status
- **`AttendanceRecord`** — date, checkIn, checkOut
- **`DietDay`** — date, meals, targetCalories, protein, carbs, fat, assignedBy
- **`SubscriptionPlan`** — name, price, durationMonths

### Dummy Data Entries

- 2 Gyms: Iron Temple (gym1, Kukatpally), FitZone (gym2, Gachibowli)
- 5 Members across both gyms
- 3 Coaches: Ravi (c1, Strength, gym1), Sneha (c2, Functional, gym1), Anil (c3, Powerlifting, gym2)
- 1 SoloUser
- `now` variable — reference date for demo data
- Helper functions: `getWorkoutsForMember()`, `getDietForMember()`, `getSoloWorkouts()`, `getSoloDiet()`

---

## 4 User Roles

### Owner
- Full dashboard with stats, activity feed, attendance heatmap, alerts
- Member list with search/filter, detailed member view (7 tabs: Overview, Progress, Attendance, Workouts, Diet, Payments, Notes)
- Settings: gym profile, subscription plans, banners, dashboard config, appearance (theme toggle)
- **Has access to all financial data**

### Member
- Home with gym banner carousel, quick actions, today's workout/diet preview, streak card
- QR check-in screen
- Workout plans, diet plans, progress tracking (weight + BMI charts)
- Profile with tappable trainer row → navigates to `CoachProfileView`
- **Cannot see other members' data**

### Coach
- Home with today's schedule, stats, assigned members overview
- Member list (ONLY assigned members), detailed member view (5 tabs: Overview, Progress, Attendance, Workouts, Diet)
- Check-in screen, profile screen
- **NO access to payment/financial data**

### Solo (independent user, no gym)
- Home with quick actions, workout preview, streak, motivation card
- Self-managed workouts, diet, progress (weight chart)
- Profile with personal stats

---

## File Structure

```
lib/
  main.dart                          # App entry, DvayaApp ConsumerWidget
  data/
    models.dart                      # All data classes
    dummy_data.dart                  # Hardcoded demo data
  providers/
    auth_provider.dart               # Auth state, role-based member providers
    settings_provider.dart           # Tab providers, dashboard config
  theme/
    app_theme.dart                   # AppColors, AppTheme, themeModeProvider
  widgets/
    responsive.dart                  # DesktopAwareCenter, Responsive, responsiveGridCount
    adaptive_shell.dart              # AdaptiveShell (NavigationRail / BottomNav)
    streak_card.dart                 # Reusable streak display
    qr_display.dart                  # QR code container with border/shadow
  screens/
    login/login_screen.dart          # Role/gym/member selection
    owner/                           # Owner role screens
    member/                          # Member role screens
    coach/                           # Coach role screens
    solo/                            # Solo user screens
```

---

## Build & Deploy

### Prerequisites
- Flutter 3.47+ stable
- Android SDK platform-35, build-tools-35.0.0 (for APK)

### Commands

```bash
# Web (local dev)
flutter run -d chrome

# Web release (for GitHub Pages)
flutter build web --release --base-href "/dvaya/"

# Android APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Run on connected device
flutter run
```

### CI/CD
GitHub Actions workflow at `.github/workflows/deploy-web.yml`:
- Triggers on push to `main` or `claude/fervent-thompson-yidyrd`
- Builds web release with `--base-href "/dvaya/"`
- Deploys to GitHub Pages

---

## Common Patterns

### Adding a new screen
1. Create the screen file in the appropriate role folder
2. Use `DesktopAwareCenter` as the content wrapper with appropriate `desktopMaxWidth`
3. Set `Scaffold(backgroundColor: AppColors.background, ...)`
4. For multi-column desktop: check `Responsive.isDesktop(context)` and use `Row` with `Expanded`
5. Add to the role's shell file (update tab indices, destinations, screen list)
6. Do NOT use `const` on screen instantiations in shell files

### Theme-safe color usage
- Use `AppColors.xxx` getters for theme-reactive colors
- Never mark widgets containing `AppColors.warning` as `const`
- For alpha overlays, use `.withValues(alpha: 0.15)` — raise to 0.10+ for light theme visibility
- Bottom sheets get `backgroundColor: AppColors.surface` at call time

### Adding charts
- Import `package:fl_chart/fl_chart.dart`
- Use `LineChart` with `LineChartData`, `FlSpot` for data points
- Color with `AppColors.accent`, `AppColors.success`, or `AppColors.warning`
- Wrap in `SizedBox(height: 200)` and `Container` with surface background

---

## Known Constraints

- All data is dummy — no backend, no persistence
- `AppColors._isDark` is a static mutable boolean, not reactive — works because `DvayaApp.build()` calls `updateBrightness()` on every rebuild
- `now` in dummy_data.dart is the reference timestamp for all demo dates
- Bottom sheet max width is 640px (set in app_theme.dart)
- QR code is a static display (no actual scanning)
- No authentication — login screen is just role/entity selection
