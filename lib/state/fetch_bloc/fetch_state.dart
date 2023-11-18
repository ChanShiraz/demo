part of 'fetch_bloc.dart';

@immutable
class FetchState {}

class FetchInitial extends FetchState {}

class FetchingUserState extends FetchState {}

class FetchedUserState extends FetchState {
  final UserModel userModel;

  FetchedUserState({required this.userModel});
}
