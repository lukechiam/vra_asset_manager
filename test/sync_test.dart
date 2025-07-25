import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

void main() {
  group('Test syncing logic for record (by ID) not in slave', () {
    late List<Map<String, dynamic>> masterList;
    late List<Map<String, dynamic>> slaveList;

    setUp(() async {
      masterList = [
        {
          'id': 10,
          'name': '50m Rope',
          'gear_type': 'rope',
          'track_usage': true,
          'parent_id': 1,
        },
        {
          'id': 20,
          'name': '50m Rope',
          'gear_type': 'rope',
          'track_usage': true,
          'parent_id': 1,
        },
        {
          'id': 44,
          'name': '50m Rope',
          'gear_type': 'rope',
          'track_usage': true,
          'parent_id': 1,
        },
      ];
      slaveList = [
        {
          'id': 44,
          'name': '50m Rope',
          'gear_type': 'rope',
          'track_usage': true,
          'parent_id': 1,
        },
        {
          'id': 55,
          'name': '50m Rope',
          'gear_type': 'rope',
          'track_usage': true,
          'parent_id': 1,
        },
      ];
    });

    tearDown(() async {});

    test('Test syncing logic', () async {
      // DatabaseHelper.instance.syncGearTable(masterList, slaveList);

      var sortedList1 = [...masterList]
        ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
      var sortedList2 = [...slaveList]
        ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      print('masterList: $masterList');
      print('slaveList: $slaveList');
      print('Lengths: ${masterList.length} vs ${slaveList.length}');

      print(
        'DeepCollectionEquality: ${DeepCollectionEquality().equals(sortedList1, sortedList2)}',
      );

      expect(
        sortedList1.length == sortedList2.length &&
            sortedList1.asMap().entries.every(
              (entry) => mapEquals(entry.value, sortedList2[entry.key]),
            ),
        true,
        reason: 'listEquals: List should be exactly the same after sync-ing',
      );
    });
  });
}
