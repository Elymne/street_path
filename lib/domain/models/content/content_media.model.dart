import 'package:poc_street_path/domain/models/content/content.model.dart';

class ContentMedia extends Content {
  final String path;
  final String description;

  ContentMedia({
    required super.id,
    required super.createdAt,
    required super.receivedAt,
    required super.authorName,
    required super.bounces,
    required super.flowName,
    required super.title,
    required super.storageMode,
    required super.shippingMode,
    required this.path,
    required this.description,
  });

  static final Map<String, Type> allowed = {
    'id': String,
    'createdAt': int,
    'authorName': String,
    'bounces': int,
    'flowName': String,
    'title': String,
    'path': String,
    'description': String,
  };

  @override
  Map<String, Object> toRaw() {
    return {
      'id': id,
      'createdAt': createdAt,
      'authorName': authorName,
      'bounces': bounces,
      'flowName': flowName,
      'title': title,
      'path': path,
      'description': description,
    };
  }

  ContentMedia clone({
    String? id,
    int? createdAt,
    int? receivedAt,
    String? authorName,
    int? bounces,
    String? flowName,
    String? title,
    StorageMode? storageMode,
    ShippingMode? shippingMode,
    String? path,
    String? description,
  }) {
    return ContentMedia(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      receivedAt: receivedAt ?? this.receivedAt,
      authorName: authorName ?? this.authorName,
      bounces: bounces ?? this.bounces,
      flowName: flowName ?? this.flowName,
      title: title ?? this.title,
      storageMode: storageMode ?? this.storageMode,
      shippingMode: shippingMode ?? this.shippingMode,
      path: path ?? this.path,
      description: description ?? this.description,
    );
  }

  factory ContentMedia.fromJson(Map<String, dynamic> json) {
    return ContentMedia(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      receivedAt: json['createdAt'] as int,
      authorName: json['authorName'] as String,
      bounces: json['bounces'] as int,
      flowName: json['flowName'] as String,
      title: json['title'] as String,
      shippingMode: ShippingMode.normal,
      storageMode: StorageMode.normal,
      path: json['path'] as String,
      description: json['description'] as String,
    );
  }
}
