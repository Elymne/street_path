import 'package:poc_street_path/domain/models/content/content.model.dart';

class ContentText extends Content {
  final String text;

  ContentText({
    required super.id,
    required super.createdAt,
    required super.receivedAt,
    required super.authorName,
    required super.bounces,
    required super.flowName,
    required super.title,
    required super.storageMode,
    required super.shippingMode,
    required this.text,
  });

  ContentText clone({
    String? id,
    int? createdAt,
    int? receivedAt,
    String? authorName,
    int? bounces,
    String? flowName,
    String? title,
    StorageMode? storageMode,
    ShippingMode? shippingMode,
    String? text,
  }) {
    return ContentText(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      receivedAt: receivedAt ?? this.receivedAt,
      authorName: authorName ?? this.authorName,
      bounces: bounces ?? this.bounces,
      flowName: flowName ?? this.flowName,
      title: title ?? this.title,
      storageMode: storageMode ?? this.storageMode,
      shippingMode: shippingMode ?? this.shippingMode,
      text: text ?? this.text,
    );
  }

  factory ContentText.fromJson(Map<String, dynamic> json) {
    return ContentText(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      receivedAt: json['createdAt'] as int,
      authorName: json['authorName'] as String,
      bounces: json['bounces'] as int,
      flowName: json['flowName'] as String,
      title: json['title'] as String,
      shippingMode: ShippingMode.normal,
      storageMode: StorageMode.normal,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'authorName': authorName,
      'bounces': bounces,
      'flowName': flowName,
      'title': title,
      'text': text,
    };
  }

  static const allowed = {
    'id': String,
    'createdAt': int,
    'authorName': String,
    'bounces': int,
    'flowName': String,
    'title': String,
    'text': String,
  };

  static bool isValidJson(Map<String, dynamic> json) {
    final allowedKey = allowed.keys.toSet();
    final jsonKeys = json.keys.toSet();

    if (allowedKey.length != jsonKeys.length) {
      return false;
    }

    final extraKeys = jsonKeys.difference(allowedKey);
    if (extraKeys.isNotEmpty) {
      return false;
    }

    for (final key in allowedKey.intersection(jsonKeys)) {
      final expectedType = allowed[key];
      final value = json[key];

      if (value != null && value.runtimeType != expectedType) {
        return false;
      }
    }

    return true;
  }
}
