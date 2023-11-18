part of 'sign_in_bloc.dart';

@immutable
class SignInEvents {}

class SignInInitialEvent extends SignInEvents {}

class SignInEvent extends SignInEvents {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}
