import 'package:fulltimeforce_test/app/_childrens/commits/pages/commits_page.dart';
import 'package:fulltimeforce_test/app/common_widgets/dark_mode_button.dart';
import 'package:fulltimeforce_test/app/constants/assets.dart';
import 'package:fulltimeforce_test/app/constants/utils_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/flag_language.dart';
import '../../../theme/theme_notifier.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage>
    with WidgetsBindingObserver {
  late SharedPreferences prefs;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initPrefs();
    });
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      _changeDarkMode();
      super.didChangePlatformBrightness();
    }
  }

  _changeDarkMode() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      if (prefs.getString('themeMode') == 'light') {
        Provider.of<ThemeNotifier>(context, listen: false)
            .setThemeMode(ThemeMode.dark);
      }
    } else if (!isDarkMode && prefs.getString('themeMode') == 'dark') {
      Provider.of<ThemeNotifier>(context, listen: false)
          .setThemeMode(ThemeMode.dark);
    }
  }

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _changeDarkMode();
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveBreakpoints.builder(
      breakpoints: UtilsScreen.breakpoints,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsUIValues.logoFulltimeForce,
                    width: size.width * .8,
                    height: size.height * .2,
                  ),
                  SizedBox(height: size.height * .04),
                  Text(
                    translate('nameUser'),
                    style: TextStyle(
                      fontSize: size.width * .065,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  SizedBox(
                      width: size.width * .8,
                      child: Text(
                        translate('wellcome'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * .045,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      )),
                  SizedBox(height: size.height * .05),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CommitsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * .04),
                      ),
                      padding: EdgeInsets.all(size.width * .03),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          translate('enter'),
                          style: TextStyle(
                            fontSize: size.width * .040,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: size.height * .010),
                        Icon(
                          Icons.arrow_forward,
                          size: size.width * .050,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: size.height * .05,
              left: size.width * .05,
              child: FlagLanguage(flagWidth: size.width * .1),
            ),
            Positioned(
              top: size.height * .08,
              right: size.width * .05,
              child: const DarkModeButton(),
            ),
          ],
        ),
      ),
    );
  }
}
