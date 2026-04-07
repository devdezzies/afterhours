# AfterHours (Mobile App)

A Flutter-based mobile app with modular feature folders and shared core utilities. The project uses Riverpod for state management, GoRouter for navigation, Dio for networking, and Hive/SharedPreferences for local storage.

## Features (by module)

- Auth
- Home
- Product
- Cart
- Order
- Profile
- Search

## Tech Stack

- Flutter, Dart
- State management: Riverpod
- Routing: GoRouter
- Networking: Dio
- Local storage: Hive, SharedPreferences

## Project Structure

```
lib/
	main.dart
	core/
		constants/
		router/
		theme/
		utils/
		widgets/
	features/
		auth/
		cart/
		home/
		order/
		product/
		profile/
		search/
```

## Requirements

- Flutter SDK (Dart SDK ^3.11.4)

## Getting Started

1. Install dependencies:
	 ```bash
	 flutter pub get
	 ```
2. Run the app:
	 ```bash
	 flutter run
	 ```

## Build

- Android APK:
	```bash
	flutter build apk
	```
- Android App Bundle:
	```bash
	flutter build appbundle
	```
- iOS (macOS only):
	```bash
	flutter build ios
	```

## Testing

```bash
flutter test
```

## Notes

- Custom fonts are configured in [pubspec.yaml](pubspec.yaml).
