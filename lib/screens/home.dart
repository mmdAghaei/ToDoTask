import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todotask/screens/api.dart';
import 'package:todotask/screens/editCard.dart';
import 'package:todotask/screens/taskClass.dart';
import 'package:todotask/utils/color.dart';
import 'package:todotask/utils/fonts.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TaskService taskService = TaskService();
  List<Task> tasks = [];
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    isOnline = connectivityResult != ConnectivityResult.none;

    if (isOnline) {
      try {
        List<Task> fetchedTasks = await taskService.getTasks();
        var box = Hive.box<Task>('tasksBox');
        await box.clear();
        await box.addAll(fetchedTasks);
        setState(() {
          tasks = fetchedTasks;
        });
      } catch (e) {
        print("Error fetching tasks: $e");
      }
    } else {
      var box = Hive.box<Task>('tasksBox');
      setState(() {
        tasks = box.values.toList();
      });
    }
  }

  Future<void> _addTask() async {
    Task newTask =
        Task(_title.text, _currentSegment == 0, DateTime.now(), false);
    await taskService.createTask(newTask);
    _loadTasks();
    Navigator.pop(context);
  }

  Future<void> _toggleTaskStatus(Task task) async {
    task.status = !task.status;
    await taskService.updateTask(task.id!, task);
    _loadTasks();
  }

  TextEditingController _title = TextEditingController();
  int _currentSegment = 1;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: white,
      onRefresh: _loadTasks,
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: white,
              foregroundColor: black,
              shape: CircleBorder(),
              child: Icon(CupertinoIcons.delete_solid),
              onPressed: () {},
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: white,
              foregroundColor: black,
              shape: CircleBorder(),
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return _buildAddTaskSheet();
                    });
              },
            ),
          ],
        ),
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
          title: Text(
            "Home",
            style: TextStyle(
                fontSize: 90.w, color: white, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: tasks.isEmpty
            ? Center(
                child:
                    Text("No tasks available.", style: TextStyle(color: white)))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return _buildTaskCard(task);
                },
              ),
      ),
    );
  }

  Widget _buildAddTaskSheet() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100), topRight: Radius.circular(100)),
      ),
      width: double.infinity,
      height: 950.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50),
        child: Column(
          children: [
            SizedBox(height: 40),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: _title,
                decoration: InputDecoration(
                  label: Text("Text"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CupertinoSlidingSegmentedControl(
              children: {0: Text('Mmd'), 1: Text('Ainaz')},
              onValueChanged: (value) {
                setState(() {
                  _currentSegment = value as int;
                });
              },
              groupValue: _currentSegment,
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _addTask,
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                backgroundColor: WidgetStatePropertyAll(black),
                foregroundColor: WidgetStatePropertyAll(white),
              ),
              child: Text(
                "Add",
                style:
                    TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      width: 1011.w,
      height: 233.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: fillCard,
        border: Border.all(color: task.person ? blue : pink, width: .5),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => EditCard(myCard: task)),
          );
          _loadTasks();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => _toggleTaskStatus(task),
              icon: Icon(
                task.status ? Icons.done : Icons.cancel_outlined,
                color: task.person ? blue : pink,
                size: 90.w,
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                task.title,
                style: TextStyle(
                    color: white,
                    fontSize: 50.w,
                    fontFamily: Fonts.VazirBlack.fontFamily),
              ),
            ),
            Icon(
              task.person ? Icons.man_2_outlined : Icons.girl,
              color: task.person ? blue : pink,
              size: 90.w,
            )
          ],
        ),
      ),
    );
  }
}
