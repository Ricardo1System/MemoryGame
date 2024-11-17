import 'package:flutter/material.dart';
import 'package:memory_game/screen/menu.dart';
import 'package:memory_game/services/cache/shared_preferences.dart';


 final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}

