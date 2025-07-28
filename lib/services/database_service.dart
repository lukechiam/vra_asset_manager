import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:vra_asset_manager/models/gear.dart';
import 'package:vra_asset_manager/models/gear_type.dart';
import 'package:vra_asset_manager/services/connectivity_service.dart';

class DatabaseService extends ChangeNotifier {
  static const String _boxName = 'vra_store';
  final SupabaseClient _client = Supabase.instance.client;
  Box? _box;
  bool _isDataSavedLocally = false;
  bool get isDataSavedLocally => _isDataSavedLocally;

  Future<bool> _checkConnectivity() async {
    return await ConnectivityService().isOnline();
  }

  bool _hasLoacallySavedGearLogData() {
    return _box!.keys
        .where((key) => key.toString().startsWith('gearLog:'))
        .isNotEmpty;
  }

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _isDataSavedLocally = _hasLoacallySavedGearLogData();
    notifyListeners();
  }

  Future<List<Gear>> fetchByParent({int id = 0}) async {
    if (_box == null) await init();

    try {
      if (await _checkConnectivity()) {
        final response = await _client
            .from('gear')
            .select()
            .eq('parent_id', id)
            .order('sort_order', ascending: true)
            .timeout(
              Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException('API request timed out after 5 seconds');
              },
            );

        // Cache result locally
        _box!.put('parentId:$id', response);

        return response.map((e) => Gear.fromJsonData(e)).toList();
      } else {
        print('Offline mode; fetchByParent locally');
        final rawData =
            _box!.get('parentId:$id', defaultValue: []) as List<dynamic>;

        // Convert List<Map<dynamic, dynamic>> to List<Map<String, dynamic>>
        final gears = rawData.map((item) {
          if (item is Map) {
            return (item).map((key, value) => MapEntry(key.toString(), value));
          }
          return <String, dynamic>{}; // Fallback for invalid items
        }).toList();

        return gears.map((json) => Gear.fromJsonData(json)).toList();
      }
    } catch (error) {
      throw Exception('Error fetching gear: $error');
    }
  }

  Future<List<Gear>> fetchByType(GearType type) async {
    if (_box == null) await init();

    try {
      if (await _checkConnectivity()) {
        final response = await _client
            .from('gear')
            .select()
            .eq('gear_type', type.supabaseValue)
            .timeout(
              Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException('API request timed out after 5 seconds');
              },
            );

        // Cache result locally
        _box!.put(type.toString(), response);

        return response.map((e) => Gear.fromJsonData(e)).toList();
      } else {
        print('Offline mode; fetchByType locally');
        final rawData =
            _box!.get(type.toString(), defaultValue: []) as List<dynamic>;

        // Convert List<Map<dynamic, dynamic>> to List<Map<String, dynamic>>
        final gears = rawData.map((item) {
          if (item is Map) {
            return (item).map((key, value) => MapEntry(key.toString(), value));
          }
          return <String, dynamic>{}; // Fallback for invalid items
        }).toList();

        return gears.map((json) => Gear.fromJsonData(json)).toList();
      }
    } catch (error) {
      throw Exception('Error fetching gear: $error');
    }
  }

  Future<Null> saveGearLog(
    Map<int, List<String>> gearLogMap,
    Map<int, String> gearNoteMap,
  ) async {
    const keyMappings = {
      'Used': 'is_used',
      'Damaged': 'is_damaged',
      'Missing': 'is_missing',
      'Add Note': 'has_note',
    };

    if (_box == null) await init();

    List<Map<String, dynamic>> dataToSave = gearLogMap.entries.map((entry) {
      // Create a map with 'id' as the stringified key
      Map<String, dynamic> newMap = {'gear_id': entry.key.toString()};
      // Add each string in the list as a key with value true
      for (String key in entry.value) {
        if (keyMappings.containsKey(key)) {
          newMap[keyMappings[key]!] = true;
          if (keyMappings[key]! == 'has_note') {
            newMap['note'] = gearNoteMap[entry.key] ?? '';
          }
        }
      }
      return newMap;
    }).toList();

    try {
      if (await _checkConnectivity()) {
        await _client.from('gear_log').insert(dataToSave);
      } else {
        print('Offline mode; saveGearLog locally');
        _box!.put('gearLog:${const Uuid().v4()}', dataToSave);
        _isDataSavedLocally = true;
        notifyListeners();
      }
    } catch (error) {
      throw Exception('Error saving data: $error');
    }
  }

  Future<void> uploadSavedData() async {
    List<Map<String, dynamic>> dataToSave = [];
    List<String> keysToDelete = [];

    if (_box == null) await init();

    if (await _checkConnectivity()) {
      _box!.keys.where((key) => key.toString().startsWith('gearLog:')).forEach((
        key,
      ) {
        final List<dynamic> result = _box!.get(key);

        dataToSave.addAll(
          result.map((item) {
            if (item is Map) {
              return (item).map(
                (key, value) => MapEntry(key.toString(), value),
              );
            }
            return <String, dynamic>{};
          }).toList(),
        );

        keysToDelete.add(key);
      });

      // Upload to service
      await _client.from('gear_log').insert(dataToSave);

      // Remove local data by key
      _box!.deleteAll(keysToDelete);
      _isDataSavedLocally = false;
      notifyListeners();
    }
  }

  Future<void> clearData() async {
    if (_box == null) await init();
    await _box!.clear();
    _isDataSavedLocally = false;
    notifyListeners();
  }
}
