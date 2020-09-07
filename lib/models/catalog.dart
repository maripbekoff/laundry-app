import 'package:json_annotation/json_annotation.dart';

part 'catalog.g.dart';

@JsonSerializable(nullable: true)
class Catalog {
  final String name;
  final String image;
  final String description;
  final String unit_type;
  final int unit_time;
  final String unit_price;
  final Map<String, dynamic> category;
  final String uuid;
  int itemCount = 0;

  Catalog({
    this.name,
    this.image,
    this.description,
    this.unit_type,
    this.unit_time,
    this.unit_price,
    this.category,
    this.uuid,
    this.itemCount,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) =>
      _$CatalogFromJson(json);
  Map<String, dynamic> toJson() => _$CatalogToJson(this);
}
