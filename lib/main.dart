import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'widgets/live_room_screen.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase con tus credenciales
  await Supabase.initialize(
    url: 'uwilhytiyfbvkrdxrtkh', //
    anonKey: 'sb_publishable_SQVpXgX-ZJCirq8m-4BYyw_tbuDVn09', //
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CONVOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
