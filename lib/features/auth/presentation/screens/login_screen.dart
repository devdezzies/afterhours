import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/auth/data/repositories/auth_repository.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); 
  bool _isLoading = false; 
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _error = null;
    }); 

    final result = await ref.read(authRepositoryProvider).login( 
      email: _emailController.text.trim(), 
      password: _passwordController.text
    );

    if (!mounted) return;

    switch(result) {
      case ApiSuccess(:final data): 
        await ref.read(authProvider.notifier).setAuthenticated(token: data.token, userId: data.userId, username: data.username);
        break;
      case ApiFailure(:final message): 
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message))
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 32), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "*", style: AppTextStyles.displayHero.copyWith(color: AppColors.red)), 
                  TextSpan(text: "LOGIN", style: AppTextStyles.displayHero)
                ]
              )
            ), 
            const SizedBox(height: 12), 

            TextField( 
              controller: _emailController, 
              style: AppTextStyles.inputValue, 
              keyboardType: TextInputType.emailAddress, 
              decoration: const InputDecoration(labelText: "EMAIL"),
            ), 
            const SizedBox(height: 12,), 

            TextField( 
              controller: _passwordController, 
              style: _error != null ? AppTextStyles.inputValueError : AppTextStyles.inputValue,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "PASSWORD", 
                labelStyle: _error != null ? AppTextStyles.fieldLabelError : AppTextStyles.fieldLabel,
              ),
            ), 
            const SizedBox(height: 48,),

            SizedBox(
              width: 260, 
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _submit(context),
                child: _isLoading ? const SizedBox( 
                  width: 16, height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2,),
                ) : const Text("PROCEED")
              )
            ), 
            const SizedBox(height: 24), 

            GestureDetector( 
              onTap: () => context.push(AppRoutes.register), 
              child: RichText(
                text: TextSpan( 
                  children: [ 
                    TextSpan(text: "don't have an account? ", style: AppTextStyles.helperText),
                    TextSpan(text: "register", style: AppTextStyles.helperLink)
                  ]
                )
              )
            ), 
          ],
        )
      )
    );
  }
}