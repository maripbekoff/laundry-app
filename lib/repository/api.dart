import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:laundry/helpers/secure_storage.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/models/user.dart';
import 'package:path_provider/path_provider.dart';

class LaundryRepo {
  final Dio _dio = Dio();
  final String URL = 'https://api.doover.tech/';
  final SecureStorage _storage = SecureStorage();
  PersistCookieJar persistCookieJar;

  Future<String> get _localPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCookieDirectory async {
    final String path = await _localPath;
    final Directory dir = new Directory('$path/cookies');
    await dir.create();
    return dir;
  }

  // Save csrftoken to persistent storage
  Future<String> getCsrftoken() async {
    try {
      String csrftokenValue;
      final Directory dir = await _localCookieDirectory;
      final String cookiePath = dir.path;
      persistCookieJar = new PersistCookieJar(dir: '$cookiePath');
      persistCookieJar.deleteAll();
      _dio.interceptors.add(CookieManager(persistCookieJar));
      _dio.options = new BaseOptions(
          baseUrl: URL,
          contentType: ContentType.json.value,
          headers: {
            HttpHeaders.userAgentHeader: 'dio',
            'Connection': 'keep-alive',
          });
      _dio.interceptors
          .add(InterceptorsWrapper(onResponse: (Response response) {
        List<Cookie> cookies = persistCookieJar.loadForRequest(Uri.parse(URL));
        csrftokenValue = cookies
            .firstWhere((element) => element.name == 'csrftoken',
                orElse: () => null)
            ?.value;
        if (csrftokenValue != null)
          _dio.options.headers['X-CSRF-TOKEN'] = csrftokenValue;
        return response;
      }));
      return csrftokenValue;
    } catch (e, stacktrace) {
      print('Exception occured: $e stackTrace: $stacktrace');
      return null;
    }
  }

  Future<void> logIn(String username, String password) async {
    try {
      final String csrftoken = await getCsrftoken();

      FormData _formData = FormData.fromMap({
        'username': '$username',
        'password': '$password',
      });

      Options options = new Options(
        contentType:
            ContentType.parse("application/x-www-form-urlencoded").value,
        headers: {'Cookie': csrftoken},
      );

      Response response = await _dio.post(
        'auth/login/',
        data: _formData,
        options: options,
      );

      await _storage.writeAuthToken(value: response.data['key']);
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            e.response.statusCode.toString() + " " + e.response.statusMessage);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<User> get getName async {
    try {
      final String csrftoken = await getCsrftoken();
      final String authtoken = await _storage.readAuthToken;

      Options options = new Options(
        headers: {
          'Cookie': csrftoken,
          'Authorization': 'Token $authtoken',
        },
      );

      Response response = await _dio.get('me/', options: options);

      if (response.statusCode == 200)
        return User.fromJson(response.data);
      else
        throw Exception('Exception occured: ${response.data}');
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            e.response.statusCode.toString() + " " + e.response.statusMessage);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (e, stacktrace) {
      print('Exception occured: $e stackTrace: $stacktrace');
      return null;
    }
  }

  Future<List<Catalog>> get getCatalog async {
    try {
      final String csrftoken = await getCsrftoken();
      final String authtoken = await _storage.readAuthToken;

      Options options = new Options(
        headers: {
          'Cookie': csrftoken,
          'Authorization': 'Token $authtoken',
        },
      );

      Response response = await _dio.get('catalog/', options: options);

      var data = json.decode(json.encode(response.data).replaceAll('http', 'https'));

      if (response.statusCode == 200)
        return List<Catalog>.from(data.map((i) => Catalog.fromJson(i)));
      else
        throw Exception('Error occurred: ${response.data['detail']}');
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            e.response.statusCode.toString() + " " + e.response.statusMessage);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (e, stacktrace) {
      print('Exception occured: $e stackTrace: $stacktrace');
      return null;
    }
  }

  Future<List<Object>> get getCategories async {
    try {
      final String csrftoken = await getCsrftoken();
      final String authtoken = await _storage.readAuthToken;

      Options options = new Options(
        headers: {
          'Cookie': csrftoken,
          'Authorization': 'Token $authtoken',
        },
      );

      Response response =
          await _dio.get('catalog/categories/', options: options);

      if (response.statusCode == 200)
        return response.data;
      else
        throw Exception('Error occurred: ${response.data['detail']}');
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            e.response.statusCode.toString() + " " + e.response.statusMessage);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (e, stacktrace) {
      print('Exception occured: $e stackTrace: $stacktrace');
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      final String csrftoken = await getCsrftoken();
      final String authtoken = await _storage.readAuthToken;

      Options options = new Options(
        headers: {
          'Cookie': csrftoken,
          'Authorization': 'Token $authtoken',
        },
      );

      Response response = await _dio.post('auth/logout/', options: options);

      if (response.statusCode == 200) {
        await _storage.removeAuthToken();
        print('Вы успешно вышли');
      } else
        throw Exception('Error occurred: ${response.data['detail']}');
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            e.response.statusCode.toString() + " " + e.response.statusMessage);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (e, stacktrace) {
      print('Exception occured: $e stackTrace: $stacktrace');
      return null;
    }
  }
}
