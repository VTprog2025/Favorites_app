
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> confirmClear(
      BuildContext context,
      FavoritesProvider provider,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Favorites?'),
          content: const Text(
            'This will remove all saved cities, hobbies, '
                'and books from your favorites.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await provider.clearFavorites();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favorites cleared'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 24),

              Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text(
                    'Save your preferred appearance',
                  ),
                  secondary: const Icon(
                    Icons.dark_mode,
                  ),
                  value: provider.isDarkMode,
                  onChanged: provider.toggleDarkMode,
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                  ),
                  title: const Text('Clear Favorites'),
                  subtitle: const Text(
                    'Remove all saved favorite items',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    confirmClear(context, provider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
