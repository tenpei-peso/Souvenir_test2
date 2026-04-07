import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test2/presentation/pages/my_souvenir_list/my_souvenir_list_provider.dart';
import 'package:test2/presentation/pages/my_souvenir_list/my_souvenir_list_state.dart';
import 'package:test2/presentation/pages/my_souvenir_list/widget/my_souvenir_list_tile.dart';
import 'package:test2/presentation/pages/my_souvenir_list/widget/my_souvenir_empty_widget.dart';
import 'package:test2/presentation/widgets/loading_widget.dart';
import 'package:test2/presentation/widgets/error_retry_widget.dart';
import 'package:test2/presentation/pages/my_souvenir_form/my_souvenir_form_page.dart';
import 'package:test2/presentation/pages/my_souvenir_detail/my_souvenir_detail_page.dart';

/// お土産一覧ページ
class MySouvenirListPage extends ConsumerWidget {
  const MySouvenirListPage({super.key});

  static const name = 'mySouvenirList';
  static const path = '/my-souvenirs';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mySouvenirListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイお土産'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(mySouvenirListProvider.notifier).reload();
            },
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(MySouvenirFormPage.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MySouvenirListState state,
  ) {
    if (state.isLoading) {
      return const LoadingWidget(message: 'お土産を読み込み中...');
    }

    if (state.error != null) {
      return ErrorRetryWidget(
        message: state.error ?? 'エラーが発生しました',
        onRetry: () {
          ref.read(mySouvenirListProvider.notifier).reload();
        },
      );
    }

    if (state.souvenirs.isEmpty) {
      return const MySouvenirEmptyWidget();
    }

    return ListView.builder(
      itemCount: state.souvenirs.length,
      itemBuilder: (context, index) {
        final souvenir = state.souvenirs[index];
        return MySouvenirListTile(
          souvenir: souvenir,
          onTap: () {
            context.pushNamed(
              MySouvenirDetailPage.name,
              extra: souvenir,
            );
          },
          onDelete: () async {
            try {
              await ref
                  .read(mySouvenirListProvider.notifier)
                  .deleteSouvenir(souvenir.id);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('削除しました')));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
              }
            }
          },
        );
      },
    );
  }
}
