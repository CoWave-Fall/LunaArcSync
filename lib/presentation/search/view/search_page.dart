import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luna_arc_sync/core/di/injection.dart';

import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/documents/view/document_detail_page.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart';
import 'package:luna_arc_sync/presentation/search/cubit/search_cubit.dart';
import 'package:luna_arc_sync/presentation/search/cubit/search_state.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchCubit>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    return Scaffold(
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      appBar: AppBar(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.searchDocumentsPagesContent ?? 'Search documents, pages, content...', 
            border: InputBorder.none,
          ),
          onChanged: (query) {
            context.read<SearchCubit>().performSearch(query);
          },
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Text(AppLocalizations.of(context)?.startTypingToSearch ?? 'Start typing to search.'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            failure: (error) => Center(
              child: Text('${AppLocalizations.of(context)?.searchFailed ?? 'Search failed'}: $error'),
            ),
            success: (results) {
              if (results.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)?.noResultsFound ?? 'No results found.'),
                );
              }
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final isPage = item.pageId != null;
                  return ListTile(
                    leading: Icon(isPage ? Icons.article : Icons.folder),
                    title: Text(isPage ? item.pageTitle! : item.documentTitle),
                    subtitle: Text(
                      'Found in: ${item.documentTitle}\n${item.matchSnippet}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      if (isPage) {
                        // Navigate to Page Detail Page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PageDetailPage(pageId: item.pageId!),
                        ));
                      } else {
                        // Navigate to Document Detail Page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DocumentDetailPage(documentId: item.documentId),
                        ));
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
