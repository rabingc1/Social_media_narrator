import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';
import 'sizes.dart';

class AppTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: _appbarTheme(),
      fontFamily: GoogleFonts.poppins().fontFamily,
      canvasColor: AppColor.canvas,
      inputDecorationTheme: inputDecorationTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: AppColor.text,
        selectedLabelStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: _textTheme(),
      textSelectionTheme: _textSelectionTheme(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextSelectionThemeData _textSelectionTheme() {
    return TextSelectionThemeData(
      cursorColor: AppColor.primary,
      selectionColor: AppColor.primary.withOpacity(0.5),
      selectionHandleColor: AppColor.primary,
    );
  }

  //requireddd
  static TextTheme _textTheme() => TextTheme(
        titleLarge: GoogleFonts.inter(fontSize: Sizes.s12),
      );

  static AppBarTheme _appbarTheme() => AppBarTheme(
        elevation: 1,
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.roboto(
          color: AppColor.profile,
          fontSize: Sizes.s16,
        ),
        iconTheme: const IconThemeData(
          color: AppColor.profile,
        ),
      );

  static get inputDecorationTheme => InputDecorationTheme(
        suffixIconColor: WidgetStateColor.resolveWith(
          (states) {
            if (states.contains(WidgetState.error)) {
              return AppColor.danger;
            }

            if (states.contains(WidgetState.focused)) {
              return AppColor.primary;
            }

            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade300;
            }

            return AppColor.grey;
          },
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          TextStyle style = const TextStyle();

          if (states.contains(WidgetState.error)) {
            return style.copyWith(color: AppColor.danger);
          }
          if (states.contains(WidgetState.focused)) {
            return style.copyWith(color: AppColor.primary);
          }

          if (states.contains(WidgetState.disabled)) {
            return style.copyWith(color: Colors.grey.shade300);
          }

          return style.copyWith(color: AppColor.grey);
        }),
        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          TextStyle style = const TextStyle();

          if (states.contains(WidgetState.error)) {
            return style.copyWith(color: AppColor.danger);
          }
          if (states.contains(WidgetState.focused)) {
            return style.copyWith(color: AppColor.primary);
          }

          if (states.contains(WidgetState.disabled)) {
            return style.copyWith(color: Colors.grey.shade300);
          }

          return style.copyWith(color: AppColor.grey);
        }),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16),
        border: MaterialStateOutlineInputBorder.resolveWith(
          (states) {
            OutlineInputBorder inputBorder = const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColor.grey),
            );

            if (states.contains(WidgetState.error)) {
              return inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColor.danger),
              );
            }

            if (states.contains(WidgetState.focused)) {
              return inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColor.primary),
              );
            }

            if (states.contains(WidgetState.disabled)) {
              return inputBorder.copyWith(
                borderSide: BorderSide(color: Colors.grey.shade300),
              );
            }

            return inputBorder;
          },
        ),
      );
}
