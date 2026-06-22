import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/product/presentation/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: context.pop,
                    icon: const Icon(Icons.arrow_back, color: AppColors.red),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      style: AppTextStyles.inputValue,
                      cursorColor: AppColors.red,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) =>
                          setState(() => _query = value.trim()),
                      decoration: const InputDecoration(
                        hintText: 'SEARCH PRODUCT',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _query.isEmpty
                  ? Center(
                      child: Text(
                        'Type then press enter',
                        style: AppTextStyles.helperText.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : PagedProductGrid(key: ValueKey(_query), query: _query),
            ),
          ],
        ),
      ),
    );
  }
}
