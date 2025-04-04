import 'package:flutter/material.dart';
import '../services/auth-service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: AuthService.getUserId(),
              builder: (context, snapshot) {
                return Text(
                  'Utilisateur #${snapshot.data ?? 'inconnu'}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
