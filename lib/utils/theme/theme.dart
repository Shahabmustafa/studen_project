

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

class TTheme{
  TTheme._();
  
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: TColors.white,
    dialogTheme: DialogTheme(
      backgroundColor: TColors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: TColors.black,
      ),

    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: TColors.primaryColor,
      labelColor: TColors.primaryColor,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,  // White background color of the TimePicker
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
      Colors.black  // Text color for the hour and minute (both selected and unselected)
      ),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: TColors.primaryColor, width: 2),
      ), // Shape of the hour and minute display
      dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
      Colors.black  // AM/PM text color (both selected and unselected)
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: TColors.primaryColor, width: 2),
      ), // Shape of the AM/PM display
      dialHandColor: Colors.blueAccent,  // Color of the dial hand
      dialBackgroundColor: Colors.white,  // White background color of the dial
      hourMinuteTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  // Text style of hour and minute
      dayPeriodTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Text style of AM/PM
      helpTextStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),  // Style of the help text (e.g., "SELECT TIME")
      entryModeIconColor: Colors.blueAccent,  // Color of the entry mode icon
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,  // White background color of the DatePicker
      surfaceTintColor: Colors.blueAccent,  // Tint color for surfaces
      headerBackgroundColor: Colors.blueAccent,  // Background color of the header (where the month/year is displayed)
      headerForegroundColor: Colors.white,  // Text color of the header
      dayForegroundColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.white : Colors.grey.shade800
      ), // Day text color when selected and unselected
      dayBackgroundColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.blueAccent : Colors.transparent
      ), // Day background color when selected
      yearBackgroundColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.blueAccent : Colors.transparent
      ), // Year background color when selected
      yearStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),  // Text style for years
      weekdayStyle: TextStyle(color: Colors.grey.shade800),  // Style for weekday labels (Mon, Tue, etc.)
      dayStyle: TextStyle(fontSize: 16, color: Colors.grey.shade800),  // General style for day numbers
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: TColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: TColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: TColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: TColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIconColor: TColors.primaryColor,
      prefixIconColor: TColors.primaryColor,
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      focusColor: TColors.primaryColor,
      hoverColor: TColors.primaryColor,
      helperStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: TColors.gray,
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: TColors.red,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: TColors.primaryColor,
      selectionColor: TColors.primaryColor,
      selectionHandleColor: TColors.primaryColor,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: TColors.white,
      shadowColor: TColors.white,
      surfaceTintColor: TColors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: TColors.white,
      elevation: 2,
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: TColors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: TColors.gray,
      selectedItemColor: TColors.primaryColor,
      backgroundColor: TColors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: TColors.white,
      foregroundColor: TColors.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: TColors.primaryColor,
    ),
    indicatorColor: TColors.primaryColor,
  );
}