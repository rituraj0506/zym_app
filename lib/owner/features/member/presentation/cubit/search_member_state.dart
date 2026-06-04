import 'package:zymmanagement/owner/models/search_member_response.dart';

abstract class SearchMemberState {}

class SearchMemberInitial extends SearchMemberState {}

class SearchMemberLoading extends SearchMemberState {}

class SearchMemberLoaded extends SearchMemberState {

  final SearchMemberResponse response;

  SearchMemberLoaded(this.response);
}

class SearchMemberError extends SearchMemberState {

  final String message;

  SearchMemberError(this.message);
}