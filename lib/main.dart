import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todotask/screens/splashScreen.dart';
import 'package:todotask/screens/taskClass.dart';
import 'package:todotask/utils/fonts.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  
  // مقداردهی اولیه Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  // باز کردن جعبه (Box)
  await Hive.openBox<Task>('tasksBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1148, 2560),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                fontFamily: Fonts.Lato.fontFamily,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: SplashScreen());
        });
  }
}
