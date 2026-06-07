import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductRepository {
  final _db = Supabase.instance.client.from('products');

  Future<List<Product>> search(String query) async {
    try {
      final data = query.trim().isEmpty
          ? await _db.select().order('name')
          : await _db
              .select()
              .ilike('name', '%${query.trim()}%')
              .order('name');

      return (data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Search failed: ${e.message}');
    }
  }

  Future<Product> create(Map<String, dynamic> payload) async {
    try {
      final data = await _db.insert(payload).select().single();
      return Product.fromJson(data);
    } on PostgrestException catch (e) {
      throw Exception('Create failed: ${e.message}');
    }
  }

  Future<Product> update(int id, Map<String, dynamic> payload) async {
    try {
      final data = await _db.update(payload).eq('id', id).select().single();
      return Product.fromJson(data);
    } on PostgrestException catch (e) {
      throw Exception('Update failed: ${e.message}');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _db.delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Delete failed: ${e.message}');
    }
  }
}
