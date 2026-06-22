import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:afterhours/features/profile/presentation/providers/profile_provider.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_back_button.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileInfoScreen extends ConsumerWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return profile.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
            style: AppTextStyles.errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (profile) => ProfileInfoForm(profile: profile),
    );
  }
}

class ProfileInfoForm extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const ProfileInfoForm({super.key, required this.profile});

  @override
  ConsumerState<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends ConsumerState<ProfileInfoForm> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(profileProvider.notifier).saveName(_nameController.text);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar.error(error.toString().replaceFirst('Exception: ', '')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(AppSnackBar.info('Profile saved'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text('MY PROFILE', style: AppTextStyles.displayTitle),
                  const SizedBox(height: 52),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(26, 30, 26, 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Information',
                          style: AppTextStyles.bodyMono.copyWith(
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 38),
                        ProfileInputField(
                          controller: _nameController,
                          label: 'NAME',
                        ),
                        const SizedBox(height: 16),
                        ProfileActionButton(
                          label: _isSaving ? 'SAVING' : 'SAVE',
                          onPressed: _isSaving ? null : _save,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: ProfileBackButton(),
          ),
        ],
      ),
    );
  }
}
