import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/components/components.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/styles/styles_color.dart';

// ignore: must_be_immutable
class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  // @override

  final Color activeColor = Colors.blueAccent;

  final Color inactiveColor = Colors.grey;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ToDoAppCubit()
          ..createDatabase(), // to save ToDoAppCubit as variable and communicate with easily
        child: BlocConsumer<ToDoAppCubit, ToDoAppStates>(
          listener: (BuildContext context, ToDoAppStates state) {
            // TODO: implement listener
            if (state is ToDoAppInsertIntoDatabase) {
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, ToDoAppStates state) {
            ToDoAppCubit cubit = ToDoAppCubit.get(context);
            return Scaffold(
                backgroundColor: Colors.white,
                key: scaffoldKey,
                appBar: AppBar(
                  backgroundColor: StylesColor().appbarColor,
                  title: Text(
                    cubit.titles[cubit.currentIndex],
                    style: GoogleFonts.cairo(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: StylesColor().appbarColor,
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState!.validate()) {
                        cubit.insertToDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text);
                        //     .then((value) {
                        //   cubit.getDataFromDatabase(cubit.database).then(
                        //     (value) {
                        //       Navigator.pop(context);
                        //       // setState(() {
                        //       //   tasks = value;
                        //       //   fabIcon = Icons.edit;
                        //       //   isBottomSheetShown = false;
                        //       // });
                        //       // print(tasks);
                        //     },
                        //   );
                        // });
                      }
                    } else {
                      scaffoldKey.currentState!
                          .showBottomSheet(
                            elevation: 25,
                            (context) => Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                              padding: EdgeInsets.all(8),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        label: 'Task Title',
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'title must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.title,
                                        context: context),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    defaultFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        // isClickable: false,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                            // print(value!.format(context));
                                          });
                                        },
                                        label: 'Task Time',
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'time must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.watch_later_outlined,
                                        context: context),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    defaultFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        // isClickable: false,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2030-12-30'))
                                              .then((value) {
                                            // print(value.toString());
                                            // print(DateFormat.yMMMD().format(value));
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        label: 'Task Date',
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'date must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.calendar_today,
                                        context: context)
                                  ],
                                ),
                              ),
                            ),
                          )
                          .closed
                          .then((value) {
                        // Navigator.pop(context);
                        // cubit.isBottomSheetShown = false;
                        // // setState(() {
                        // //   fabIcon = Icons.edit;
                        // // });
                        cubit.changeBottomSheetState(
                            isShow: false, icon: Icons.edit);
                      });
                      // cubit.isBottomSheetShown = true;
                      // // setState(() {
                      // //   fabIcon = Icons.add;
                      // // });
                      cubit.changeBottomSheetState(
                          isShow: true, icon: Icons.add);
                    }

                    // insertToDatabase();
                    // try {
                    //   var name = await getName();
                    //   print(name);
                    // } catch (e) {
                    //   print('error ${e.toString()}');
                    // }
                    // for handle exception we use throw catch
                    // getName().then((value) {
                    //   print(value);
                    //   print('siddico');
                    //   // throw ('أنا عملت إيروووووووووور !!!!');
                    // }).catchError((error) {
                    //   //anonymous function
                    //   print('${error.toString()}');
                    // });
                  },
                  child: Icon(
                    cubit.fabIcon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                // bottomNavigationBar: BottomNavigationBar(
                //   selectedItemColor: StylesColor().appbarColor,
                //   unselectedItemColor: const Color.fromARGB(255, 100, 96, 96),
                //   type: BottomNavigationBarType.fixed,
                //   currentIndex: cubit.currentIndex,
                //   onTap: (index) {
                //     cubit.changeIndex(index);
                //     // setState(() {
                //     //   currentIndex = index;
                //     // });
                //   },
                //   elevation: 0,
                //   items: [
                //     BottomNavigationBarItem(
                //         icon: Icon(Icons.menu), label: 'Tasks'),
                //     BottomNavigationBarItem(
                //         icon: Icon(Icons.check_circle_outline), label: 'Done'),
                //     BottomNavigationBarItem(
                //         icon: Icon(Icons.archive_outlined), label: 'Archived'),
                //   ],
                // ),

                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: StylesColor().appbarColor,
                  unselectedItemColor: const Color.fromARGB(255, 100, 96, 96),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
// setState(() {
// currentIndex = index;
// });
                  },
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu), label: 'Tasks'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline), label: 'Done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive_outlined), label: 'Archived'),
                  ],
                ),
                body: ConditionalBuilder(
                    condition: state is! ToDoAppGetLoadingDatabase,
                    builder: (context) => cubit.screens[cubit.currentIndex],
                    fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ))
                // screens[currentIndex],
                );
          },
        ));
  }
}
