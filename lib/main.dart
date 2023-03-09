import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'global/constants/colors.dart';
import 'providers/connectivity_provider.dart';
import 'providers/home_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/base/base_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const LabyrinthApp());
}

class LabyrinthApp extends StatelessWidget {
  const LabyrinthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: kSecondaryOrange,
            selectionColor: kSecondaryOrange,
            selectionHandleColor: kSecondaryOrange,
          ),
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: kPrimaryOrange),
          iconTheme: const IconThemeData(color: kIconColor),
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: GoogleFonts.lexendTextTheme().apply(bodyColor: kTextColor),
        ),
        home: const BaseScreen(),
      ),
    );
  }
}
