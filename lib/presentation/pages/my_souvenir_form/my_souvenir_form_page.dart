import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/domain/entities/souvenir_category.dart';
import 'package:test2/presentation/pages/my_souvenir_form/widget/souvenir_category_selector.dart';

/// お土産作成/編集フォームページ
class MySouvenirFormPage extends HookConsumerWidget {
  const MySouvenirFormPage({super.key, this.souvenir});

  static const name = 'mySouvenirForm';
  static const path = '/my-souvenirs/form';

  /// 編集時のみ指定
  final MySouvenir? souvenir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = souvenir != null;

    // Form state
    final nameController = useTextEditingController(text: souvenir?.name ?? '');
    final descriptionController = useTextEditingController(
      text: souvenir?.description ?? '',
    );
    final priceController = useTextEditingController(
      text: souvenir?.price.toString() ?? '',
    );
    final locationController = useTextEditingController(
      text: souvenir?.purchaseLocation ?? '',
    );

    final selectedCategory = useState<SouvenirCategory?>(souvenir?.category);
    final isSaving = useState(false);

    final formKey = useMemoized(GlobalKey<FormState>.new);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'お土産を編集' : '新しいお土産を追加')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 名前
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'お土産名 *',
                  hintText: 'お土産の名前を入力',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'お土産名は必須です';
                  }
                  if (value.length > 100) {
                    return '100文字以内で入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // カテゴリ
              SouvenirCategorySelector(
                selectedCategory: selectedCategory.value,
                onChanged: (category) {
                  selectedCategory.value = category;
                },
              ),
              const SizedBox(height: 16),
              // 説明
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '説明 *',
                  hintText: 'お土産の説明を入力',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '説明は必須です';
                  }
                  if (value.length > 500) {
                    return '500文字以内で入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 値段
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: '値段（円）*',
                  hintText: '例：2500',
                  border: OutlineInputBorder(),
                  prefixText: '¥ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '値段は必須です';
                  }
                  final price = int.tryParse(value);
                  if (price == null || price <= 0) {
                    return '1円以上の数値を入力してください';
                  }
                  if (price > 999999) {
                    return '999,999円以下で入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 購入場所
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: '購入場所（任意）',
                  hintText: '例：東京駅',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              // 保存ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving.value
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (selectedCategory.value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('カテゴリを選択してください')),
                            );
                            return;
                          }

                          isSaving.value = true;
                          try {
                            // TODO: Usecase で save を実行
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isEditing ? '更新しました' : '作成しました'),
                              ),
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('エラー: $e')),
                              );
                            }
                          } finally {
                            isSaving.value = false;
                          }
                        },
                  child: isSaving.value
                      ? const CircularProgressIndicator()
                      : Text(isEditing ? '更新' : '作成'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
