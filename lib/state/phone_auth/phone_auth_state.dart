part of 'phone_auth_bloc.dart';

@immutable
class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoadingState extends PhoneAuthState {}

class PhoneAuthErrorState extends PhoneAuthState {
  final String error;

  PhoneAuthErrorState({required this.error});
}

class PhoneAuthVerifiedState extends PhoneAuthState {}

class PhoneAuthOldUserState extends PhoneAuthState {}

class PhoneAuthCodeSentSuccessState extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeSentSuccessState({
    required this.verificationId,
  });
}
