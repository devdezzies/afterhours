import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:afterhours/features/profile/presentation/screens/profile_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  testWidgets('map picker shows no selected pin by default', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: AddressMapPicker(selectedPoint: null, onChanged: (_) {}),
        ),
      ),
    );

    expect(find.text('MAP PIN'), findsOneWidget);
    expect(find.text('NO PIN SELECTED'), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsNothing);
  });

  testWidgets('map picker shows saved coordinates as initial pin', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: AddressMapPicker(
            selectedPoint: const LatLng(-6.2, 106.8),
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('-6.200000, 106.800000'), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });

  testWidgets('address form pre-fills saved address and map data', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const ProfileAddressForm(
            profile: ProfileModel(
              name: 'Customer',
              email: 'customer@example.com',
              address: 'Jalan Satu',
              city: 'Jakarta',
              countryRegion: 'Indonesia',
              postcode: '12345',
              phoneNumber: '0812',
              latitude: -6.2,
              longitude: 106.8,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Jalan Satu'), findsOneWidget);
    expect(find.text('Jakarta'), findsOneWidget);
    expect(find.text('Indonesia'), findsOneWidget);
    expect(find.text('12345'), findsOneWidget);
    expect(find.text('0812'), findsOneWidget);
    expect(find.text('-6.200000, 106.800000'), findsOneWidget);
  });
}
