import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

// initilize database

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

// sace first date of app startup

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchingDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }
// get first date of app startup

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchingDate;
  }

// List of habits

  List<Habit> currentHabits = [];

// CRUD

  Future<void> addHabit(String textFromUser) async {
    final newHabit = Habit()..name = textFromUser;

    await isar.writeTxn(() => isar.habits.put(newHabit));
    readHabits();
  }

  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    notifyListeners();
  }

  Future<void> updateHabits(int id, String newText) async {
    final existingHabit = await isar.habits.get(id);

    if (existingHabit != null) {
      existingHabit.name = newText;
      await isar.writeTxn(() => isar.habits.put(existingHabit));
      readHabits();
    }
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habbit

    final existingHabit = await isar.habits.get(id);

    //update completion status

    if (existingHabit != null) {
      await isar.writeTxn(() async {
        // if habit is completed --> add the current date to the completeddays list
        if (isCompleted &&
            !existingHabit.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          existingHabit.completedDays
              .add(DateTime(today.year, today.month, today.day));
        }

        // if habit is not completed --> remove the current date from the completeddays list
        else {
          existingHabit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        await isar.habits.put(existingHabit);
      });
      readHabits();
    }
  }

    Future<void> deleteHabit(int id) async {
      await isar.writeTxn(() async {
        await isar.habits.delete(id);
      });
      await readHabits();
    }
  }
