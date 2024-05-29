import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  HabitTile(
      {super.key,
      required this.isCompleted,
      required this.name,
      required this.onChanged,
      required this.deleteHabit,
      required this.updateHabit});
  final bool isCompleted;
  final String name;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? deleteHabit;
  final void Function(BuildContext)? updateHabit;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: ScrollMotion(), children: [
        SlidableAction(
          onPressed: 
            deleteHabit
          ,
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
        SlidableAction(
          onPressed: 
            updateHabit,
          
          backgroundColor: Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: 'Update',
        ),
      ]),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isCompleted
                ? Colors.green
                : Theme.of(context).colorScheme.secondary,
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(name),
            leading: Checkbox(
              value: isCompleted,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
