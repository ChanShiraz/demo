part of 'email_auth_bloc.dart';

@immutable
class EmailAuthState {}

class EmailAuthInitial extends EmailAuthState {}

class EmailAuthCreateState extends EmailAuthState {}

class EmailAuthErrorState extends EmailAuthState {
  final String error;

  EmailAuthErrorState({required this.error});
}

class EmailAuthUserCreatedState extends EmailAuthState {}

class EmailVerificationSentState extends EmailAuthState {}

class EmailAlreadyRegisteredState extends EmailAuthState {}
