import 'package:flutter/material.dart';

class AppColorsLight {
  AppColorsLight._();

  static const Color white = Color(0xffffffff);
  static const Color conversationsSelectedTabColor = Color(0xFFF2F2F2);
  static const Color shimmerBaseColor = Color(0xffffffff);
  static const Color shimmerHilightColor = Colors.white30;
  static const Color shimmerContainerColor = Colors.white;
  static const Color clockInButtonColor = Color(0xff27AE60);
  static const Color bnIconsUnselectedColor = Color(0xFF000000);
  static const Color bnIconsSelectedColor = Color(0xffffffff);
  static const Color calanderTextColor = Color.fromARGB(255, 0, 0, 0);
  static const Color calanderBoxColor = Color.fromARGB(255, 177, 177, 177);

  static const Color onlineColor = Color.fromARGB(255, 7, 235, 15);
  static const Color offlineColor = Color(0xFFE21F26);
  static const Color mainColor = Color(0xFFE21F26);
  static const Color mainColorDark = Color.fromARGB(255, 141, 20, 24);
  static const Color mainColorLight = Color.fromARGB(255, 248, 40, 47);

  //
  // on-hero (always light, both app themes)
  // These sit on the AppRedHeader gradient, which reads as a dark surface in
  // light AND dark mode — so they must NOT resolve by brightness the way the
  // ContextColorExtensions getters do.
  static const Color onHeroTextSecondary = Color(0xB8FFFFFF); // white 72%
  static const Color onHeroTextMuted = Color(0x80FFFFFF); // white 50%
  static const Color onHeroGlass = Color(0x1FFFFFFF); // white 12%
  static const Color onHeroGlassBorder = Color(0x38FFFFFF); // white 22%

  /// "On shift" green. Brighter than [clockInButtonColor], which muddies
  /// against the red gradient.
  static const Color onHeroOnline = Color(0xFF22C55E);

  /// "Needs your action" indicator. Amber is the only attention hue that holds
  /// 3:1 against both hero gradients — red is camouflage there, green reads as
  /// "all good". Non-text use only.
  static const Color onHeroAttention = Color(0xFFFCD34D);

  //
  // approve / reject action colors (same in both themes)
  static const Color approveActionColor = Color(0xFF3DDC84);
  static const Color approveActionTextColor = Color(0xFF0E1A14);
  static const Color rejectActionColor = Color(0xFFE5484D);

  static const Color senderCallColor = Color.fromARGB(255, 138, 137, 137);
  static const Color reciverCallColor = Color.fromARGB(255, 248, 248, 248);
  static const Color reciverCallBackgroundColor =
      Color.fromARGB(255, 85, 85, 85);
  static const Color senderCallBackgroundColor =
      Color.fromARGB(255, 224, 224, 224);

  static const bodyBackgroundColor = Color(0xFFE7E7E7);

  static const Color disabledColor = Color(0xff616161);
  static const Color snakBarSuccessColor = Color(0xff3b3b3b);
  static const Color snakBarErrorColor = mainColor;

  static const Color hintTextColor = Colors.grey;
  static const Color cardBackgroundColor = Color(0xfff8f9fd);
  static const Color transparentColor = Colors.transparent;
  static const Color dialogCancelButtonColor = Color(0xff82858A);

  //
  //
  static const Color textColor = Color(0xff656363);
  static const Color secondaryHeaderColor = Color(0xff3E4958);
  static const Color scaffoldBackroundColor = Color(0xFFF5F6FA);

  static const Color chatSenderColor = Colors.white;
  static const Color chatReciverColor = Color.fromARGB(255, 110, 110, 110);
  static const Color chatSenderTextColor = Colors.black;
  static const Color chatReciverTextColor = Colors.white;

  static const Color reactionsSenderColor = Colors.white;
  static const Color reactionsReceiverColor =
      Color.fromARGB(255, 110, 110, 110);

  static const Color chatReciverNameColor = Color.fromARGB(255, 21, 255, 243);
  static const Color chatReciverMentionColor = Color.fromARGB(255, 252, 175, 8);
  static const Color chatSenderMentionColor = Color(0xFFE21F26);

  static const Color chatSenderTimeColor = Colors.black;
  static const Color chatReciverTimeColor = Colors.white;
  static const Color chatReciptsColor = Colors.black;

  //
  // tab bar selected colors
  static const Color tabBarSelectedColor = Colors.white;
  static const Color tabBarBadgeSelectedColor = Colors.white;
  static const Color tabBarBadgeSelectedTextColor = mainColor;

  //
  // tab bar selected colors
  static const Color tabBarUnselectedColor = Colors.black;
  static const Color tabBarBadgeUnselectedColor = mainColor;

  static const Color tabBarBadgeUnselectedTextColor = Colors.white;
}
