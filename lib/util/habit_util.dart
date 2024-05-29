// given a habit list of completion days
// is the habit completed today

import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  return completedDays.any((date) =>
      date.year == DateTime.now().year &&
      date.month == DateTime.now().month &&
      date.day == DateTime.now().day);
}

Map<DateTime, int> prepareHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for(var habit in habits){

    for(var date in habit.completedDays){
      final normalizedDate = DateTime(date.year, date.month, date.day);

      if(dataset.containsKey(normalizedDate)){
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        dataset[normalizedDate] = 1;
      }
    }
      }
return dataset;
  }

