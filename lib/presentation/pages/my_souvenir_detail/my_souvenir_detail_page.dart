import 'package:flutter/material.dart';
import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/presentation/extensions/souvenir_category_extension.dart';

/// お土産詳細ページ
class MySouvenirDetailPage extends StatelessWidget {
  const MySouvenirDetailPage({super.key, required this.souvenir});

  static const name = 'mySouvenirDetail';
  static const path = '/my-souvenirs/:id';

  final MySouvenir souvenir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お土産詳細'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 編集ページへ遷移
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 画像セクション
            if (souvenir.imageUrls.isNotEmpty)
              SizedBox(
                height: 300,
                width: double.infinity,
                child: PageView(
                  children: [
                    for (final url in souvenir.imageUrls)
                      Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                  ],
                ),
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                color: souvenir.category.badgeColor,
                child: Center(
                  child: Icon(
                    souvenir.category.icon,
                    size: 80,
                    color: souvenir.category.color,
                  ),
                ),
              ),
            // 情報セクション
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名前と値段
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          souvenir.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Text(
                        '¥${souvenir.price}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // カテゴリ
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: souvenir.category.badgeColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          souvenir.category.icon,
                          size: 16,
                          color: souvenir.category.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          souvenir.category.label,
                          style: TextStyle(
                            color: souvenir.category.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 説明
                  Text('説明', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    souvenir.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  // 購入場所
                  if (souvenir.purchaseLocation != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      '購入場所',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      souvenir.purchaseLocation!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  // タグ
                  if (souvenir.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('タグ', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final tag in souvenir.tags) Chip(label: Text(tag)),
                      ],
                    ),
                  ],
                  // メタ情報
                  const SizedBox(height: 24),
                  Text(
                    '登録日: ${souvenir.createdAt.toLocal()}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
