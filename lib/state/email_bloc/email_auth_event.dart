part of 'email_auth_bloc.dart';

@immutable
class EmailAuthEvent {}

class EmailAuthCreateUserEvent extends EmailAuthEvent {
  final String email;
  final String password;

  EmailAuthCreateUserEvent({required this.email, required this.password});
}

class EmailVerificationCheckEvent extends EmailAuthEvent {}
