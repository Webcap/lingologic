import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  bool _isOnline = true;
  final _connectivityController = StreamController<bool>.broadcast();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  Stream<bool> get connectivityStream => _connectivityController.stream;
  bool get isOnline => _isOnline;

  ConnectivityService() {
    // Initialize asynchronously without blocking
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      // Check initial connectivity
      await _checkConnectivity();
      
      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          _checkConnectivity();
        },
      );
    } catch (e) {
      // If initialization fails, assume offline
      _isOnline = false;
      if (kDebugMode) {
        debugPrint('ConnectivityService initialization error: $e');
      }
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );
      
      // For MVP, just check network connectivity
      // Server ping can be added later when Supabase is guaranteed to be initialized
      final newStatus = hasConnection;
      
      if (newStatus != _isOnline) {
        _isOnline = newStatus;
        _connectivityController.add(_isOnline);
      }
    } catch (e) {
      if (_isOnline) {
        _isOnline = false;
        _connectivityController.add(false);
      }
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
