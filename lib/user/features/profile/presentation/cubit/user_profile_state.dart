
import '../../../../model/user_profile_response.dart';

abstract class UserProfileState {}

/// INITIAL
class UserProfileInitial
    extends UserProfileState {}

/// LOADING
class UserProfileFetchingLoading
    extends UserProfileState {}

/// SUCCESS
class UserProfileDataSuccess
    extends UserProfileState {

  final UserProfileResponse response;

  UserProfileDataSuccess(
      this.response,
      );
}

/// ERROR
class UserProfileError
    extends UserProfileState {

  final String message;

  UserProfileError(
      this.message,
      );
}