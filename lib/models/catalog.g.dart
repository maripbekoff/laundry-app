// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalog _$CatalogFromJson(Map<String, dynamic> json) {
  return Catalog(
    name: json['name'] as String,
    image: json['image'] as String,
    description: json['description'] as String,
    unit_type: json['unit_type'] as String,
    unit_time: json['unit_time'] as int,
    unit_price: json['unit_price'] as String,
    category: json['category'] as Map<String, dynamic>,
    uuid: json['uuid'] as String,
    itemCount: json['itemCount'] as int,
  );
}

Map<String, dynamic> _$CatalogToJson(Catalog instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'unit_type': instance.unit_type,
      'unit_time': instance.unit_time,
      'unit_price': instance.unit_price,
      'category': instance.category,
      'uuid': instance.uuid,
      'itemCount': instance.itemCount,
    };
