import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vision_ai_multiplatform/src/models/image_model.dart';
import 'package:vision_ai_multiplatform/src/services/api_service.dart';

class ImageService extends ApiService {
  Future<void> uploadFile(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/user/images/upload'),
    )
      ..headers.addAll(await multipartHeaders)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> uploadUrl(String imageUrl) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/user/images/upload'),
      headers: await headers,
      body: jsonEncode({'url': imageUrl}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image URL');
    }
  }

  Future<List<ImageModel>> getImages() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/user/images'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ImageModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load images HTTP ${response.statusCode}');
  }
}
