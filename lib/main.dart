import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

import 'pages/get_started.dart';
import 'pages/home_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/add_recipe.dart';
import 'pages/edit_recipe.dart';
import 'pages/detail_recipe.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  // Buka box untuk simpan session
  await Hive.openBox('sessionBox');

  runApp(const SimpleRecipeKeeperApp());
}

class SimpleRecipeKeeperApp extends StatelessWidget {
  const SimpleRecipeKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Recipe Keeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/get-started',
      routes: {
        '/get-started': (context) => const GetStartedPage(),
        '/home': (context) => const HomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/add-recipe': (context) => const AddRecipePage(),
        '/edit-recipe': (context) => const EditRecipePage(),
        '/detail-recipe': (context) => const DetailRecipePage(),
      },
    );
  }
}
