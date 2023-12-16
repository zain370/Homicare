import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:homicare/pages/admin/home_editor_admin.dart';
import 'package:homicare/api/notifications.dart';
import 'package:homicare/pages/home_page_editor.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homicare/firebase_options.dart';
import 'package:homicare/pages/start.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
    await FirebaseApi().initNotifications();
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, loginSnapshot) {
          if (loginSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white
              ),
              height: 30,
              child: Lottie.asset('assets/images/loading.json', repeat: true),
            );
          } else {
            return FutureBuilder(
              future: checkRoleStatus(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white
                    ),
                  height: 30,
                  child: Lottie.asset('assets/images/loading.json', repeat: true),
                  );
                } else {
                  bool isLoggedIn = loginSnapshot.data as bool;
                  bool isAdmin = roleSnapshot.data as bool;

                  if (isLoggedIn) {
                    if (isAdmin) {
                      return const MyHomePageAdmin();
                    } else {
                      return const MyHomePage();
                    }
                  } else {
                    return const StartPage();
                  }
                }
              },
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate asynchronous operation
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loggedIn") ?? false;
  }

  Future<bool> checkRoleStatus() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate asynchronous operation
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isAdmin") ?? false;
  }
}
