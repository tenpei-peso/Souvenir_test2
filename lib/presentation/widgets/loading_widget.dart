import 'package:flutter/material.dart';

/// ローディング状態表示 Widget
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message = 'ロード中...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}
