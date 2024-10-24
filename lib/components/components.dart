import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged? onSubmit,
  bool isPassword = false,
  ValueChanged? onChanged,
  GestureTapCallback? onTap,
  FormFieldValidator<String>? validate,
  required String label,
  IconData? prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
  bool underLine = true,
  required var context,
}) =>
    Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        onFieldSubmitted: onSubmit,
        onChanged: onChanged,
        validator: validate,
        onTap: onTap,
        enabled: isClickable,
        style: TextStyle(
            fontSize: 18,
            color:
                // Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                Color(0xff333739)
            // : Colors.white,
            ),
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color:
                      // color: Provider.of<ThemeProvider>(context).themeMode ==
                      //         ThemeMode.light
                      Color(0xff333739)
                  // : Colors.white,
                  )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  // color: Provider.of<ThemeProvider>(context).themeMode ==
                  //         ThemeMode.light
                  color: Color(0xff333739)
                  // : Colors.deepOrange,
                  )),
          labelStyle: TextStyle(
              color:
                  // Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                  Color(0xff333739)
              // : Colors.white,
              ),
          labelText: label,

          prefixIcon: Icon(prefix,
              color:
                  // Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                  Color(0xff333739)
              // : Colors.white,
              // color: DocCubit.get(context).isDark
              //   ? Colors.white
              // : Colors.black.withOpacity(.5),
              ),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(
                    suffix, color: Colors.black,
                    // color: DocCubit.get(context).isDark
                    //   ? Colors.white
                    // : Colors.black.withOpacity(.5),
                  ),
                )
              : null,

          //underLine ? UnderlineInputBorder() : InputBorder.none,
        ),
      ),
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()), // not very important but should but it
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 35,
          child: Text(
            '${model['time']}',
            style: GoogleFonts.cairo(
                fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '${model['date']}',
                style: GoogleFonts.cairo(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 16,
        ),
        IconButton(
            onPressed: () {
              ToDoAppCubit.get(context)
                  .updateData(status: 'Done', id: model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              ToDoAppCubit.get(context)
                  .updateData(status: 'Archived', id: model['id']);
            },
            icon: Icon(
              Icons.archive_rounded,
              color: Colors.black54,
            ))
      ]),
    ),

    onDismissed: (direction) {
      ToDoAppCubit.get(context).deleteData(id: model['id']);
    },
  );
}

Widget tasksScreen({@required List<Map>? tasks}) {
  return ConditionalBuilder(
    condition: tasks!.length > 0,
    builder: (context) => ListView.separated(
        // itemBuilder: (context, index) => tasks.length == 0
        //     ? Center(
        //         child: CircularProgressIndicator(
        //           color: Colors.red,
        //         ),
        //       ):
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[500],
              ),
            ),
        itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/add item.gif'),
          Text(
            'NO Tasks Yet Please Add Some Tasks !',
            style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 187, 183, 183)),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
