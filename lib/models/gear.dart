import 'package:vra_asset_manager/models/gear_type.dart';

class Gear {
  final int id;
  final String name;
  GearType? gearType;
  DateTime? mfgDate;
  String? shelfLife;
  DateTime? expiryDate;
  bool? trackUsage;
  bool? trackExpiry;
  int? parentId;
  DateTime? createdAt;
  int sortOrder;

  Gear({
    required this.id,
    required this.name,
    this.gearType,
    this.mfgDate,
    this.shelfLife,
    this.expiryDate,
    this.trackUsage,
    this.trackExpiry,
    this.parentId,
    this.createdAt,
    required this.sortOrder,
  });

  factory Gear.fromJsonData(Map<String, dynamic> data) {
    return Gear(
      id: data['id'] as int,
      name: data['name'] as String,
      gearType: GearType.fromString(data['gear_type'] as String),
      mfgDate: DateTime.tryParse(data['mfg_date'] as String? ?? ''),
      shelfLife: data['shelf_life'] as String? ?? '',
      expiryDate: DateTime.tryParse(data['expiry_date'] as String? ?? ''),
      trackUsage: data['track_usage'] as bool? ?? false,
      trackExpiry: data['track_expiry'] as bool? ?? false,
      parentId: data['parent_id'] as int,
      createdAt: DateTime.tryParse(data['created_at'] as String? ?? ''),
      sortOrder: data['sort_order'] as int? ?? 9999,
    );
  }
}
