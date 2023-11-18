part of 'sign_in_bloc.dart';

@immutable
class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInLoadedState extends SignInState {}

class SignInErrorState extends SignInState {
  final String error;

  SignInErrorState({required this.error});
}
