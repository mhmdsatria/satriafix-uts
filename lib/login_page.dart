import 'package:flutter/material.dart';
import 'news_page.dart'; // Pastikan ini ada, untuk mengakses NewsPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String correctUsername = "satria";
  final String correctPassword = "asd123";

  void _login() {
    if (usernameController.text == correctUsername &&
        passwordController.text == correctPassword) {
      // Login berhasil, navigasikan ke halaman berita
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NewsPage()), // Pastikan NewsPage diimpor
      );
    } else {
      // Tampilkan pesan kesalahan jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username atau Password salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          true, // Menyesuaikan tampilan saat keyboard muncul
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1F74EB),
                Color(0xFF3EC1FF)
              ], // Linear gradient colors
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HMTI',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            // Gambar Logo
            Image.asset(
              'assets/images/logo.png',
              width: 240,
              height: 240,
            ),
            SizedBox(height: 20),
            // Form login
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF1F74EB),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
