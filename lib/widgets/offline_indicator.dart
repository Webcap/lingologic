import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/connectivity_service.dart';
import 'dart:async';

class OfflineIndicator extends StatefulWidget {
  final ConnectivityService connectivityService;
  final Widget child;

  const OfflineIndicator({
    super.key,
    required this.connectivityService,
    required this.child,
  });

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _isOnline = true;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    try {
      _isOnline = widget.connectivityService.isOnline;
      _subscription = widget.connectivityService.connectivityStream.listen(
        (isOnline) {
          if (mounted) {
            setState(() {
              _isOnline = isOnline;
            });
          }
        },
        onError: (error) {
          debugPrint('Connectivity stream error: $error');
        },
      );
    } catch (e) {
      debugPrint('OfflineIndicator initialization error: $e');
      _isOnline = true; // Default to online if we can't determine
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (!_isOnline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.orange.shade600,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Offline Mode - Changes will sync when online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

