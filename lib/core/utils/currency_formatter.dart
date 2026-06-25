import 'package:afterhours/core/constants/app_constants.dart';

String formatIdr(num amount) {
  final value = amount.round().toString();
  final formatted = value.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );

  return '${AppConstants.currencyPrefix} $formatted';
}
