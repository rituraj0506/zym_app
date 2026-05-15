import '../../../../models/gym_profile_response.dart';

abstract class GymProfileState {}

/// INITIAL
class GymProfileInitial
    extends GymProfileState {}

/// CREATE LOADING
class GymProfileCreateLoading
    extends GymProfileState {}

/// FETCH PROFILE LOADING
class GymProfileFetchingLoading
    extends GymProfileState {}

/// CREATE SUCCESS
class GymProfileSuccess
    extends GymProfileState {

  final String message;

  GymProfileSuccess(this.message);
}


/// GET PROFILE SUCCESS
class GymProfileDataSuccess
    extends GymProfileState {

  final GymProfileResponse profile;

  GymProfileDataSuccess(this.profile);
}

/// ERROR
class GymProfileError
    extends GymProfileState {

  final String message;

  GymProfileError(this.message);
}