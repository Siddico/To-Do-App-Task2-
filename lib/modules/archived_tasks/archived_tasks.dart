import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/components.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = ToDoAppCubit.get(context).archivedTasks;
          return tasksScreen(tasks: tasks);
        });
  }
}
