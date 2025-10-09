import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/search_repository.dart';
import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final ISearchRepository _repository;
  Timer? _debounce;

  SearchCubit(this._repository) : super(const SearchState.initial());

  void performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(const SearchState.loading());
      try {
        final results = await _repository.search(query);
        emit(SearchState.success(results));
      } catch (e) {
        emit(SearchState.failure(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
