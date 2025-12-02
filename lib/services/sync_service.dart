import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'auth_service.dart';
import 'connectivity_service.dart';
import 'dart:async';
import 'dart:convert';

enum SyncOperation {
  insert,
  update,
  delete,
}

class SyncQueueItem {
  final String id;
  final String userId;
  final String tableName;
  final SyncOperation operation;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  DateTime? syncedAt;

  SyncQueueItem({
    required this.id,
    required this.userId,
    required this.tableName,
    required this.operation,
    required this.data,
    required this.createdAt,
    this.syncedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'table_name': tableName,
      'operation': operation.name,
      'data': jsonEncode(data),
      'created_at': createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
    };
  }
}

class SyncService {
  SupabaseClient? _supabase;
  final AuthService _authService = AuthService();
  ConnectivityService? _connectivityService;
  final List<SyncQueueItem> _localQueue = [];
  bool _isSyncing = false;
  Timer? _syncTimer;
  StreamSubscription<bool>? _connectivitySubscription;
  
  SupabaseClient? get _supabaseClient {
    if (_supabase == null) {
      _supabase = SupabaseConfig.client;
    }
    return _supabase;
  }
  
  void setConnectivityService(ConnectivityService service) {
    _connectivityService = service;
  }

  /// Queue a change for sync
  Future<void> queueChange({
    required String tableName,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    final user = _authService.currentUser;
    if (user == null) return;

    final queueItem = SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      tableName: tableName,
      operation: operation,
      data: data,
      createdAt: DateTime.now(),
    );

    _localQueue.add(queueItem);

    // Try to sync immediately if online
    await sync();
  }

  /// Sync all queued changes to Supabase
  Future<void> sync() async {
    if (_isSyncing) return;
    if (_localQueue.isEmpty) return;
    if (_connectivityService != null && !_connectivityService!.isOnline) {
      return; // Don't sync if offline
    }

    final client = _supabaseClient;
    if (client == null) return; // Supabase not initialized

    final user = _authService.currentUser;
    if (user == null) return;

    _isSyncing = true;

    try {
      final itemsToSync = _localQueue.where((item) => item.syncedAt == null).toList();

      for (final item in itemsToSync) {
        try {
          switch (item.operation) {
            case SyncOperation.insert:
              await client.from(item.tableName).insert(item.data);
              break;
            case SyncOperation.update:
              await client.from(item.tableName).update(item.data).eq('id', item.data['id']);
              break;
            case SyncOperation.delete:
              await client.from(item.tableName).delete().eq('id', item.data['id']);
              break;
          }

          item.syncedAt = DateTime.now();
        } catch (e) {
          // Log error but continue with other items
          print('Error syncing item ${item.id}: $e');
        }
      }

      // Remove synced items from queue
      _localQueue.removeWhere((item) => item.syncedAt != null);

      // Also sync to remote sync_queue table for persistence
      if (itemsToSync.isNotEmpty) {
        await client.from('sync_queue').upsert(
          itemsToSync.map((item) => item.toJson()).toList(),
        );
      }
    } catch (e) {
      print('Sync error: $e');
      // Queue will be retried on next sync
    } finally {
      _isSyncing = false;
    }
  }

  /// Start background sync timer
  void startBackgroundSync({Duration interval = const Duration(seconds: 30)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) {
      if (_connectivityService == null || _connectivityService!.isOnline) {
        sync();
      }
    });
    
    // Listen for connectivity changes and sync when online
    if (_connectivityService != null) {
      _connectivitySubscription?.cancel();
      _connectivitySubscription = _connectivityService!.connectivityStream.listen(
        (isOnline) {
          if (isOnline && _localQueue.isNotEmpty) {
            sync();
          }
        },
      );
    }
  }

  /// Stop background sync
  void stopBackgroundSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
  
  void dispose() {
    stopBackgroundSync();
  }

  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'queued_items': _localQueue.length,
      'is_syncing': _isSyncing,
      'unsynced_count': _localQueue.where((item) => item.syncedAt == null).length,
    };
  }

  /// Clear synced items from queue
  void clearSyncedItems() {
    _localQueue.removeWhere((item) => item.syncedAt != null);
  }
}

