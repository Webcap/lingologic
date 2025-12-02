import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/supabase_config.dart';
import 'router/app_router.dart';
import 'services/connectivity_service.dart';
import 'services/sync_service.dart';
import 'services/asset_preloader.dart';
import 'theme/app_theme.dart';
import 'widgets/offline_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up global error handlers
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  // Handle async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled error: $error');
    debugPrint('Stack trace: $stack');
    return true;
  };
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Supabase (with error handling)
  // Defer Supabase initialization to avoid blocking app startup
  Future.microtask(() async {
    try {
      await SupabaseConfig.initialize();
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      // Handle initialization error
      debugPrint('Supabase initialization error: $e');
    }
  });
  
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
  ConnectivityService? _connectivityService;
  SyncService? _syncService;

  @override
  void initState() {
    super.initState();
    // Initialize services synchronously but safely
    try {
      _connectivityService = ConnectivityService();
      _syncService = SyncService();
    } catch (e) {
      debugPrint('Service initialization error: $e');
    }
    
    // Link connectivity service to sync service (non-blocking)
    Future.microtask(() {
      try {
        if (_connectivityService != null && _syncService != null) {
          _syncService!.setConnectivityService(_connectivityService!);
          _syncService!.startBackgroundSync();
        }
      } catch (e) {
        debugPrint('Sync service setup error: $e');
      }
    });
    
    // Preload assets after first frame (non-blocking)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        try {
          if (mounted) {
            AssetPreloader.preloadAssets(context);
          }
        } catch (e) {
          debugPrint('Asset preload error: $e');
        }
      });
    });
  }

  @override
  void dispose() {
    _connectivityService?.dispose();
    _syncService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LingoLogic',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        try {
          // Only wrap with gradient and offline indicator if services are ready
          if (_connectivityService != null) {
            return Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.mainGradient,
              ),
              child: OfflineIndicator(
                connectivityService: _connectivityService!,
                child: child ?? const SizedBox(),
              ),
            );
          } else {
            // Fallback: just gradient, no offline indicator
            return Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.mainGradient,
              ),
              child: child ?? const SizedBox(),
            );
          }
        } catch (e, stackTrace) {
          debugPrint('Error in app builder: $e');
          debugPrint('Stack trace: $stackTrace');
          // Return a simple error screen
          return Material(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.mainGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $e'),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
