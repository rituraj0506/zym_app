import 'package:dio/dio.dart';
import 'secure_storge.dart';
import 'api_end_point.dart';

// class DioClient {
//
//   static final Dio dio = Dio(
//
//     BaseOptions(
//       baseUrl: Apiendpoint.baseUrl,
//
//       connectTimeout: const Duration(seconds: 10),
//
//       receiveTimeout: const Duration(seconds: 10),
//
//       headers: {
//         "Content-Type": "application/json",
//       },
//     ),
//   )
//
//     ..interceptors.add(
//
//       InterceptorsWrapper(
//
//         onRequest: (options, handler) async {
//
//           final token =
//           await SecureStorageService.getToken();
//
//           if (token != null) {
//
//             options.headers["Authorization"] =
//             "Bearer $token";
//           }
//
//           return handler.next(options);
//         },
//
//         onError: (error, handler) {
//
//           print("DIO ERROR : ${error.response?.data}");
//
//           return handler.next(error);
//         },
//       ),
//     );
// }

class DioClient {

  static final Dio dio = Dio(

    BaseOptions(

      baseUrl: Apiendpoint.baseUrl,

      connectTimeout:
      const Duration(seconds: 10),

      receiveTimeout:
      const Duration(seconds: 10),

      /// IMPORTANT
      validateStatus: (status) {

        return status != null &&
            status < 500;
      },
    ),
  )

    ..interceptors.add(

      InterceptorsWrapper(

        onRequest: (
            options,
            handler,
            ) async {

          final token =
          await SecureStorageService
              .getToken();

          if (token != null) {

            options.headers[
            "Authorization"
            ] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (
            error,
            handler,
            ) {

          print(
            "STATUS CODE : "
                "${error.response?.statusCode}",
          );

          print(
            "DIO ERROR : "
                "${error.message}",
          );

          print(
            "RESPONSE : "
                "${error.response?.data}",
          );

          String errorMessage =
              "Something went wrong";

          /// INTERNET ERROR
          if (error.type ==
              DioExceptionType
                  .connectionError) {

            errorMessage =
            "No internet connection";
          }

          /// TIMEOUT
          else if (error.type ==
              DioExceptionType
                  .connectionTimeout ||

              error.type ==
                  DioExceptionType
                      .receiveTimeout ||

              error.type ==
                  DioExceptionType
                      .sendTimeout) {

            errorMessage =
            "Server timeout";
          }

          /// SERVER ERROR
          else if (error.response
              ?.statusCode ==
              500) {

            errorMessage =
            "Server error";
          }

          /// UNAUTHORIZED
          else if (error.response
              ?.statusCode ==
              401) {

            errorMessage =
            "Session expired";
          }

          /// CUSTOM BACKEND MESSAGE
          else if (error.response
              ?.data !=
              null &&
              error.response!
                  .data["message"] !=
                  null) {

            errorMessage =
            error.response!
                .data["message"];
          }

          return handler.reject(

            DioException(

              requestOptions:
              error.requestOptions,

              response:
              error.response,

              type:
              error.type,

              error:
              errorMessage,
            ),
          );
        },
      ),
    );
}