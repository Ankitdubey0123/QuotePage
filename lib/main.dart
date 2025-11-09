import 'package:flutter/material.dart';
import 'package:meru/screens/quote_builder_screen.dart';
import 'package:meru/screens/quote_preview_screen.dart';
import 'package:meru/viewModel/quote_viewModel.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app in a ChangeNotifierProvider to manage the quote state
    return ChangeNotifierProvider(
      create: (context) => QuoteViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quote Builder',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          cardTheme: const CardThemeData( // This was changed from CardTheme
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8.0),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
            bodyMedium: TextStyle(fontSize: 16.0),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const QuoteBuilderScreen(),
          QuotePreviewScreen.routeName: (context) => const QuotePreviewScreen(),
        },
      ),
    );
  }
}