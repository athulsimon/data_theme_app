import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_theme_app/features/offline_data/provider/data_provider.dart';
import 'package:data_theme_app/features/pages/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class UserPostsPage extends ConsumerStatefulWidget {
  const UserPostsPage({super.key});

  @override
  ConsumerState<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends ConsumerState<UserPostsPage> {
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.expand(
      (list) => list,
    );
    _connectivityStream.listen((result) {
      if (result != ConnectivityResult.none) {
        ref.invalidate(dataProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dataProvider);
            },
            child: items.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 80),
                      Lottie.asset(
                        'lib/assets/animations/no_data.json',
                        height: 250,
                      ),
                      const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final post = items[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha((255 * 0.1).toInt()),
                            child: Text(
                              post.id.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            post.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              post.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailPage(post: post),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
