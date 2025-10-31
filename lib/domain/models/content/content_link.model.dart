import 'package:poc_street_path/domain/models/content/content.model.dart';

class ContentLink extends Content {
  final String ref;
  final String description;

  ContentLink({
    required super.id,
    required super.createdAt,
    required super.receivedAt,
    required super.authorName,
    required super.bounces,
    required super.flowName,
    required super.title,
    required super.storageMode,
    required super.shippingMode,
    required this.ref,
    required this.description,
  });

  static final Map<String, Type> allowed = {
    'id': String,
    'createdAt': int,
    'authorName': String,
    'bounces': int,
    'flowName': String,
    'title': String,
    'ref': String,
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
      'ref': ref,
      'description': description,
    };
  }

  ContentLink clone({
    String? id,
    int? createdAt,
    int? receivedAt,
    String? authorName,
    int? bounces,
    String? flowName,
    String? title,
    StorageMode? storageMode,
    ShippingMode? shippingMode,
    String? ref,
    String? description,
  }) {
    return ContentLink(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      receivedAt: receivedAt ?? this.receivedAt,
      authorName: authorName ?? this.authorName,
      bounces: bounces ?? this.bounces,
      flowName: flowName ?? this.flowName,
      title: title ?? this.title,
      storageMode: storageMode ?? this.storageMode,
      shippingMode: shippingMode ?? this.shippingMode,
      ref: ref ?? this.ref,
      description: description ?? this.description,
    );
  }

  factory ContentLink.fromJson(Map<String, dynamic> json) {
    return ContentLink(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      receivedAt: json['receivedAt'] as int,
      authorName: json['authorName'] as String,
      bounces: json['bounces'] as int,
      flowName: json['flowName'] as String,
      title: json['title'] as String,
      shippingMode: ShippingMode.normal,
      storageMode: StorageMode.normal,
      ref: json['ref'] as String,
      description: json['description'] as String,
    );
  }
}
