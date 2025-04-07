import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  void _navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Edit User Information'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _navigateToOnboarding(context),
          ),
        ],
      ),
    );
  }
}