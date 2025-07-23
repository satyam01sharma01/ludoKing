import 'package:flutter/material.dart';

/// Shows a dialog for selecting the number of players.
/// Returns 2 or 4 depending on the user's choice, or null if dismissed.
Future<int?> showSelectPlayerModal(BuildContext context) {
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Select Number of Players'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(2),
            child: const Text('Two Players'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(4),
            child: const Text('Four Players'),
          ),
        ],
      ),
    ),
  );
}
