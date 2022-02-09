import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/notifiers/areaselection_notifier.dart';
import 'package:cap_mobile_native/services/crypto_service.dart';
import 'package:cap_mobile_native/ui/pages/companies_page.dart';
import 'package:cap_mobile_native/ui/pages/home_page.dart';
import 'package:cap_mobile_native/ui/pages/login_page.dart';
import 'package:cap_mobile_native/ui/pages/otp_page.dart';
import 'package:cap_mobile_native/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    
  await GetStorage.init();

  /*
  TODO: if applicaiton shortcust will be needed then it can be used as quick access to the tabs in home screen, Moreover should be initialiszed in homescreen and deinitialized on logout event
  final QuickActions quickActions = const QuickActions();
  quickActions.initialize((shortcutType) {
    if (shortcutType == 'action_main') {
      print('The user tapped on the "Main view" action.');
    }
  });

  quickActions.setShortcutItems(<ShortcutItem>[
    const ShortcutItem(type: 'action_main', localizedTitle: 'Main view', icon: 'icon_main'),
    const ShortcutItem(type: 'action_help', localizedTitle: 'Help', icon: 'icon_help')
  ]); 
  */

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AreaSelectionNotifier()),
        ChangeNotifierProvider(create: (context) => AccountNotifier()),
      ],
      child: CAPApp(),
    ),
  );
}

class CAPApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Color.fromRGBO(65, 105, 225, 1).withOpacity(0.2),
          onPrimary: Colors.black,
        )
      ),
      routes: {
        '/': (context) => new Wrapper(),
        '/login': (context) => new LoginPage(),
      },

      // home: Wrapper(),
    );
  }
}
