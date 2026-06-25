import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/home/presentation/providers/home_provider.dart';
import 'package:afterhours/features/home/presentation/widgets/product_card.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:afterhours/features/product/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProductScreen extends StatelessWidget {
  final String category;
  const CategoryProductScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(formatCategoryLabel(category))),
    body: PagedProductGrid(category: category),
  );
}

class PagedProductGrid extends ConsumerStatefulWidget {
  final String? category;
  final String query;
  const PagedProductGrid({super.key, this.category, this.query = ''});

  @override
  ConsumerState<PagedProductGrid> createState() => _PagedProductGridState();
}

class _PagedProductGridState extends ConsumerState<PagedProductGrid> {
  final _scrollController = ScrollController();
  final List<ProductModel> _items = [];
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load(reset: true);
  }

  @override
  void didUpdateWidget(covariant PagedProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.category != widget.category) {
      _load(reset: true);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading || (!reset && !_hasMore)) return;
    if (reset) {
      _page = 1;
      _hasMore = true;
      _items.clear();
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref
        .read(productRepositoryProvider)
        .getProducts(
          page: _page,
          category: widget.category,
          keywords: widget.query.trim().isEmpty
              ? null
              : widget.query.trim().split(RegExp(r'\s+')),
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess(:final data):
        setState(() {
          _items.addAll(data.products);
          _hasMore = data.hasMore;
          _page++;
          _loading = false;
        });
      case ApiFailure(:final message):
        setState(() {
          _error = message;
          _loading = false;
        });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty && _loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty && _error != null) {
      return Center(child: Text(_error!, style: AppTextStyles.errorMessage));
    }
    if (_items.isEmpty) return const Center(child: Text('No products found'));

    return RefreshIndicator(
      onRefresh: () => _load(reset: true),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: _items.length + (_loading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return ProductCard(
            product: _items[index],
            width: double.infinity,
            height: double.infinity,
          );
        },
      ),
    );
  }
}
