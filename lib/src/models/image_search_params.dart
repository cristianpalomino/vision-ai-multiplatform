import 'package:vision_ai_multiplatform/src/models/image_model.dart';

class ImageSearchParams {
  final ImageSourceType? sourceType;
  final DateTime? dateFrom;
  final String? digest;
  final ImageStatus? status;

  ImageSearchParams({
    this.sourceType,
    this.dateFrom,
    this.digest,
    this.status,
  });

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};

    if (sourceType != null) {
      params['source_type'] = sourceType.toString().split('.').last;
    }
    if (dateFrom != null) {
      params['date_from'] = dateFrom!.toIso8601String().split('T').first;
    }
    if (digest != null) {
      params['digest'] = digest!;
    }
    if (status != null) {
      params['status'] = status.toString().split('.').last;
    }

    return params;
  }
}
