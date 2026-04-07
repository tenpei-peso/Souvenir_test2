import 'package:flutter/material.dart';

/// お土産がない場合の表示 Widget
class MySouvenirEmptyWidget extends StatelessWidget {
  const MySouvenirEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'お土産がまだ登録されていません',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'おすすめのお土産を追加してみましょう',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: フォームページへ遷移
            },
            icon: const Icon(Icons.add),
            label: const Text('新しいお土産を追加'),
          ),
        ],
      ),
    );
  }
}
