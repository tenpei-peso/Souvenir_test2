import 'package:flutter/material.dart';
import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/presentation/extensions/souvenir_category_extension.dart';
import 'package:test2/presentation/widgets/confirm_dialog.dart';

/// お土産一覧アイテム
class MySouvenirListTile extends StatelessWidget {
  const MySouvenirListTile({
    super.key,
    required this.souvenir,
    required this.onTap,
    required this.onDelete,
  });

  final MySouvenir souvenir;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: souvenir.imageUrls.isNotEmpty
            ? Image.network(
                souvenir.imageUrls.first,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              )
            : Container(
                width: 56,
                height: 56,
                color: souvenir.category.badgeColor,
                child: Icon(
                  souvenir.category.icon,
                  color: souvenir.category.color,
                ),
              ),
        title: Text(souvenir.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: souvenir.category.badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    souvenir.category.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: souvenir.category.badgeTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '¥${souvenir.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // TODO: 編集画面へ遷移
            } else if (value == 'delete') {
              _showDeleteConfirm(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('編集')),
            const PopupMenuItem(
              value: 'delete',
              child: Text('削除', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _showDeleteConfirm(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: '削除確認',
      message: '「${souvenir.name}」を削除しますか？',
      confirmLabel: '削除',
      cancelLabel: 'キャンセル',
      isDestructive: true,
    );

    if (confirmed == true) {
      onDelete();
    }
  }
}
