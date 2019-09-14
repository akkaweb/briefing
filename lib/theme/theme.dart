import 'package:briefing/theme/colors.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: themeAppBlue500,
    primaryColor: themeAppWhite100,
    primaryColorBrightness: Brightness.light,
    bottomAppBarColor: themeAppWhite100,
    buttonTheme: base.buttonTheme.copyWith(
        buttonColor: themeAppWhite100, textTheme: ButtonTextTheme.normal),
    scaffoldBackgroundColor: themeAppBackgroundWhite,
    cardColor: themeAppBackgroundWhite,
    textSelectionColor: themeAppGrey600,
    errorColor: themeAppErrorRed,
    canvasColor: Colors.transparent,
    textTheme: _buildAppTextTheme(base.textTheme),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildAppTextTheme(base.accentTextTheme),
    accentIconTheme: base.accentIconTheme.copyWith(color: themeAppBlue500),
    primaryIconTheme: base.iconTheme.copyWith(color: themeAppGrey600),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    iconTheme: base.iconTheme.copyWith(color: themeAppGrey700),
    chipTheme: base.chipTheme.copyWith(
        secondaryLabelStyle: base.chipTheme.secondaryLabelStyle
            .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
  );
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return base
      .copyWith(
          title: base.title.copyWith(
              fontFamily: 'QuickSand',
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
          subhead: base.subhead.copyWith(
            fontFamily: 'QuickSand',
            fontSize: 18.0,
          ),
          caption: base.caption.copyWith(fontFamily: 'QuickSand'),
          button: base.button.copyWith(fontFamily: 'QuickSand'),
          subtitle: base.subtitle.copyWith(
            fontFamily: 'QuickSand',
            fontSize: 18.0,
          ))
      .apply(
          fontFamily: 'QuickSand',
          displayColor: themeAppGrey800,
          bodyColor: themeAppGrey800);
}
