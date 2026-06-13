import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:afterhours/features/profile/presentation/providers/profile_provider.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_back_button.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileAddressScreen extends ConsumerWidget {
  const ProfileAddressScreen({super.key});

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
      data: (profile) => ProfileAddressForm(profile: profile),
    );
  }
}

class ProfileAddressForm extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const ProfileAddressForm({super.key, required this.profile});

  @override
  ConsumerState<ProfileAddressForm> createState() => _ProfileAddressFormState();
}

class _ProfileAddressFormState extends ConsumerState<ProfileAddressForm> {
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _countryRegionController;
  late final TextEditingController _postcodeController;
  late final TextEditingController _phoneNumberController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.profile.address);
    _cityController = TextEditingController(text: widget.profile.city);
    _countryRegionController = TextEditingController(
      text: widget.profile.countryRegion,
    );
    _postcodeController = TextEditingController(text: widget.profile.postcode);
    _phoneNumberController = TextEditingController(
      text: widget.profile.phoneNumber,
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _countryRegionController.dispose();
    _postcodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(profileProvider.notifier)
        .saveAddress(
          address: _addressController.text,
          city: _cityController.text,
          countryRegion: _countryRegionController.text,
          postcode: _postcodeController.text,
          phoneNumber: _phoneNumberController.text,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(AppSnackBar.info('Address saved'));
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
                  const SizedBox(height: 38),
                  Text(
                    'YOUR\nADDRESSES',
                    style: AppTextStyles.displayTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 46),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(26, 28, 26, 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      children: [
                        ProfileInputField(
                          controller: _addressController,
                          label: 'ADDRESS',
                        ),
                        const SizedBox(height: 22),
                        ProfileInputField(
                          controller: _cityController,
                          label: 'CITY',
                        ),
                        const SizedBox(height: 22),
                        ProfileInputField(
                          controller: _countryRegionController,
                          label: 'COUNTRY / REGION',
                        ),
                        const SizedBox(height: 22),
                        ProfileInputField(
                          controller: _postcodeController,
                          label: 'POSTCODE',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 22),
                        ProfileInputField(
                          controller: _phoneNumberController,
                          label: 'PHONE NUMBER',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 90),
                        ProfileActionButton(
                          label: _isSaving ? 'SAVING' : 'SAVE',
                          onPressed: _isSaving ? null : _save,
                        ),
                        const SizedBox(height: 10),
                        ProfileActionButton(
                          label: 'CANCEL',
                          isDark: true,
                          onPressed: () => context.go(AppRoutes.profile),
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
