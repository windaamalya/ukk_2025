import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/login.dart';

String supabaseUrl = 'https://mltamjiypuvthtzpplxc.supabase.co';
String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sdGFtaml5cHV2dGh0enBwbHhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTUyOTQsImV4cCI6MjA1NDk5MTI5NH0.A6d_9iuAsTFCKjeEA7Ph6Wv9VCJ9J2-klKqX8FM0htA';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
  url: 'https://mltamjiypuvthtzpplxc.supabase.co',
 anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sdGFtaml5cHV2dGh0enBwbHhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTUyOTQsImV4cCI6MjA1NDk5MTI5NH0.A6d_9iuAsTFCKjeEA7Ph6Wv9VCJ9J2-klKqX8FM0htA'
 );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}