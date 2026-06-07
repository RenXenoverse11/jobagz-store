import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

final productRepositoryProvider =
    Provider<ProductRepository>((ref) => ProductRepository());

class ProductSearchNotifier extends AsyncNotifier<List<Product>> {
  late ProductRepository _repo;
  String _lastQuery = '';

  @override
  Future<List<Product>> build() async {
    _repo = ref.read(productRepositoryProvider);
    return _repo.search('');
  }

  Future<void> search(String query) async {
    _lastQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.search(query));
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    await search(_lastQuery); // refresh list after delete
  }
}

final productSearchProvider =
    AsyncNotifierProvider<ProductSearchNotifier, List<Product>>(
  ProductSearchNotifier.new,
);
