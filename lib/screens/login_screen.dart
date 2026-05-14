import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nimController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    final nim = _nimController.text.trim();
    if (nim.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your NIM')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Call the login method from our auth service
    final success = await _authService.login(nim);
    
    setState(() => _isLoading = false);

    if (success && mounted) {
      // If login is successful, the token is already saved by the service.
      // Navigate to the Home Screen and remove the login screen from the stack.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your NIM.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PBM 2026 Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nimController,
              decoration: const InputDecoration(
                labelText: 'NIM (Username & Password)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nimController.dispose();
    super.dispose();
  }
}
