import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:messaging_app_flutter/DTOs/message_group_to_return_dto.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;

class Messages {
  static Future<List<MessageGroupToReturnDto>> getChats(userId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/messages');

    var response;

    try {
      response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('Messages.getChats http request: $e');
      return null;
    }

    if (response.statusCode != 200) return null;

    List<MessageGroupToReturnDto> list = [];

    try {
      var decoded = jsonDecode(response.body);

      for (var item in decoded) {
        list.add(MessageGroupToReturnDto.fromJson(item));
      }
    } catch (e) {
      print('Messages.getChats converting json: $e');
      return null;
    }

    return list;
  }

  static Future<String> getMessagesForGroup(userId, groupId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/messages/thread/$groupId');

    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) return null;

    return response.body;
  }

  static Future<bool> sendTextMessage(userId, groupId, message, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/messages/');

    var response = await http.post(uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'groupId': int.parse(groupId),
          'content': message,
          'isPhoto': false
        }));

    if (response.statusCode != 201) return false;

    return true;
  }

  static Future<bool> sendPhotoMessage(userId, groupId, filePath, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/messages/file');

    Dio dio = Dio();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'Authorization': 'Bearer $token',
      };
      options.headers.addAll(customHeaders);
      return options;
    }));

    FormData formData = new FormData.fromMap({
      'groupId': groupId,
      'file': await MultipartFile.fromFile(filePath, filename: "upload")
    });

    var httpResponse;

    try {
      httpResponse = await dio.post(
        uri.toString(),
        data: formData,
      );
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.request);
        print(e.message);
      }
    }

    if (httpResponse.statusCode != 200) return false;

    return true;
  }
}
