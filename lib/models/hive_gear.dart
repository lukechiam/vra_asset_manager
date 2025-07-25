import 'package:hive_flutter/hive_flutter.dart';
import 'package:vra_asset_manager/models/gear_type.dart';

@HiveType(typeId: 0)
class GearHiveModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  GearType? gearType;

  @HiveField(3)
  bool? trackUsage;

  @HiveField(4)
  int? parentId;

  GearHiveModel({
    required this.id,
    required this.name,
    this.gearType,
    this.trackUsage,
    this.parentId,
  });
}
