import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/auth/data/repositories/auth_repository.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); 
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false; 
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = "Passwords do not match";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"))
      );
      return;
    }

    setState(() {
      _isLoading = true; 
      _error = null;
    });

    final result = await ref.read(authRepositoryProvider).register(
      username: _nameController.text.trim(), 
      email: _emailController.text.trim(), 
      password: _passwordController.text
    ); 

    if (!mounted) return; 

    switch (result) {
      case ApiSuccess(:final data): 
        await ref.read(authProvider.notifier).setAuthenticated(
          token: data.token, 
          userId: data.userId, 
          username: data.username
        ); 
      case ApiFailure(:final message): 
        setState(() {
            _error = message;
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
                  TextSpan(text: "REGS", style: AppTextStyles.displayHero)
                ]
              )
            ), 
            const SizedBox(height: 12), 

            TextField( 
              controller: _nameController, 
              style: AppTextStyles.inputValue, 
              decoration: const InputDecoration(labelText: "USERNAME"),
            ), 
            const SizedBox(height: 12,), 

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
            const SizedBox(height: 12,),

            TextField( 
              controller: _confirmPasswordController, 
              style: _error != null ? AppTextStyles.inputValueError : AppTextStyles.inputValue,
              obscureText: true,
              decoration: InputDecoration(
                labelText : "CONFIRM PASSWORD",
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
                ) : const Text("yes, I'm in")
              )
            ), 
            const SizedBox(height: 24), 

            GestureDetector( 
              onTap: () => context.pop(), 
              child: RichText(
                text: TextSpan( 
                  children: [ 
                    TextSpan(text: "already have an account? ", style: AppTextStyles.helperText),
                    TextSpan(text: "login", style: AppTextStyles.helperLink)
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