import 'package:flutter/material.dart';

/// Profile screen for viewing and editing driver/user profile information.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    // TODO: Load from profile_provider or shared prefs
    _nameController.text = '';
    _phoneController.text = '';
    _emailController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
              if (!_isEditing) {
                // TODO: Save profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile saved')),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 56,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            readOnly: !_isEditing,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            readOnly: !_isEditing,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            readOnly: !_isEditing,
          ),
        ],
      ),
    );
  }
}
