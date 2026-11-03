# Dvaya Gym App — Complete Build Prompt

> **Instructions:** Paste this entire prompt into a Claude Code cloud environment. Install these plugins FIRST before starting:
> ```bash
> claude plugin install superpowers --scope user
> claude plugin install 5b256fd0-8739-430b-b7a9-c96a9d4bfead@anthropic-plugin-directory --scope user
> ```
> Then restart the session and begin. Use `/caveman` mode throughout to save tokens. Use superpowers skills: `/superpowers:writing-plans` before coding, `/superpowers:test-driven-development` for each feature, `/superpowers:verification-before-completion` before claiming anything done.

---

## COST OPTIMIZATION — USE SUB-AGENTS & CHEAPER MODELS

This build has many independent screens. **Use parallel sub-agents on cheaper models** to save money and time:

### Strategy
1. **Planning & Architecture** (main agent, smart model): Theme setup, data models, folder structure, routing, state management
2. **Independent screens** (parallel sub-agents, cheap model like Haiku/Sonnet): Each screen is self-contained with shared theme + models. Dispatch these in parallel:
   - Sub-agent 1: Owner Dashboard + Settings
   - Sub-agent 2: Members List + Member Detail (all 7 tabs)
   - Sub-agent 3: Member Home + QR Check-in + Progress
   - Sub-agent 4: Member Workouts + Diet + Payments + Profile
   - Sub-agent 5: Solo User — all screens
3. **Integration & Polish** (main agent): Wire navigation, test everything, fix issues
4. **APK Build** (main agent): Final build + GitHub release

### Rules for Sub-agents
- Each sub-agent gets: the theme file, models file, dummy data file, and its screen specs
- Each writes to its own screen files — no conflicts
- Main agent reviews and integrates after all complete
- Use `/superpowers:dispatching-parallel-agents` skill for orchestration
- Use `/superpowers:executing-plans` within each sub-agent
- Target: **complete the entire app in under 50K output tokens** across all agents

### Model Routing
- **Haiku** for: boilerplate widgets, repetitive screen layouts, data model classes
- **Sonnet** for: complex state logic, chart implementations, calendar interactions
- **Main model** for: architecture decisions, integration, testing, debugging

---

## HARD RULES — READ BEFORE WRITING ANY CODE

1. **Language: English ONLY.** No Hindi, Telugu, or any other language anywhere in the app. All UI text, labels, buttons, dummy data names — English only.
2. **Caveman mode ON.** Short responses. Code first, explanations minimal. No repeating the spec back.
3. **GitHub repo: `dvaya`** — Create repo, push after every major screen/feature. Never accumulate unpushed code.
4. **Framework: Flutter** — This is the production framework, not a throwaway. Write clean, scalable, maintainable code with proper state management (Riverpod or Provider). This codebase WILL become the real app.
5. **100% working demo.** Every button, every scroll, every navigation, every back button MUST work. No dead taps, no overflow errors, no broken transitions. Test on emulator after each screen.
6. **Final output: debug APK** downloadable and installable on any Android phone.
7. **Commit regularly** to GitHub with clear commit messages. Push after completing each screen/feature.

---

## What You're Building

A premium gym management demo app called **Dvaya** with THREE user types:

1. **Gym Owner** — Manages their gym, members, workouts, diet plans
2. **Gym Member** (associated with a gym) — Views their workouts, diet, progress, checks in
3. **Solo User** (NOT associated with any gym) — Tracks their own workouts, diet, body metrics, goals independently

This is a demo app with hardcoded dummy data — no backend, no real payments, no API calls. Every screen must have realistic data and look like a finished product.

---

## Login / Entry Flow

### Login Screen
- Dvaya logo: styled text "dvaya" in lowercase, accent color, with tagline "Powered by Dvaya"
- **Two login options (NOT a toggle):**
  - **"I'm a Gym Owner"** → Shows list of demo gyms to pick from
  - **"I'm a Member"** → Shows two sub-options:
    - **"My Gym"** → Pick a gym → Pick a member from that gym
    - **"Solo Mode"** → Enter as independent user (no gym association)
- Clean, premium login cards — not a boring form

### Demo Account Picker (after role selection)
**For Gym Owner:**
- Card 1: "Iron Temple Fitness" — Vikram Reddy — 45 members — Kukatpally
- Card 2: "FitZone Studio" — Suresh Naidu — 28 members — Madhapur

**For Gym Member:**
- Pick gym first → then pick member:
  - Iron Temple: Rajesh Kumar | Priya Sharma
  - FitZone: Arjun Rao | Meena Devi

**For Solo User:**
- Pre-loaded solo profile: "Karthik Menon" — independent fitness enthusiast
- Has his own workout log, body metrics, goals, diet — all self-managed

---

## Design System

### Theme: Premium Dark
- Background: `#0F0F0F`
- Surface/Cards: `#1A1A1A`
- Elevated Surface: `#242424`
- Accent (primary): `#FF6B2C` (vibrant orange)
- Success: `#22C55E` (green)
- Warning: `#FBBF24` (amber)
- Danger: `#EF4444` (red)
- Text Primary: `#FFFFFF`
- Text Secondary: `#9CA3AF`
- Text Tertiary: `#6B7280`
- Border/Divider: `#2A2A2A`

### Typography
- Font: Google Fonts `Poppins`
- Headings: Bold (600-700)
- Body: Regular (400), Medium (500)
- Numbers/Stats: `tabularFigures: true`

### Components
- Cards: `borderRadius: 16`, background `#1A1A1A`, subtle border `#2A2A2A`
- Buttons: Rounded (`borderRadius: 12`), accent fill, white text
- Status pills: Rounded, color-coded (green/amber/red)
- Icons: Outlined, 24px
- Bottom nav: accent for selected, grey for unselected
- Calendar: Dark themed with accent highlights
- Charts: Accent lines on dark background

---

## OWNER VIEW SCREENS

### 1. Dashboard (Home)

**Top bar:** Gym name + settings gear icon

**Greeting:** "Good morning, Vikram" (time-aware) + today's date

**Alert Card:** "3 members' payments due today" (orange, tappable → member list with WhatsApp remind button per member)

**Stats Grid (2×2, configurable via Settings):**
- Today's Check-ins: 18/45 with progress ring
- Active Members: 42 ↑ 8%
- Expiring This Week: 5 (orange)
- Monthly Revenue: ₹1,24,500 ↑ 12%

**Attendance Heatmap:** Calendar grid, color intensity = check-in count, tap day → who came

**Recent Activity Feed (5 items):** Timestamped entries — check-ins, expirations, payments

### 2. Members List

- Search bar + filter tabs: All | Active | Expiring | Expired
- Member cards: photo, name, plan, status pill, last visit, streak
- Tap → Member Detail
- FAB: "+" add member (shows form UI)

### 3. Member Detail (7 tabs)

**Header:** Photo, name, plan, status, join date. **Optional: Assigned Trainer** field (if trainer assigned, show name; if not, show "No trainer assigned" with "Assign" button)

**Tabs:**
1. **Overview** — Stats, body metrics summary, goal progress
2. **Attendance** — Calendar view, monthly counts, check-in timestamps
3. **Body Metrics** — Line charts (weight/BMI/fat/muscle over time), "Add Reading" button, before/after photo slots
4. **Workouts** — Calendar + daily workout log. Owner assigns exercises (muscle group → exercise → sets×reps×weight). "Edit", "Copy Previous", "Save as Template" buttons
5. **Diet Plan** — Calendar + meal-by-meal plan (Early Morning through Before Bed). Calories + macros auto-calculated. "Edit", "Save as Template", "Apply to Others"
6. **Goals** — Member's goal, progress bar, owner notes
7. **Payments** — Current plan, status, payment history, pending dues

### 4. Trainer Assignment (inside Member Detail or Members List)

- Optional feature — not every member needs a trainer
- Owner can assign any member to a trainer from a dropdown
- Trainers list (dummy): "Coach Ravi", "Coach Sneha" (for Iron Temple), "Coach Anil" (for FitZone)
- Trainer sees only their assigned members (future feature — for demo, just show the assignment)

### 5. Settings

**Gym Profile:** Name, logo, cover photo, address, phone, timings, description (all editable)

**Advertising Banners:** List with enable/disable toggles, "Add Banner"

**Dashboard Customization:** Toggle list — each toggle hides/shows a dashboard card:
- ✅ Today's Check-ins
- ✅ Active Members
- ✅ Expiring Subscriptions
- ✅ Monthly Revenue
- ✅ Due Today Alert
- ✅ Attendance Heatmap
- ☐ Revenue Forecast
- ✅ Recent Activity

**Subscription Plans:** List + "Add Plan" (Monthly ₹1,500 / Quarterly ₹4,000 / Annual ₹12,000)

**Owner Bottom Nav:** Dashboard | Members | ➕ | Settings

---

## MEMBER VIEW SCREENS (Gym-associated)

### 1. Home
- Gym cover photo + logo + gym name
- Greeting: "Hey Rajesh"
- Ad carousel (from gym owner's banners, auto-advance 4s)
- Quick action cards: Check In | My Progress | Today's Workout | Diet Plan
- Today's workout preview card
- Today's diet preview card
- Streak card with weekly dots

### 2. QR Check-In
- Large QR code (real QR with member ID), pulse animation
- "Show this at the entrance"
- Auto-refresh timer (counts down 30s, regenerates)
- Member photo + name
- Today's check-in status + recent 7-day history

### 3. My Progress
- Body metrics cards (weight, BMI, fat%, muscle) — member CAN update these
- Line chart (weight over 30/90/all days)
- Goal with progress bar — member CAN edit goal
- Before/after photo slots
- Attendance calendar + streak

### 4. Workouts (Read-only)
- Calendar bar at top
- Today's workout with exercises, sets, reps, weight
- Checkboxes for visual completion tracking
- "Assigned by Coach Vikram" (or trainer name if assigned)

### 5. Diet Plan (Read-only)
- Calendar bar
- Macro summary card (cal, protein, carbs, fat)
- Meal cards: Early Morning → Before Bed with food items + calories
- "Assigned by Coach/Owner"

### 6. Payments
- Current plan card with status + expiry + days remaining
- "Pay Now" button → Razorpay-style mockup (UI only, not functional)
- Payment methods shown: UPI, Card, Net Banking
- Payment history list

### 7. Profile
- Photo, name, phone, email, emergency contact, member since
- Edit button, quick body metrics update, logout

**Member Bottom Nav:** Home | Check In | Workouts | Diet | Profile

---

## SOLO USER VIEW

A member NOT associated with any gym. They manage everything themselves.

### Home
- "Hey Karthik" greeting + date
- No gym branding, no ad carousel
- Quick actions: Log Workout | My Progress | Diet Log | Check Weight
- Today's self-logged workout preview
- Streak card
- Motivational stat: "You've worked out 18 of the last 30 days"

### My Workouts (Self-managed — CAN edit)
- Calendar bar
- "Add Workout" button
- Today's workout (self-logged)
- Full exercise editor: muscle group → exercises → sets/reps/weight
- Templates available
- History by date

### My Diet (Self-managed — CAN edit)
- Calendar bar
- "Log Today's Meals" button
- Meal slots with add food items
- Macro summary
- Diet templates

### My Progress
- Same as gym member progress screen
- Body metrics (self-updated)
- Goal (self-set)
- Charts, calendar, streak
- Before/after photos

### Profile
- Personal details, edit
- "Join a Gym" button (shows message: "Contact a Dvaya-powered gym to get connected" — future feature)
- Logout

**Solo Bottom Nav:** Home | Workouts | Diet | Progress | Profile

---

## Dummy Data

### Gym 1: Iron Temple Fitness
- **Owner:** Vikram Reddy, Kukatpally, Hyderabad, 45 members, ₹1,24,500/mo
- **Trainers:** Coach Ravi, Coach Sneha
- **Member 1 — Rajesh Kumar:** Age 28, Male, 82→78kg, BMI 26.2, Fat 22%, Streak 12d, Active, Monthly ₹1,500, assigned to Coach Ravi. Chest & Triceps today. Weight loss diet 1,870 cal.
- **Member 2 — Priya Sharma:** Age 24, Female, 65→62kg, BMI 23.5, Fat 28%, Streak 5d, Expiring in 3 days, Quarterly ₹4,000, assigned to Coach Sneha. Legs & Glutes today. Balanced diet 1,600 cal.

### Gym 2: FitZone Studio
- **Owner:** Suresh Naidu, Madhapur, Hyderabad, 28 members, ₹78,000/mo
- **Trainer:** Coach Anil
- **Member 3 — Arjun Rao:** Age 32, Male, 90→86kg, BMI 28.1, Fat 25%, Streak 22d, Active, Annual ₹11,000, assigned to Coach Anil. Upper Body Power today. Muscle gain diet 2,600 cal.
- **Member 4 — Meena Devi:** Age 35, Female, 70→70kg, BMI 25.0, Fat 30%, Streak 0, Expired 5 days ago, no trainer, no workout, no diet.

### Solo User
- **Karthik Menon:** Age 26, Male, 74→72kg, BMI 23.8, Fat 18%, Streak 8d, Goal: "Maintain 72kg and build visible abs by June 2027." Self-logs workouts (Push day today: Push-ups 4×20, Dumbbell Press 3×12@12kg, Shoulder Press 3×10@10kg, Lateral Raises 3×15@6kg, Tricep Dips 3×15). Self-tracks diet 2,200 cal.

---

## Testing Checklist (MUST PASS before building APK)

### Navigation
- [ ] Login → Owner dashboard works
- [ ] Login → Member home works
- [ ] Login → Solo user home works
- [ ] Every bottom nav tab switches correctly
- [ ] Back button works on every screen (hardware + app bar)
- [ ] Logout returns to login screen
- [ ] Deep navigation: Login → Members → Member Detail → Workout tab → back → back → back → dashboard

### Scrolling
- [ ] Dashboard scrolls smoothly with all cards
- [ ] Members list scrolls with 45+ items (generate extra dummy names)
- [ ] Member detail tabs scroll independently
- [ ] Workout exercise lists scroll
- [ ] Diet meal lists scroll
- [ ] No overflow errors on any screen at any scroll position

### Interactive Elements
- [ ] All buttons have tap feedback (ripple or highlight)
- [ ] Filter tabs in members list work (All/Active/Expiring/Expired)
- [ ] Search bar filters members by name
- [ ] Calendar date taps show correct data for that date
- [ ] Dashboard customization toggles actually hide/show cards
- [ ] Stats cards show correct numbers
- [ ] Charts render with correct data points
- [ ] QR code generates and refresh timer counts down
- [ ] Ad carousel auto-advances and swipes manually
- [ ] Trainer assignment dropdown works
- [ ] "Edit Goal", "Update Metrics" bottom sheets open and close
- [ ] Payment mockup opens on "Pay Now" tap

### Visual
- [ ] Dark theme everywhere — zero white/light screens
- [ ] No Material default blue anywhere
- [ ] Consistent card styling across all screens
- [ ] Status pills show correct colors (green/amber/red)
- [ ] Charts are readable on dark background
- [ ] Text is legible — no grey-on-grey issues
- [ ] No text overflow or clipping anywhere
- [ ] Proper spacing — nothing cramped or too spread out

### Edge Cases
- [ ] Expired member (Meena) shows no workout, no diet, red status
- [ ] Expiring member (Priya) shows amber warning
- [ ] Solo user has no gym branding anywhere
- [ ] Solo user CAN edit workouts and diet (unlike gym members)
- [ ] Gym member CANNOT edit workouts or diet (read-only)
- [ ] Dashboard with all toggles off shows empty state message
- [ ] Landscape orientation doesn't break layouts

---

## Build Phases & Git Strategy

### Phase 1: Setup + Theme + Login
```bash
# Create project
flutter create dvaya_gym && cd dvaya_gym

# Create GitHub repo and push
gh repo create dvaya --public --source=. --push
```
- Set up theme, colors, fonts
- Build login/role selection screen
- **Commit + push: "feat: project setup with theme and login flow"**

### Phase 2: Data Models + Dummy Data
- Create all model classes (Gym, Member, Workout, Exercise, DietPlan, Meal, BodyMetric, etc.)
- Create dummy_data.dart with ALL data above
- **Commit + push: "feat: data models and dummy data"**

### Phase 3: Owner Screens
- Dashboard → Members List → Member Detail (all 7 tabs) → Settings
- **Commit + push after each screen**

### Phase 4: Member Screens
- Home → QR Check-in → Progress → Workouts → Diet → Payments → Profile
- **Commit + push after each screen**

### Phase 5: Solo User Screens
- Home → Workouts (editable) → Diet (editable) → Progress → Profile
- **Commit + push after each screen**

### Phase 6: Polish + Testing
- Run full testing checklist above
- Fix every overflow, navigation, and visual issue
- **Commit + push: "fix: polish and testing fixes"**

### Phase 7: Build APK
```bash
flutter build apk --debug
```
- APK at `build/app/outputs/flutter-apk/app-debug.apk`
- **Commit + push: "release: demo APK v1.0"**
- Upload APK as GitHub release

---

## Folder Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── data/
│   ├── models.dart
│   └── dummy_data.dart
├── providers/           (state management — Riverpod or Provider)
│   ├── auth_provider.dart
│   ├── gym_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── login/
│   │   └── login_screen.dart
│   ├── owner/
│   │   ├── owner_shell.dart        (bottom nav wrapper)
│   │   ├── dashboard.dart
│   │   ├── members_list.dart
│   │   ├── member_detail.dart
│   │   ├── add_workout.dart
│   │   ├── add_diet_plan.dart
│   │   └── settings.dart
│   ├── member/
│   │   ├── member_shell.dart       (bottom nav wrapper)
│   │   ├── home.dart
│   │   ├── qr_checkin.dart
│   │   ├── progress.dart
│   │   ├── workouts.dart
│   │   ├── diet_plan.dart
│   │   ├── payments.dart
│   │   └── profile.dart
│   └── solo/
│       ├── solo_shell.dart         (bottom nav wrapper)
│       ├── home.dart
│       ├── workouts.dart           (editable version)
│       ├── diet.dart               (editable version)
│       ├── progress.dart
│       └── profile.dart
└── widgets/
    ├── stats_card.dart
    ├── member_card.dart
    ├── attendance_calendar.dart
    ├── workout_card.dart
    ├── exercise_editor.dart
    ├── diet_card.dart
    ├── meal_editor.dart
    ├── body_metric_chart.dart
    ├── qr_display.dart
    ├── payment_mockup.dart
    ├── ad_carousel.dart
    └── streak_card.dart
```

## Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  google_fonts: ^6.1.0
  fl_chart: ^0.69.0
  qr_flutter: ^4.1.0
  table_calendar: ^3.1.0
  smooth_page_indicator: ^1.2.0
  carousel_slider: ^5.0.0
  intl: ^0.19.0
```

---

## CRITICAL REMINDERS

- **English only** — no other language anywhere
- **Push to GitHub after every feature** — repo name: `dvaya`
- **Test every screen on emulator** before moving to next
- **This code is the production foundation** — write it clean and scalable
- **Dark theme ONLY** — if you see any white/light screen, it's a bug
- **Every tap must do something** — no dead buttons
- **APK must be the final deliverable**
- **Use superpowers skills** for planning and verification
- **Use caveman mode** for token efficiency
