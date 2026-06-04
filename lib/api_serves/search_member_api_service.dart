
import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../owner/models/search_member_response.dart';

class SearchMemberApiService {

  static Future<SearchMemberResponse>
  searchMembers(
      String keyword,
      ) async {
    try {

      final Response response =
      await DioClient.dio.get(
        "/members/search",
        queryParameters: {
          "keyword": keyword,
        },
      );

      print(response.data);

      /// SAFELY HANDLE RESPONSE
      if (response.data is! Map<String, dynamic>) {

        throw Exception(
          "Invalid response format",
        );
      }

      final Map<String, dynamic> data =
          response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return
          SearchMemberResponse.fromJson(data);

      } else {

        throw Exception(
          data["message"]?.toString() ??
              "Failed to fetch members",
        );
      }

    } on DioException catch (e) {

      print("DIO ERROR : ${e.response?.data}");

      String? errorMessage =
          "Something went wrong";

      if (e.response?.data
      is Map<String, dynamic>) {

        errorMessage =
            e.response?.data["message"]
                ?.toString() ??
                errorMessage;

      } else if (e.response?.data
      is String) {

        errorMessage =
            e.response?.data.toString();
      }

      throw Exception(errorMessage);

    } catch (e) {

      print("ERROR : $e");

      throw Exception(e.toString());
    }
  }

}