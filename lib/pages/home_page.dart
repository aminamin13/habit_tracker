import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/heat_map.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/habit_database.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<HabitDatabase>(context, listen: false).readHabits();
  }

  final textController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Habit Name',
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // get the new habit name

                  String newHabitName = textController.text;

                  // add the habit to database

                  context.read<HabitDatabase>().addHabit(newHabitName);

                  //close the dialog

                  Navigator.pop(context);

                  //clear the text controller

                  textController.clear();
                },
                child: Text('Add Habit'))
          ],
        );
      },
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    //update the habit completion status
    if (value != null)
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
  }

  void editHabit(Habit habit) {
    // set the controller text to the habit name
    textController.text = habit.name;
    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Habit Name',
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // get the new habit name

                  String newHabitName = textController.text;

                  // add the habit to database

                  context
                      .read<HabitDatabase>()
                      .updateHabits(habit.id, newHabitName);

                  //close the dialog

                  Navigator.pop(context);

                  //clear the text controller

                  textController.clear();
                },
                child: Text('Update Habit'))
          ],
        );
      },
    );
  }

  void deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Are you Sure you want to delete the habit"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);

                  //close the dialog

                  Navigator.pop(context);

                  //clear the text controller
                },
                child: Text('Delete Habit'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: () {},
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              createNewHabit();
            },
          ),
        ),
        body: ListView(children: [
          _buildHeatMap(),
          _buildHabitList(),
        ]));
  }

//build heat map

  Widget _buildHeatMap() {
    // habit database

    final habitDatabase = context.watch<HabitDatabase>();

    //current habbits

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepareHeatMapDataset(currentHabits));
        } else {
          return Container();
        }
      },
    );
  }

// build habit list

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit

        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        //return habit tile ui

        return HabitTile(
            isCompleted: isCompletedToday,
            name: habit.name,
            onChanged: (value) {
              checkHabitOnOff(value, habit);
            },
            updateHabit: (context) => editHabit(habit),
            deleteHabit: (context) => deleteHabit(habit));
      },
    );
  }
}
