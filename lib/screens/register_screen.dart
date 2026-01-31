import 'package:flutter/material.dart';
import 'package:wisata_kuliner/screens/login_screen.dart';
import 'package:wisata_kuliner/services/auth_service.dart';
import 'package:wisata_kuliner/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'user';
  String? errorMessage;

  Future<void> handleRegister() async {
    try {
      final credential = await AuthService().registerUser(
        emailController.text,
        passwordController.text,
      );
      await UserService().createUser(
        credential.user!.uid,
        cityController.text,
        emailController.text,
        nameController.text,
        role,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Column(
          children: [
            Text(
              'Daftar Sekarang',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Silakan buat akun untuk memulai.'),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Pengguna'),
                  selected: role == 'user',
                  onSelected: (value) {
                    setState(() {
                      role = 'user';
                    });
                  },
                ),
                SizedBox(width: 16),
                ChoiceChip(
                  label: Text('Pemilik'),
                  selected: role == 'owner',
                  onSelected: (value) {
                    setState(() {
                      role = 'owner';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nama',
                prefixIcon: Icon(Icons.people_outline),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: 'Kota',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            if (errorMessage != null)
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: handleRegister, child: Text('Daftar')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Masuk'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
