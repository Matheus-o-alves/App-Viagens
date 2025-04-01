import 'package:flutter/material.dart';

class AppColors {
  static const Color darkText = Color(0xFF37404E);
  static const Color lightText = Color(0xFF5E646E);
  static const Color greenAccent = Color(0xFF54B73B);
  static const Color greyLine = Color(0x80DEE0E3);
  static const Color softGrey = Color(0xFF868C98);
  static const Color background = Color(0xFFF4F5F6);
  static const Color white = Colors.white;
  static const Color tagBlue = Color(0xFF232F69); // Adicionado
}

class AppTextStyles {
  static const String fontFamily = 'Lato';

  static const TextStyle cardTitle = TextStyle(
    fontSize: 12,
    color: AppColors.lightText,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  static const TextStyle currencySymbol = TextStyle(
    fontSize: 12,
    color: AppColors.darkText,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle amount = TextStyle(
    fontSize: 16,
    color: AppColors.lightText,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  static const TextStyle tabSelected = TextStyle(
    fontSize: 14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    color: AppColors.darkText,
    letterSpacing: 0.28,
  );

  static const TextStyle tabUnselected = TextStyle(
    fontSize: 14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    color: AppColors.lightText,
    letterSpacing: 0.28,
  );

  static const TextStyle messageText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.softGrey,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.43,
  );

  static const TextStyle loadingText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.greenAccent,
  );

  static const TextStyle titleText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    fontFamily: fontFamily,
  );

  static const TextStyle subtitleText = TextStyle(
    fontSize: 20,
    color: AppColors.softGrey,
    fontFamily: fontFamily,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    fontFamily: fontFamily,
  );

  static const TextStyle primaryLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.darkText,
    fontFamily: fontFamily,
  );

  static const TextStyle primaryAmount = TextStyle( // Adicionado
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    fontFamily: fontFamily,
  );

  static const TextStyle tag = TextStyle( // Adicionado
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.tagBlue,
    fontFamily: fontFamily,
  );
}
