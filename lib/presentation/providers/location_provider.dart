import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/location/search_locations_usecase.dart';
import 'database_provider.dart';

final searchLocationsUseCaseProvider = Provider((ref) {
  return SearchLocationsUseCase(ref.watch(locationRepositoryProvider));
});

class LocationSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String q) => state = q;
}

final locationSearchQueryProvider =
    NotifierProvider<LocationSearchQuery, String>(LocationSearchQuery.new);

final locationSearchProvider =
    FutureProvider.autoDispose<List<Location>>((ref) async {
  final query = ref.watch(locationSearchQueryProvider);
  if (query.trim().length < 2) return [];
  await Future.delayed(const Duration(milliseconds: 400));
  return ref.read(searchLocationsUseCaseProvider).call(query);
});
