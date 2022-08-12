import 'package:enerhisayo_admin/screens/admin_home_page.dart';
import 'package:enerhisayo_admin/screens/exercises/add_exercise.dart';
import 'package:enerhisayo_admin/screens/exercises/edit_exercise.dart';
import 'package:enerhisayo_admin/screens/exercises/exercises.dart';
import 'package:enerhisayo_admin/screens/schedule/daily_requirements/add_daily_requirements.dart';
import 'package:enerhisayo_admin/screens/schedule/daily_requirements/admin_daily_requirements.dart';
import 'package:enerhisayo_admin/screens/schedule/daily_requirements/edit_daily_requirements.dart';
import 'package:enerhisayo_admin/screens/schedule/daily_schedule/add_daily_exercise.dart';
import 'package:enerhisayo_admin/screens/schedule/daily_schedule/daily_schedule.dart';
import 'package:enerhisayo_admin/screens/schedule/daily_schedule/edit_daily_exercise.dart';
import 'package:enerhisayo_admin/screens/schedule/schedule.dart';
import 'package:enerhisayo_admin/screens/signin/auth_page.dart';
import 'package:enerhisayo_admin/screens/user_progress/user_progress.dart';
import 'package:enerhisayo_admin/screens/warmup_exercises/add_warmup_exercises.dart';
import 'package:enerhisayo_admin/screens/warmup_exercises/edit_warmup_exercises.dart';
import 'package:enerhisayo_admin/screens/warmup_exercises/warmup_exercises.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/services.dart';
import 'models/LocalSharedPref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA02v_GVaAXaC85JM9YMuAQDxJaa7yhDak",
      appId: "1:311955706534:android:4144da1daf8e5eac745a67",
      messagingSenderId: "311955706534",
      projectId: "enerhisayo-a7572",
      storageBucket: "enerhisayo-a7572.appspot.com",
    ),
  );
  await LocalSharedPreferences.init();
      
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
  ));
  runApp( const MyApp());
}

  final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Enerhisayo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color(0xFFF1F1F1),
        splashFactory: InkRipple.splashFactory
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } 
          else if(snapshot.hasError){
            return const Center(child: Text("Something Went Wrong"));
          }
          else if(snapshot.hasData){
            return const AdminHomePage();
          }
          else{
            return const AuthPage();
          }
        }
      ),
      routes: {
        // Admin
        AdminExercisePage.routeName : (BuildContext context) => AdminExercisePage(),
        EditExercise.routeName : (BuildContext context) => EditExercise(),
        AddExercise.routeName : (BuildContext context) => AddExercise(),
        AdminWarmupPage.routeName : (BuildContext context) => AdminWarmupPage(),
        AddWarmupExercises.routeName : (BuildContext context) => AddWarmupExercises(),
        EditWarmupExercise.routeName : (BuildContext context) => EditWarmupExercise(),
        Schedule.routeName : (BuildContext context) => Schedule(),
        AddDailyExercise.routeName : (BuildContext context) => AddDailyExercise(),
        DailySchedule.routeName : (BuildContext context) => DailySchedule(),
        EditDailyExercise.routeName : (BuildContext context) => EditDailyExercise(),
        EditDailyRequirements.routeName : (BuildContext context) => EditDailyRequirements(),
        AdminDailyRequirements.routeName : (BuildContext context) => AdminDailyRequirements(),
        AddDailyRequirements.routeName : (BuildContext context) => AddDailyRequirements(),
        UserProgressPage.routeName : (BuildContext context) => UserProgressPage(),
      },
    );
  }
}
