import 'package:critical_dudes/splash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'configs.dart';

Future<void> main() async {
  http.get(Uri.parse("https://api.rawg.io/api/games"), headers: )

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: const SplashScreen(),
    );
  }
}
