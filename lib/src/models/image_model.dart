enum ImageSourceType { FILE, URL }

enum ImageStatus { PENDING, PROCESSING, COMPLETED, FAILED }

class ImageModel {
  final String id;
  final String userId;
  final String originalUrl;
  final String? processedUrl;
  final ImageSourceType sourceType;
  final ImageStatus status;
  final String? digest;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ImageModel({
    required this.id,
    required this.userId,
    required this.originalUrl,
    this.processedUrl,
    required this.sourceType,
    required this.status,
    this.digest,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      userId: json['user_id'],
      originalUrl: json['original_url'],
      processedUrl: json['processed_url'],
      sourceType: ImageSourceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['source_type'],
        orElse: () => ImageSourceType.FILE,
      ),
      status: ImageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ImageStatus.PENDING,
      ),
      digest: json['digest'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'original_url': originalUrl,
        'processed_url': processedUrl,
        'source_type': sourceType.toString().split('.').last,
        'status': status.toString().split('.').last,
        'digest': digest,
        'metadata': metadata,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
