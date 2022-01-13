import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth/auth_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/home/search_screen.dart';
import 'package:shop_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => Products()),
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
              .copyWith(secondary: Colors.yellow),
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const WelcomeScreen(),
        routes: {
          WelcomeScreen.routeName: (ctx) => const WelcomeScreen(),
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
        },
      ),
    );
  }
}
