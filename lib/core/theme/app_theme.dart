import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds
  static const black   = Color(0xFF000000); 
  static const surface = Color(0xFF161616); 
  static const navPill = Color(0xFF1C1C1C); 

  static const white         = Color(0xFFF2F2F2); 
  static const textSecondary = Color(0xFFD9D9D9); 
  static const textMuted     = Color(0xFF808080);

  static const red    = Color(0xFFEC232B); 
  static const redDim = Color(0x24EC232B); 

  static const redError   = Color(0xFFFF0404); 
  static const redErrorBg = Color(0x24FF0404); 

  static const border = Color(0xFF2A2A2A); 

  static const success = Color(0xFF388E3C);
  static const warning = Color(0xFFF57F17);
  static const error   = redError;
}

abstract class AppFonts {
  static const ndot = 'Ndot57Caps';

  static const mono = 'JetBrainsMono';
}

abstract class AppRadius {
  static const double navPill     = 39.5; 
  static const double button      = 20.0; 
  static const double card        = 5.0;  
  static const double searchBar   = 30.5; 
  static const double chip        = 20.0; 
  static const double errorBanner = 20.0; 
}

abstract class AppTextStyles {
  static const displayBrand = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 76,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const displayHero = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const displayTitle = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const sectionLabel = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const sectionMeta = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );

  static const navLabel = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const button = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const buttonSecondary = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const fieldLabel = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const fieldLabelError = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.redError,
  );

  static const inputValue = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const inputValueError = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.redError,
  );

  static const price = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const priceSmall = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const productName = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const bodyMono = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static const orderId = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const helperText = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const helperLink = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );

  static const errorMessage = TextStyle(
    fontFamily: AppFonts.ndot,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.redError,
  );

  static const searchPrefix = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const searchQuery = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );
}

abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      primaryColor: AppColors.red,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.red,
        onPrimary: AppColors.black,       
        secondary: AppColors.white,
        onSecondary: AppColors.black,
        surface: AppColors.surface,
        onSurface: AppColors.white,
        error: AppColors.redError,
        onError: AppColors.white,
        outline: AppColors.border,
      ),


      fontFamily: AppFonts.ndot,

      textTheme: const TextTheme(
        displayLarge:  AppTextStyles.displayBrand,  
        displayMedium: AppTextStyles.displayTitle,  
        displaySmall:  AppTextStyles.displayHero,  
        titleLarge:    AppTextStyles.sectionLabel,  
        titleMedium:   AppTextStyles.productName,   
        titleSmall:    AppTextStyles.sectionMeta,   
        bodyLarge:     AppTextStyles.inputValue,    
        bodyMedium:    AppTextStyles.bodyMono,      
        bodySmall:     AppTextStyles.helperText,   
        labelLarge:    AppTextStyles.button,        
        labelMedium:   AppTextStyles.fieldLabel,    
        labelSmall:    AppTextStyles.orderId,       
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.ndot,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
          color: AppColors.white,
        ),
        iconTheme: IconThemeData(color: AppColors.white),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.red,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: AppTextStyles.navLabel,
        unselectedLabelStyle: AppTextStyles.navLabel,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        labelStyle: AppTextStyles.fieldLabel,
        floatingLabelStyle:
            AppTextStyles.fieldLabel.copyWith(color: AppColors.textSecondary),
        hintStyle:
            AppTextStyles.fieldLabel.copyWith(color: AppColors.textMuted),
        errorStyle: AppTextStyles.errorMessage.copyWith(fontSize: 11),

        enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.textSecondary, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.red, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.redError, width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.redError, width: 1.5),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textMuted, width: 1),
        ),
        border: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.textSecondary, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.black,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textMuted,
          elevation: 0,
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.textSecondary, width: 1),
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTextStyles.buttonSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.buttonSecondary.copyWith(fontSize: 14),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.redDim,
        disabledColor: AppColors.surface,
        labelStyle: AppTextStyles.fieldLabel,
        secondaryLabelStyle:
            AppTextStyles.fieldLabel.copyWith(color: AppColors.red),
        side: const BorderSide(color: AppColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        showCheckmark: false,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.redErrorBg,
        contentTextStyle: AppTextStyles.errorMessage,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppRadius.errorBanner),
          side:
              const BorderSide(color: AppColors.redError, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.white,
        size: 24,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        minVerticalPadding: 0,
        iconColor: AppColors.white,
        textColor: AppColors.white,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.ndot,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: AppFonts.ndot,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.red,
      ),
    );
  }
}

abstract class AppSnackBar {
  static SnackBar error(String message) => SnackBar(
        content: Row(
          children: [
            Container(
              width: 17,
              height: 17,
              decoration: const BoxDecoration(
                color: AppColors.redError,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'x',
                  style: TextStyle(
                    fontFamily: AppFonts.ndot,
                    fontSize: 10,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: AppTextStyles.errorMessage),
            ),
          ],
        ),
        backgroundColor: AppColors.redErrorBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.errorBanner),
          side: const BorderSide(color: AppColors.redError, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      );

  static SnackBar info(String message) => SnackBar(
        content: Text(
          message,
          style: AppTextStyles.helperText
              .copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.errorBanner),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      );
}