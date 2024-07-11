import 'package:allergic_content_identifier/askforDoctor.dart';
import 'package:allergic_content_identifier/create_healthy_diet.dart';
import 'package:allergic_content_identifier/generated_report.dart';
import 'package:allergic_content_identifier/group_selection.dart';
import 'package:allergic_content_identifier/image_pick.dart';
import 'package:allergic_content_identifier/reading_prescriptions.dart';
import 'package:allergic_content_identifier/screens.dart';
import 'package:allergic_content_identifier/upload_product_screen.dart';
import 'package:allergic_content_identifier/user_account.dart';
import 'package:allergic_content_identifier/user_health_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allergic_content_identifier/login_screen.dart';
import 'package:allergic_content_identifier/user_provider.dart';
import 'package:allergic_content_identifier/register_screen.dart';
import 'package:allergic_content_identifier/upload_health_report_screen.dart';
import 'package:allergic_content_identifier/get_Started.dart';
import 'package:allergic_content_identifier/health_suggetsions.dart';
import 'package:allergic_content_identifier/group_provider.dart';
import 'dart:developer' as developer;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => GroupProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload App',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                developer.log(userProvider.isLoggedIn.toString());
                return userProvider.isLoggedIn ? const GetStartedPage() : LoginScreen();
              },
            ),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/upload_screen': (context) => const UploadScreen(),
        '/upload_health_report': (context) {
          final userId = Provider.of<UserProvider>(context).userId ?? 0;
          return UploadHealthReportScreen(userId: userId);
        },
        '/upload_health_prescription': (context) {
          final userId = Provider.of<UserProvider>(context).userId ?? 0;
          return UploadHealthPrescriptionScreen(userId: userId);
        },
        '/get_started': (context) => const GetStartedPage(),
        '/health_suggestions': (context) => const HealthSuggestionsPage(),
        '/select_groups':(context)=>SelectGroupsScreen(),
        '/upload_product_image': (context) => UploadProductImageScreen(context:context),
        '/generated_report': (context) =>  GeneratedReportScreen(),
        '/user_account': (context) {
          final userId = Provider.of<UserProvider>(context).userId ?? 0;
          return UserAccountScreen(userId: userId);
        },
        '/user_health_profile': (context) {
          final userId = Provider.of<UserProvider>(context).userId ?? 0;
          return UserHealthProfileScreen(userId: userId);
        },
        '/create_healthy_diet': (context) {
          final userId = Provider.of<UserProvider>(context).userId ?? 0;
          return CreateHealthyDietScreen(userId: userId);
        },
        '/askforDoctor': (context) => Askfordoctor(),      
        // '/screen1': (context) => const Screen1(),
        '/screen2': (context) => const Screen2(),
        // '/screen3': (context) => const Screen3(),
      },
      onGenerateRoute: 
      (settings) {
        if (settings.name == '/upload_health_report') {
          final args = settings.arguments;
          if (args is Map && args.containsKey('userId')) {
            return MaterialPageRoute(
              builder: (context) => UploadHealthReportScreen(userId: args['userId']),
            );
          }
        }
        return null;
      },
    );
  }
}
