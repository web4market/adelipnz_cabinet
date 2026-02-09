import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Профиль пользователя',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProfileItem('Логин', user.login),
                    if (user.email != null)
                      _buildProfileItem('Email', user.email!),
                    if (user.firstName != null)
                      _buildProfileItem('Имя', user.firstName!),
                    if (user.lastName != null)
                      _buildProfileItem('Фамилия', user.lastName!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Здесь можно добавить другие разделы личного кабинета
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Настройки'),
                onTap: () {
                  // Переход к настройкам
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выход'),
          content: const Text('Вы уверены, что хотите выйти?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthProvider>().logout();
              },
              child: const Text('Выйти'),
            ),
          ],
        );
      },
    );
  }
}