import 'package:ey_hackathon/Document%20verification/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserDetailsProvider(), // Provide UserDetailsProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
