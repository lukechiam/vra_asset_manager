import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vra_asset_manager/services/database_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://bqfgsiporwltimtxuiuu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJxZmdzaXBvcndsdGltdHh1aXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5NDc5MDgsImV4cCI6MjA2NzUyMzkwOH0.xH2aIkdW5DyT_3nTCJKbF7ctJVCSWwP8ljDwOTgy1p8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.debug,
    ),
    storageOptions: const StorageClientOptions(retryAttempts: 10),
  );

  await Hive.initFlutter();
  final databaseService = DatabaseService();
  await databaseService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => databaseService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
