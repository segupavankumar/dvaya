import 'models.dart';

final now = DateTime.now();

final gyms = [
  Gym(
    id: 'gym1',
    name: 'Iron Temple Fitness',
    ownerName: 'Vikram Reddy',
    location: 'Kukatpally',
    address: 'Plot 42, KPHB Colony, Kukatpally, Hyderabad 500072',
    phone: '+91 98765 43210',
    timings: '5:00 AM - 10:00 PM',
    description: 'Premium strength & conditioning gym with state-of-the-art equipment.',
    totalMembers: 45,
    monthlyRevenue: 124500,
    trainers: ['Coach Ravi', 'Coach Sneha'],
    bannerUrls: ['New Year Offer: 20% off Annual Plans!', 'Personal Training slots available', 'Refer a friend, get 1 month free'],
  ),
  Gym(
    id: 'gym2',
    name: 'FitZone Studio',
    ownerName: 'Suresh Naidu',
    location: 'Madhapur',
    address: '3rd Floor, Cyber Towers, Madhapur, Hyderabad 500081',
    phone: '+91 87654 32109',
    timings: '6:00 AM - 9:00 PM',
    description: 'Boutique fitness studio specializing in functional training & group classes.',
    totalMembers: 28,
    monthlyRevenue: 78000,
    trainers: ['Coach Anil'],
    bannerUrls: ['Group classes starting this week!', 'Free trial for new members'],
  ),
];

List<AttendanceRecord> _generateAttendance(int days, {bool skipRecent = false}) {
  final records = <AttendanceRecord>[];
  for (var i = days; i >= (skipRecent ? 6 : 0); i--) {
    if (i % 3 != 0) {
      records.add(AttendanceRecord(
        date: now.subtract(Duration(days: i)),
        checkInTime: '${6 + (i % 4)}:${(i * 7) % 60 < 10 ? '0' : ''}${(i * 7) % 60} AM',
        checkOutTime: '${7 + (i % 4)}:${(i * 13) % 60 < 10 ? '0' : ''}${(i * 13) % 60} AM',
      ));
    }
  }
  return records;
}

List<BodyMetric> _generateMetrics(double startW, double endW, double startBmi, double endBmi, double startFat, double endFat, double startMuscle, double endMuscle, int days) {
  final metrics = <BodyMetric>[];
  for (var i = 0; i < days; i += 7) {
    final t = i / days;
    metrics.add(BodyMetric(
      date: now.subtract(Duration(days: days - i)),
      weight: startW + (endW - startW) * t,
      bmi: startBmi + (endBmi - startBmi) * t,
      fatPercent: startFat + (endFat - startFat) * t,
      musclePercent: startMuscle + (endMuscle - startMuscle) * t,
    ));
  }
  return metrics;
}

final members = [
  Member(
    id: 'm1',
    gymId: 'gym1',
    name: 'Rajesh Kumar',
    age: 28,
    gender: 'Male',
    phone: '+91 99887 76655',
    email: 'rajesh.kumar@email.com',
    emergencyContact: '+91 99887 11223',
    joinDate: now.subtract(const Duration(days: 120)),
    status: MemberStatus.active,
    plan: 'Monthly',
    planAmount: 1500,
    planExpiry: now.add(const Duration(days: 18)),
    trainer: 'Coach Ravi',
    currentWeight: 78,
    startWeight: 82,
    bmi: 26.2,
    fatPercent: 22,
    musclePercent: 38,
    streak: 12,
    goal: 'Lose 5kg and reach 77kg by March 2027',
    goalProgress: 0.8,
    bodyMetrics: _generateMetrics(82, 78, 27.5, 26.2, 25, 22, 35, 38, 90),
    payments: [
      Payment(id: 'p1', date: now.subtract(const Duration(days: 5)), amount: 1500, plan: 'Monthly', status: 'Paid', method: 'UPI'),
      Payment(id: 'p2', date: now.subtract(const Duration(days: 35)), amount: 1500, plan: 'Monthly', status: 'Paid', method: 'Cash'),
      Payment(id: 'p3', date: now.subtract(const Duration(days: 65)), amount: 1500, plan: 'Monthly', status: 'Paid', method: 'UPI'),
    ],
    attendance: _generateAttendance(30),
  ),
  Member(
    id: 'm2',
    gymId: 'gym1',
    name: 'Priya Sharma',
    age: 24,
    gender: 'Female',
    phone: '+91 88776 65544',
    email: 'priya.sharma@email.com',
    emergencyContact: '+91 88776 99887',
    joinDate: now.subtract(const Duration(days: 87)),
    status: MemberStatus.expiring,
    plan: 'Quarterly',
    planAmount: 4000,
    planExpiry: now.add(const Duration(days: 3)),
    trainer: 'Coach Sneha',
    currentWeight: 62,
    startWeight: 65,
    bmi: 23.5,
    fatPercent: 28,
    musclePercent: 30,
    streak: 5,
    goal: 'Tone up and build endurance',
    goalProgress: 0.6,
    bodyMetrics: _generateMetrics(65, 62, 24.6, 23.5, 31, 28, 27, 30, 87),
    payments: [
      Payment(id: 'p4', date: now.subtract(const Duration(days: 87)), amount: 4000, plan: 'Quarterly', status: 'Paid', method: 'Card'),
    ],
    attendance: _generateAttendance(20),
  ),
  Member(
    id: 'm3',
    gymId: 'gym2',
    name: 'Arjun Rao',
    age: 32,
    gender: 'Male',
    phone: '+91 77665 54433',
    email: 'arjun.rao@email.com',
    emergencyContact: '+91 77665 00112',
    joinDate: now.subtract(const Duration(days: 300)),
    status: MemberStatus.active,
    plan: 'Annual',
    planAmount: 11000,
    planExpiry: now.add(const Duration(days: 65)),
    trainer: 'Coach Anil',
    currentWeight: 86,
    startWeight: 90,
    bmi: 28.1,
    fatPercent: 25,
    musclePercent: 40,
    streak: 22,
    goal: 'Build muscle mass to 92kg lean',
    goalProgress: 0.45,
    bodyMetrics: _generateMetrics(90, 86, 29.5, 28.1, 28, 25, 36, 40, 120),
    payments: [
      Payment(id: 'p5', date: now.subtract(const Duration(days: 300)), amount: 11000, plan: 'Annual', status: 'Paid', method: 'Net Banking'),
    ],
    attendance: _generateAttendance(40),
  ),
  Member(
    id: 'm4',
    gymId: 'gym2',
    name: 'Meena Devi',
    age: 35,
    gender: 'Female',
    phone: '+91 66554 43322',
    email: 'meena.devi@email.com',
    emergencyContact: '+91 66554 88990',
    joinDate: now.subtract(const Duration(days: 200)),
    status: MemberStatus.expired,
    plan: 'Monthly',
    planAmount: 1500,
    planExpiry: now.subtract(const Duration(days: 5)),
    trainer: null,
    currentWeight: 70,
    startWeight: 70,
    bmi: 25.0,
    fatPercent: 30,
    musclePercent: 28,
    streak: 0,
    goal: 'General fitness',
    goalProgress: 0.1,
    bodyMetrics: _generateMetrics(70, 70, 25, 25, 30, 30, 28, 28, 60),
    payments: [
      Payment(id: 'p6', date: now.subtract(const Duration(days: 35)), amount: 1500, plan: 'Monthly', status: 'Paid', method: 'UPI'),
      Payment(id: 'p7', date: now.subtract(const Duration(days: 5)), amount: 1500, plan: 'Monthly', status: 'Due', method: ''),
    ],
    attendance: _generateAttendance(30, skipRecent: true),
  ),
];

final soloUser = SoloUser(
  id: 'solo1',
  name: 'Karthik Menon',
  age: 26,
  gender: 'Male',
  phone: '+91 55443 32211',
  email: 'karthik.menon@email.com',
  currentWeight: 72,
  startWeight: 74,
  bmi: 23.8,
  fatPercent: 18,
  musclePercent: 42,
  streak: 8,
  goal: 'Maintain 72kg and build visible abs by June 2027',
  goalProgress: 0.55,
  bodyMetrics: _generateMetrics(74, 72, 24.5, 23.8, 20, 18, 40, 42, 60),
);

final List<String> extraMemberNames = [
  'Aditya Verma', 'Ananya Singh', 'Bharat Patel', 'Chandra Mohan', 'Deepa Nair',
  'Esha Gupta', 'Farhan Ahmed', 'Geeta Iyer', 'Hari Prasad', 'Indira Joshi',
  'Jayant Kulkarni', 'Kavita Rao', 'Lakshmi Pillai', 'Mohan Das', 'Neha Reddy',
  'Omkar Joshi', 'Pallavi Menon', 'Raghav Shetty', 'Suman Acharya', 'Tanvi Desai',
  'Uday Kiran', 'Varun Nayak', 'Wasim Khan', 'Yamini Rao', 'Zara Begum',
  'Akash Tiwari', 'Bindu Sharma', 'Chetan Hegde', 'Divya Raman', 'Ganesh Murthy',
  'Hemanth Kumar', 'Ishaan Saxena', 'Janaki Devi', 'Krishna Iyer', 'Lalitha Rao',
  'Manoj Varma', 'Nandini Bhat', 'Pavan Goud', 'Renu Aggarwal', 'Sunil Patil',
  'Tejas Nair',
];

Map<DateTime, List<WorkoutDay>> getWorkoutsForMember(String memberId) {
  final today = DateTime(now.year, now.month, now.day);
  switch (memberId) {
    case 'm1':
      return {
        today: [
          WorkoutDay(date: today, title: 'Chest & Triceps', assignedBy: 'Coach Ravi', exercises: [
            Exercise(name: 'Flat Bench Press', muscleGroup: 'Chest', sets: 4, reps: 10, weight: 60),
            Exercise(name: 'Incline Dumbbell Press', muscleGroup: 'Chest', sets: 3, reps: 12, weight: 20),
            Exercise(name: 'Cable Flyes', muscleGroup: 'Chest', sets: 3, reps: 15, weight: 12),
            Exercise(name: 'Tricep Pushdown', muscleGroup: 'Triceps', sets: 3, reps: 12, weight: 18),
            Exercise(name: 'Overhead Tricep Extension', muscleGroup: 'Triceps', sets: 3, reps: 12, weight: 14),
            Exercise(name: 'Dips', muscleGroup: 'Triceps', sets: 3, reps: 15),
          ]),
        ],
        today.subtract(const Duration(days: 1)): [
          WorkoutDay(date: today.subtract(const Duration(days: 1)), title: 'Back & Biceps', assignedBy: 'Coach Ravi', exercises: [
            Exercise(name: 'Deadlift', muscleGroup: 'Back', sets: 4, reps: 8, weight: 80),
            Exercise(name: 'Lat Pulldown', muscleGroup: 'Back', sets: 3, reps: 12, weight: 45),
            Exercise(name: 'Barbell Row', muscleGroup: 'Back', sets: 3, reps: 10, weight: 50),
            Exercise(name: 'Barbell Curl', muscleGroup: 'Biceps', sets: 3, reps: 12, weight: 20),
            Exercise(name: 'Hammer Curl', muscleGroup: 'Biceps', sets: 3, reps: 12, weight: 10),
          ]),
        ],
      };
    case 'm2':
      return {
        today: [
          WorkoutDay(date: today, title: 'Legs & Glutes', assignedBy: 'Coach Sneha', exercises: [
            Exercise(name: 'Barbell Squat', muscleGroup: 'Legs', sets: 4, reps: 10, weight: 40),
            Exercise(name: 'Romanian Deadlift', muscleGroup: 'Glutes', sets: 3, reps: 12, weight: 30),
            Exercise(name: 'Leg Press', muscleGroup: 'Legs', sets: 3, reps: 15, weight: 80),
            Exercise(name: 'Hip Thrust', muscleGroup: 'Glutes', sets: 3, reps: 12, weight: 50),
            Exercise(name: 'Walking Lunges', muscleGroup: 'Legs', sets: 3, reps: 14, weight: 10),
            Exercise(name: 'Calf Raises', muscleGroup: 'Legs', sets: 4, reps: 20, weight: 30),
          ]),
        ],
      };
    case 'm3':
      return {
        today: [
          WorkoutDay(date: today, title: 'Upper Body Power', assignedBy: 'Coach Anil', exercises: [
            Exercise(name: 'Military Press', muscleGroup: 'Shoulders', sets: 4, reps: 8, weight: 50),
            Exercise(name: 'Weighted Pull-ups', muscleGroup: 'Back', sets: 4, reps: 8, weight: 15),
            Exercise(name: 'Bench Press', muscleGroup: 'Chest', sets: 4, reps: 8, weight: 80),
            Exercise(name: 'Barbell Row', muscleGroup: 'Back', sets: 3, reps: 10, weight: 60),
            Exercise(name: 'Face Pulls', muscleGroup: 'Shoulders', sets: 3, reps: 15, weight: 15),
          ]),
        ],
      };
    default:
      return {};
  }
}

Map<DateTime, DietDay> getDietForMember(String memberId) {
  final today = DateTime(now.year, now.month, now.day);
  switch (memberId) {
    case 'm1':
      return {
        today: DietDay(date: today, targetCalories: 1870, protein: 140, carbs: 180, fat: 55, assignedBy: 'Vikram Reddy', meals: [
          const Meal(time: MealTime.earlyMorning, label: 'Early Morning', items: [
            MealItem(name: 'Warm water + Lemon', quantity: '1 glass', calories: 10),
            MealItem(name: 'Almonds', quantity: '6 pcs', calories: 42),
          ]),
          const Meal(time: MealTime.breakfast, label: 'Breakfast', items: [
            MealItem(name: 'Oats with milk', quantity: '1 bowl', calories: 280),
            MealItem(name: 'Banana', quantity: '1', calories: 105),
            MealItem(name: 'Boiled eggs', quantity: '3 whites', calories: 51),
          ]),
          const Meal(time: MealTime.midMorning, label: 'Mid-Morning', items: [
            MealItem(name: 'Protein shake', quantity: '1 scoop', calories: 120),
            MealItem(name: 'Apple', quantity: '1', calories: 95),
          ]),
          const Meal(time: MealTime.lunch, label: 'Lunch', items: [
            MealItem(name: 'Brown rice', quantity: '1 cup', calories: 216),
            MealItem(name: 'Grilled chicken breast', quantity: '150g', calories: 231),
            MealItem(name: 'Mixed salad', quantity: '1 bowl', calories: 45),
            MealItem(name: 'Dal', quantity: '1 cup', calories: 150),
          ]),
          const Meal(time: MealTime.eveningSnack, label: 'Evening Snack', items: [
            MealItem(name: 'Peanut butter toast', quantity: '1 slice', calories: 190),
            MealItem(name: 'Green tea', quantity: '1 cup', calories: 2),
          ]),
          const Meal(time: MealTime.dinner, label: 'Dinner', items: [
            MealItem(name: 'Chapati', quantity: '2', calories: 140),
            MealItem(name: 'Paneer bhurji', quantity: '100g', calories: 160),
            MealItem(name: 'Cucumber raita', quantity: '1 bowl', calories: 50),
          ]),
        ]),
      };
    case 'm2':
      return {
        today: DietDay(date: today, targetCalories: 1600, protein: 100, carbs: 160, fat: 50, assignedBy: 'Coach Sneha', meals: [
          const Meal(time: MealTime.earlyMorning, label: 'Early Morning', items: [
            MealItem(name: 'Green tea', quantity: '1 cup', calories: 2),
            MealItem(name: 'Soaked almonds', quantity: '5 pcs', calories: 35),
          ]),
          const Meal(time: MealTime.breakfast, label: 'Breakfast', items: [
            MealItem(name: 'Idli', quantity: '3 pcs', calories: 195),
            MealItem(name: 'Sambar', quantity: '1 cup', calories: 130),
          ]),
          const Meal(time: MealTime.lunch, label: 'Lunch', items: [
            MealItem(name: 'Quinoa salad', quantity: '1 bowl', calories: 280),
            MealItem(name: 'Grilled fish', quantity: '120g', calories: 180),
            MealItem(name: 'Steamed vegetables', quantity: '1 cup', calories: 60),
          ]),
          const Meal(time: MealTime.eveningSnack, label: 'Evening Snack', items: [
            MealItem(name: 'Fruit yogurt', quantity: '1 cup', calories: 150),
          ]),
          const Meal(time: MealTime.dinner, label: 'Dinner', items: [
            MealItem(name: 'Vegetable soup', quantity: '1 bowl', calories: 90),
            MealItem(name: 'Grilled paneer', quantity: '100g', calories: 260),
            MealItem(name: 'Salad', quantity: '1 bowl', calories: 45),
          ]),
        ]),
      };
    case 'm3':
      return {
        today: DietDay(date: today, targetCalories: 2600, protein: 180, carbs: 260, fat: 80, assignedBy: 'Coach Anil', meals: [
          const Meal(time: MealTime.earlyMorning, label: 'Early Morning', items: [
            MealItem(name: 'Banana', quantity: '2', calories: 210),
            MealItem(name: 'Peanut butter', quantity: '2 tbsp', calories: 190),
          ]),
          const Meal(time: MealTime.breakfast, label: 'Breakfast', items: [
            MealItem(name: 'Egg omelette', quantity: '4 eggs', calories: 360),
            MealItem(name: 'Whole wheat toast', quantity: '3 slices', calories: 240),
            MealItem(name: 'Orange juice', quantity: '1 glass', calories: 110),
          ]),
          const Meal(time: MealTime.midMorning, label: 'Mid-Morning', items: [
            MealItem(name: 'Mass gainer shake', quantity: '1 scoop', calories: 350),
          ]),
          const Meal(time: MealTime.lunch, label: 'Lunch', items: [
            MealItem(name: 'Chicken biryani', quantity: '1.5 cups', calories: 450),
            MealItem(name: 'Raita', quantity: '1 bowl', calories: 60),
            MealItem(name: 'Boiled eggs', quantity: '2', calories: 140),
          ]),
          const Meal(time: MealTime.eveningSnack, label: 'Evening Snack', items: [
            MealItem(name: 'Dry fruits mix', quantity: '50g', calories: 280),
          ]),
          const Meal(time: MealTime.dinner, label: 'Dinner', items: [
            MealItem(name: 'Rice', quantity: '1.5 cups', calories: 300),
            MealItem(name: 'Mutton curry', quantity: '150g', calories: 320),
            MealItem(name: 'Curd', quantity: '1 cup', calories: 98),
          ]),
        ]),
      };
    default:
      return {};
  }
}

Map<DateTime, List<WorkoutDay>> getSoloWorkouts() {
  final today = DateTime(now.year, now.month, now.day);
  return {
    today: [
      WorkoutDay(date: today, title: 'Push Day', exercises: [
        Exercise(name: 'Push-ups', muscleGroup: 'Chest', sets: 4, reps: 20),
        Exercise(name: 'Dumbbell Press', muscleGroup: 'Chest', sets: 3, reps: 12, weight: 12),
        Exercise(name: 'Shoulder Press', muscleGroup: 'Shoulders', sets: 3, reps: 10, weight: 10),
        Exercise(name: 'Lateral Raises', muscleGroup: 'Shoulders', sets: 3, reps: 15, weight: 6),
        Exercise(name: 'Tricep Dips', muscleGroup: 'Triceps', sets: 3, reps: 15),
      ]),
    ],
    today.subtract(const Duration(days: 1)): [
      WorkoutDay(date: today.subtract(const Duration(days: 1)), title: 'Pull Day', exercises: [
        Exercise(name: 'Pull-ups', muscleGroup: 'Back', sets: 4, reps: 10),
        Exercise(name: 'Dumbbell Row', muscleGroup: 'Back', sets: 3, reps: 12, weight: 14),
        Exercise(name: 'Bicep Curls', muscleGroup: 'Biceps', sets: 3, reps: 12, weight: 10),
        Exercise(name: 'Face Pulls', muscleGroup: 'Shoulders', sets: 3, reps: 15, weight: 8),
      ]),
    ],
  };
}

Map<DateTime, DietDay> getSoloDiet() {
  final today = DateTime(now.year, now.month, now.day);
  return {
    today: DietDay(date: today, targetCalories: 2200, protein: 150, carbs: 220, fat: 65, meals: [
      const Meal(time: MealTime.breakfast, label: 'Breakfast', items: [
        MealItem(name: 'Scrambled eggs', quantity: '3', calories: 210),
        MealItem(name: 'Toast with avocado', quantity: '2 slices', calories: 280),
        MealItem(name: 'Black coffee', quantity: '1 cup', calories: 5),
      ]),
      const Meal(time: MealTime.midMorning, label: 'Mid-Morning', items: [
        MealItem(name: 'Protein bar', quantity: '1', calories: 200),
      ]),
      const Meal(time: MealTime.lunch, label: 'Lunch', items: [
        MealItem(name: 'Brown rice bowl', quantity: '1 bowl', calories: 350),
        MealItem(name: 'Grilled chicken', quantity: '150g', calories: 231),
        MealItem(name: 'Steamed broccoli', quantity: '1 cup', calories: 55),
      ]),
      const Meal(time: MealTime.eveningSnack, label: 'Evening Snack', items: [
        MealItem(name: 'Greek yogurt', quantity: '1 cup', calories: 130),
        MealItem(name: 'Mixed berries', quantity: '1/2 cup', calories: 40),
      ]),
      const Meal(time: MealTime.dinner, label: 'Dinner', items: [
        MealItem(name: 'Grilled salmon', quantity: '150g', calories: 280),
        MealItem(name: 'Sweet potato', quantity: '1 medium', calories: 103),
        MealItem(name: 'Green salad', quantity: '1 bowl', calories: 45),
      ]),
    ]),
  };
}

final recentActivities = [
  ActivityItem(icon: '🏋️', text: 'Rajesh Kumar checked in', time: '8:15 AM'),
  ActivityItem(icon: '💰', text: 'Priya Sharma payment due in 3 days', time: '7:00 AM'),
  ActivityItem(icon: '🏋️', text: 'Aditya Verma checked in', time: 'Yesterday, 6:45 PM'),
  ActivityItem(icon: '❌', text: 'Meena Devi membership expired', time: 'Yesterday, 12:00 AM'),
  ActivityItem(icon: '💳', text: 'Arjun Rao renewed Annual plan', time: '2 days ago'),
];

final subscriptionPlans = [
  const SubscriptionPlan(name: 'Monthly', price: 1500, durationMonths: 1),
  const SubscriptionPlan(name: 'Quarterly', price: 4000, durationMonths: 3),
  const SubscriptionPlan(name: 'Annual', price: 12000, durationMonths: 12),
];

Map<String, bool> defaultDashboardConfig = {
  'Today\'s Check-ins': true,
  'Active Members': true,
  'Expiring Subscriptions': true,
  'Monthly Revenue': true,
  'Due Today Alert': true,
  'Attendance Heatmap': true,
  'Revenue Forecast': false,
  'Recent Activity': true,
};
