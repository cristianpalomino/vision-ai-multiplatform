import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';
import 'api_service.dart';

class ImageService extends ApiService {
  static const String _basePath = 'user/images';

  Future<ImageModel> uploadFile(File image) async {
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/$_basePath/upload');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await multipartHeaders)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ImageModel.fromJson(jsonDecode(response.body));
      }
      throw ApiException('Failed to upload image', response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to upload image: $e');
    }
  }

  Future<ImageModel> uploadUrl(String imageUrl) async {
    return makeRequest<ImageModel>(
      path: '$_basePath/upload',
      method: 'POST',
      body: {'url': imageUrl},
      parser: (response) {
        if (response.statusCode == 201) {
          return ImageModel.fromJson(jsonDecode(response.body));
        }
        throw ApiException('Failed to upload image URL', response.statusCode);
      },
      cancelKey: 'upload_url',
    );
  }

  Future<List<ImageModel>> getImages() async {
    return makeRequest<List<ImageModel>>(
      path: _basePath,
      method: 'GET',
      parser: (response) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data.containsKey('images') && data['images'] is List) {
            final List<dynamic> jsonList = data['images'];
            return jsonList.map((json) => ImageModel.fromJson(json)).toList();
          }
          throw ApiException('Invalid response format', response.statusCode);
        }
        throw ApiException('Failed to load images', response.statusCode);
      },
      cancelKey: 'get_images',
    );
  }

  Future<ImageModel> getImage(String uuid) async {
    return makeRequest<ImageModel>(
      path: '$_basePath/$uuid',
      method: 'GET',
      parser: (response) {
        if (response.statusCode == 200) {
          return ImageModel.fromJson(jsonDecode(response.body));
        }
        throw ApiException('Failed to load image', response.statusCode);
      },
      cancelKey: 'get_image_$uuid',
    );
  }

  Future<void> deleteImage(String uuid) async {
    return makeRequest<void>(
      path: '$_basePath/$uuid',
      method: 'DELETE',
      parser: (response) {
        if (response.statusCode != 204) {
          throw ApiException('Failed to delete image', response.statusCode);
        }
      },
      cancelKey: 'delete_image_$uuid',
    );
  }

  @override
  void dispose() {
    cancelRequest('get_images');
    super.dispose();
  }
}
