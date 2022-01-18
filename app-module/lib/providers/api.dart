import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';

class Api {
  static const String _serviceDomain = 'http://192.168.1.10:3000';
  static const String _aiDomain = 'http://192.168.1.10:8000';

  static Future<dynamic> login(String email, password) async {
    final url = Uri.parse('$_serviceDomain/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final decodedResponse = json.decode(response.body);
      if (decodedResponse['code'] >= 400) {
        throw HttpException(decodedResponse['message']);
      }
      return decodedResponse;
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> signUp(String email, displayName, password) async {
    final url = Uri.parse('$_serviceDomain/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'displayName': displayName,
          'password': password,
        }),
      );

      final decodedResponse = json.decode(response.body);
      if (decodedResponse['code'] >= 400) {
        throw HttpException(decodedResponse['message']);
      }

      return decodedResponse;
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> getAllProducts(String token) async {
    final url = Uri.parse('$_serviceDomain/get-all-products');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if (decodedResponse['code'] >= 400) {
        throw HttpException('Fetch data failed!');
      }

      return decodedResponse;
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> searchProducts(String token, searchContent) async {
    final url = Uri.parse('$_serviceDomain/search-products');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'text': searchContent}),
      );

      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if (decodedResponse['code'] >= 400) {
        throw HttpException('Something went wrong!');
      }

      return decodedResponse;
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> searchByImage(XFile imageFile) async {
    final url = Uri.parse('$_aiDomain/query');

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(http.MultipartFile(
          'file',
          http.ByteStream(DelegatingStream.typed(imageFile.openRead())),
          await imageFile.length(),
          filename: basename(imageFile.path),
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        return decodedResponse;
      }
    } catch (error) {
      rethrow;
    }
  }
}
