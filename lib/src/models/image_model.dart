enum ImageSourceType { FILE, URL }

enum ImageStatus { PENDING, PROCESSING, COMPLETED, FAILED }

class ImageSource {
  final ImageSourceType type;

  ImageSource({required this.type});

  factory ImageSource.fromJson(Map<String, dynamic> json) {
    return ImageSource(
      type: ImageSourceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ImageSourceType.FILE,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.toString().split('.').last,
      };
}

class ImageStorage {
  final DateTime uploadedDate;
  final String url;

  ImageStorage({
    required this.uploadedDate,
    required this.url,
  });

  factory ImageStorage.fromJson(Map<String, dynamic> json) {
    return ImageStorage(
      uploadedDate: DateTime.parse(json['uploaded_date']),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uploaded_date': uploadedDate.toIso8601String(),
        'url': url,
      };
}

class ImageModel {
  final String uuid;
  final ImageStatus status;
  final ImageSource? source;
  final DateTime createdDate;
  final String digest;
  final ImageStorage storage;

  ImageModel({
    required this.uuid,
    required this.status,
    this.source,
    required this.createdDate,
    required this.digest,
    required this.storage,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      uuid: json['uuid'],
      status: ImageStatus.values[json['status']],
      source:
          json['source'] != null ? ImageSource.fromJson(json['source']) : null,
      createdDate: DateTime.parse(json['created_date']),
      digest: json['digest'],
      storage: ImageStorage.fromJson(json['storage']),
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'status': status.index,
        'source': source?.toJson(),
        'created_date': createdDate.toIso8601String(),
        'digest': digest,
        'storage': storage.toJson(),
      };

  String get originalUrl => storage.url;
}
