enum UserRole { owner, member, solo }
enum MemberStatus { active, expiring, expired }
enum MealTime { earlyMorning, breakfast, midMorning, lunch, eveningSnack, dinner, beforeBed }

class Gym {
  final String id;
  final String name;
  final String ownerName;
  final String location;
  final String address;
  final String phone;
  final String timings;
  final String description;
  final int totalMembers;
  final double monthlyRevenue;
  final List<String> trainers;
  final List<String> bannerUrls;

  const Gym({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.location,
    required this.address,
    required this.phone,
    required this.timings,
    required this.description,
    required this.totalMembers,
    required this.monthlyRevenue,
    required this.trainers,
    this.bannerUrls = const [],
  });
}

class Member {
  final String id;
  final String gymId;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final String emergencyContact;
  final DateTime joinDate;
  final MemberStatus status;
  final String plan;
  final double planAmount;
  final DateTime planExpiry;
  final String? trainer;
  final double currentWeight;
  final double startWeight;
  final double bmi;
  final double fatPercent;
  final double musclePercent;
  final int streak;
  final String? goal;
  final double goalProgress;
  final List<BodyMetric> bodyMetrics;
  final List<Payment> payments;
  final List<AttendanceRecord> attendance;

  const Member({
    required this.id,
    required this.gymId,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    required this.emergencyContact,
    required this.joinDate,
    required this.status,
    required this.plan,
    required this.planAmount,
    required this.planExpiry,
    this.trainer,
    required this.currentWeight,
    required this.startWeight,
    required this.bmi,
    required this.fatPercent,
    required this.musclePercent,
    required this.streak,
    this.goal,
    this.goalProgress = 0,
    this.bodyMetrics = const [],
    this.payments = const [],
    this.attendance = const [],
  });
}

class BodyMetric {
  final DateTime date;
  final double weight;
  final double bmi;
  final double fatPercent;
  final double musclePercent;

  const BodyMetric({
    required this.date,
    required this.weight,
    required this.bmi,
    required this.fatPercent,
    required this.musclePercent,
  });
}

class Payment {
  final String id;
  final DateTime date;
  final double amount;
  final String plan;
  final String status;
  final String method;

  const Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.plan,
    required this.status,
    required this.method,
  });
}

class AttendanceRecord {
  final DateTime date;
  final String checkInTime;
  final String? checkOutTime;

  const AttendanceRecord({
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
  });
}

class Exercise {
  final String name;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double? weight;
  bool completed;

  Exercise({
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    this.weight,
    this.completed = false,
  });
}

class WorkoutDay {
  final DateTime date;
  final String title;
  final List<Exercise> exercises;
  final String? assignedBy;

  const WorkoutDay({
    required this.date,
    required this.title,
    required this.exercises,
    this.assignedBy,
  });
}

class MealItem {
  final String name;
  final String quantity;
  final int calories;

  const MealItem({
    required this.name,
    required this.quantity,
    required this.calories,
  });
}

class Meal {
  final MealTime time;
  final String label;
  final List<MealItem> items;

  const Meal({
    required this.time,
    required this.label,
    required this.items,
  });

  int get totalCalories => items.fold(0, (sum, i) => sum + i.calories);
}

class DietDay {
  final DateTime date;
  final List<Meal> meals;
  final int targetCalories;
  final int protein;
  final int carbs;
  final int fat;
  final String? assignedBy;

  const DietDay({
    required this.date,
    required this.meals,
    required this.targetCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.assignedBy,
  });
}

class ActivityItem {
  final String icon;
  final String text;
  final String time;

  const ActivityItem({
    required this.icon,
    required this.text,
    required this.time,
  });
}

class SubscriptionPlan {
  final String name;
  final double price;
  final int durationMonths;

  const SubscriptionPlan({
    required this.name,
    required this.price,
    required this.durationMonths,
  });
}

class SoloUser {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final double currentWeight;
  final double startWeight;
  final double bmi;
  final double fatPercent;
  final double musclePercent;
  final int streak;
  final String goal;
  final double goalProgress;
  final List<BodyMetric> bodyMetrics;

  const SoloUser({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    required this.currentWeight,
    required this.startWeight,
    required this.bmi,
    required this.fatPercent,
    required this.musclePercent,
    required this.streak,
    required this.goal,
    this.goalProgress = 0,
    this.bodyMetrics = const [],
  });
}
