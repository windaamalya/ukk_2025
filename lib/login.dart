import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

String supabaseUrl = 'https://mltamjiypuvthtzpplxc.supabase.co';
String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sdGFtaml5cHV2dGh0enBwbHhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTUyOTQsImV4cCI6MjA1NDk5MTI5NH0.A6d_9iuAsTFCKjeEA7Ph6Wv9VCJ9J2-klKqX8FM0htA';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mltamjiypuvthtzpplxc.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sdGFtaml5cHV2dGh0enBwbHhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTUyOTQsImV4cCI6MjA1NDk5MTI5NH0.A6d_9iuAsTFCKjeEA7Ph6Wv9VCJ9J2-klKqX8FM0htA'
    );
    runApp(LoginPage());
}


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final UserNameController = TextEditingController();
  final PasswordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _Login() async {
    final UserName = UserNameController.text;
    final Password = PasswordController.text;

    try {
      final response = await supabase
        .from('user')
        .select('UserName, Password')
        .eq('UserName', UserName)
        .single();

    if (response !=null && response ['Password'] == Password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text ('Login Berhasil')),
      );
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username atau Password salah!')),
      );
    }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan: $e')),
      );
    }
  }

   @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text("Login"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 100,
          ),
          Center(
            child: Text("Login", style: TextStyle(fontSize: 40, color: Colors.blue[300])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: UserNameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  icon: Icon(Icons.person, color: Colors.blue[300]),
                  fillColor:  Colors.blue[50],
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
           ),
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: PasswordController,
                decoration: InputDecoration(
                  labelText: "Password",
                 icon: Icon(Icons.vpn_key_sharp, color: Colors.blue[300]),
                 fillColor: Colors.blue[50],
                 filled: true,
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
           ),
           ),
           Center(
            child: ElevatedButton(
              onPressed: _Login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                fixedSize: Size(100, 40),
              ),
            ),
           ),
        ],
      ),
    );
  }
}
 