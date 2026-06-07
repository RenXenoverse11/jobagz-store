import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  final int? productId;
  const AddProductScreen({super.key, this.productId});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  bool _isLoading = false;
  bool get _isEditing => widget.productId != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final payload = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'price': double.parse(_priceCtrl.text.trim()),
      if (_categoryCtrl.text.trim().isNotEmpty)
        'category': _categoryCtrl.text.trim(),
      if (_stockCtrl.text.trim().isNotEmpty)
        'stock': int.parse(_stockCtrl.text.trim()),
    };

    try {
      final repo = ref.read(productRepositoryProvider);
      if (_isEditing) {
        await repo.update(widget.productId!, payload);
      } else {
        await repo.create(payload);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Na-update na!' : '${_nameCtrl.text.trim()} ay naidagdag na!',
            ),
            backgroundColor: Colors.green.shade700,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.navyBlue,
        foregroundColor: Colors.white,
        title: Text(
          _isEditing ? 'I-edit ang Produkto' : 'Mag-add ng Produkto',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.navyBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.navyBlue.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  const Text('🛍️', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'I-edit ang produkto' : 'Bagong produkto',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: AppTheme.navyBlue,
                          ),
                        ),
                        Text(
                          'Ilagay ang mga detalye ng produkto',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel('Pangalan ng Produkto *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecor(
                hint: 'Argentina Corned Beef',
                icon: Icons.inventory_2_outlined,
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ilagay ang pangalan' : null,
            ),
            const SizedBox(height: 18),

            _buildLabel('Presyo (₱) *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _priceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecor(
                hint: '39.75',
                icon: Icons.payments_outlined,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ilagay ang presyo';
                final parsed = double.tryParse(v.trim());
                if (parsed == null) return 'Hindi valid na numero';
                if (parsed < 0) return 'Hindi pwede negative ang presyo';
                return null;
              },
            ),
            const SizedBox(height: 18),

            _buildLabel('Category (optional)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _categoryCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecor(
                hint: 'Canned Goods, Snacks, Beverages...',
                icon: Icons.category_outlined,
              ),
            ),
            const SizedBox(height: 18),

            _buildLabel('Stock (optional)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _stockCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputDecor(
                hint: '10',
                icon: Icons.numbers_outlined,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final parsed = int.tryParse(v.trim());
                if (parsed == null) return 'Numero lang ang ilagay';
                if (parsed < 0) return 'Hindi pwede negative ang stock';
                return null;
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navyBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        _isEditing ? 'I-save ang Pagbabago' : 'I-add ang Produkto',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: AppTheme.navyBlue,
        ),
      );

  InputDecoration _inputDecor({
    required String hint,
    required IconData icon,
  }) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.navyBlue, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.navyBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      );
}
