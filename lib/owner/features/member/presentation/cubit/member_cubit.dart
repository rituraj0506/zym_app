import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/api_serves/member_api_services.dart';
import '../../../../models/member_response.dart';
import 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit() : super(const MemberInitial());

  /// STORE ALL MEMBERS
  final List<MemberData> allMembers = [];

  /// PAGINATION
  int currentPage = 1;

  bool hasNextPage = true;

  bool isLoading = false;

  /// GET ALL MEMBERS
  Future<void> getAllMembers({
    bool isRefresh = false,
  }) async {
    if (isLoading) return;

    if (!hasNextPage && !isRefresh) {
      return;
    }

    isLoading = true;

    try {
      if (state is MemberInitial || isRefresh) {
        emit(const MemberLoading());

        currentPage = 1;

        hasNextPage = true;

        allMembers.clear();
      } else if (state is MemberLoaded) {
        emit(
          (state as MemberLoaded).copyWith(
            isLoadingMore: true,
          ),
        );
      }

      final MembersResponseModel response =
      await MemberApiServices.getAllMembers(
        page: currentPage,
      );

      final List<MemberData> newMembers =
          response.data ?? <MemberData>[];

      allMembers.addAll(newMembers);

      hasNextPage =
          response.pagination?.hasNextPage ?? false;

      if (hasNextPage) {
        currentPage++;
      }

      emit(
        MemberLoaded(
          members: List<MemberData>.from(allMembers),
          hasNextPage: hasNextPage,
          currentPage: currentPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      String errorMessage =
      e.toString();

      /// REMOVE EXCEPTION:
      if (errorMessage.startsWith(
        "Exception:",
      )) {

        errorMessage =
            errorMessage.replaceFirst(
              "Exception:",
              "",
            ).trim();
      }

      emit(
        MemberError(
          errorMessage,
        ),
      );
    } finally {
      isLoading = false;
    }
  }

  /// REFRESH MEMBERS
  Future<void> refreshMembers() async {
    await getAllMembers(
      isRefresh: true,
    );
  }

  /// ADD MEMBER
  Future<void> addMember({
    required String name,
    required String age,
    required String mobNo,
    required String aadhaarNo,
    required String email,
    required String password,
    required String planId,
    required File? profilePhoto,
  }) async {
    try {
      emit(const AddMemberLoading());

      FormData formData = FormData.fromMap({
        "name": name,
        "age": age,
        "mobNo": mobNo,
        "aadhaarNo": aadhaarNo,
        "email": email,
        "password": password,
        "planId": planId,

        if (profilePhoto != null)
          "profilePhoto": await MultipartFile.fromFile(
            profilePhoto.path,
            filename: profilePhoto.path.split("/").last,
          ),
      });

      final message =
      await MemberApiServices.addMember(
        formData: formData,
      );

      emit(
        AddMemberSuccess(message),
      );

      /// REFRESH MEMBER LIST
      await refreshMembers();
    } catch (e) {
      String errorMessage =
      e.toString();

      if (errorMessage.startsWith(
        "Exception:",
      )) {

        errorMessage =
            errorMessage.replaceFirst(
              "Exception:",
              "",
            ).trim();
      }

      emit(
        MemberError(
          errorMessage,
        ),
      );
    }
  }


  Future<void> updateMember({
    required String memberId,
    required String name,
    required String age,
    required String mobNo,
    required String aadhaarNo,
    required String email,
    required String planId,
    File? profilePhoto,
  }) async {

    try {

      emit(const AddMemberLoading());

      FormData formData = FormData.fromMap({

        "name": name,
        "age": age,
        "mobNo": mobNo,
        "aadhaarNo": aadhaarNo,
        "email": email,
        "planId": planId,

        if (profilePhoto != null)
          "profilePhoto": await MultipartFile.fromFile(
            profilePhoto.path,
            filename:
            profilePhoto.path.split("/").last,
          ),
      });

      final message =
      await MemberApiServices.updateMember(
        memberId: memberId,
        formData: formData,
      );

      emit(
        AddMemberSuccess(message),
      );

      await refreshMembers();

    } catch (e) {

      String errorMessage =
      e.toString();

      if (errorMessage.startsWith(
        "Exception:",
      )) {

        errorMessage =
            errorMessage.replaceFirst(
              "Exception:",
              "",
            ).trim();
      }

      emit(
        MemberError(
          errorMessage,
        ),
      );
    }
  }

  void clearMembers() {

    allMembers.clear();

    currentPage = 1;

    hasNextPage = true;

    isLoading = false;

    emit(const MemberInitial());
  }

}