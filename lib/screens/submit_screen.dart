import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _githubLinkController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _submitTask() async {
    final githubLink = _githubLinkController.text.trim();
    if (githubLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your GitHub link')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final success = await _apiService.submitTask(githubLink);
    
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task submitted successfully!')),
      );
      Navigator.pop(context); // Go back to Home
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Submit your PBM Practical Exam here.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _githubLinkController,
              decoration: const InputDecoration(
                labelText: 'GitHub Repository Link',
                border: OutlineInputBorder(),
                hintText: 'https://github.com/username/repo',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitTask,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Submit Task'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _githubLinkController.dispose();
    super.dispose();
  }
}
