import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todotask/screens/api.dart'; // اضافه کردن API
import 'package:todotask/screens/taskClass.dart';
import 'package:todotask/utils/color.dart';
import 'package:todotask/utils/fonts.dart';

class EditCard extends StatefulWidget {
  final Task myCard;
  const EditCard({super.key, required this.myCard});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  TextEditingController _myTextField = TextEditingController();
  final TaskService _taskService = TaskService(); // نمونه از API

  @override
  void initState() {
    super.initState();
    _myTextField.text = widget.myCard.title;
  }

  Future<void> _saveTask() async {
    String newTitle = _myTextField.text;
    Task updatedTask = Task(
      newTitle,
      widget.myCard.person,
      widget.myCard.date,
      widget.myCard.status,
      id: widget.myCard.id, // اطمینان از ارسال ID
    );

    try {
      await _taskService.updateTask(widget.myCard.id!, updatedTask);
      Navigator.pop(context, updatedTask); // ارسال نتیجه به صفحه قبل
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطا در ذخیره‌سازی")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        foregroundColor: white,
        actions: [
          IconButton(
            onPressed: _saveTask, // دکمه ذخیره
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.myCard.date.year}/${widget.myCard.date.month}/${widget.myCard.date.day}",
                style: TextStyle(color: white.withOpacity(.3)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _myTextField,
                  maxLines: 7,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      color: white,
                      fontFamily: Fonts.ExtraBold.fontFamily,
                      fontSize: 70.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
