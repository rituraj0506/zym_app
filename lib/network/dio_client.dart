import 'package:dio/dio.dart';
import 'secure_storge.dart';
import 'api_end_point.dart';

class DioClient {

  static final Dio dio = Dio(

    BaseOptions(
      baseUrl: Apiendpoint.baseUrl,

      connectTimeout: const Duration(seconds: 10),

      receiveTimeout: const Duration(seconds: 10),

      headers: {
        "Content-Type": "application/json",
      },
    ),
  )

    ..interceptors.add(

      InterceptorsWrapper(

        onRequest: (options, handler) async {

          final token =
          await SecureStorageService.getToken();

          if (token != null) {

            options.headers["Authorization"] =
            "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (error, handler) {

          print("DIO ERROR : ${error.response?.data}");

          return handler.next(error);
        },
      ),
    );
}