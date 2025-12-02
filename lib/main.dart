import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/supabase_config.dart';
import 'router/app_router.dart';
import 'services/connectivity_service.dart';
import 'services/sync_service.dart';
import 'services/asset_preloader.dart';
import 'widgets/offline_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Supabase (with error handling)
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    // Handle initialization error
    debugPrint('Supabase initialization error: $e');
  }
  
  runApp(
    const ProviderScope(
      child: LingoLogicApp(),
    ),
  );
}

class LingoLogicApp extends StatefulWidget {
  const LingoLogicApp({super.key});

  @override
  State<LingoLogicApp> createState() => _LingoLogicAppState();
}

class _LingoLogicAppState extends State<LingoLogicApp> {
  late final ConnectivityService _connectivityService;
  late final SyncService _syncService;

  @override
  void initState() {
    super.initState();
    try {
      _connectivityService = ConnectivityService();
      _syncService = SyncService();
      
      // Link connectivity service to sync service
      _syncService.setConnectivityService(_connectivityService);
      
      // Start background sync
      _syncService.startBackgroundSync();
      
      // Preload assets after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          AssetPreloader.preloadAssets(context);
        } catch (e) {
          debugPrint('Asset preload error: $e');
        }
      });
    } catch (e) {
      debugPrint('App initialization error: $e');
    }
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    _syncService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineIndicator(
      connectivityService: _connectivityService,
      child: MaterialApp.router(
        title: 'LingoLogic',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
