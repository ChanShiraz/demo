import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:demo/repository/auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:meta/meta.dart';

part 'email_auth_event.dart';
part 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  EmailAuthBloc() : super(EmailAuthInitial()) {
    on<EmailAuthEvent>((event, emit) async {
      AuthRepository authRepository = AuthRepository();
      if (event is EmailAuthCreateUserEvent) {
        emit(EmailAuthCreateState());
        String? result =
            await authRepository.createUser(event.email, event.password);
        if (result != null && result.contains('success')) {
          emit(EmailVerificationSentState());
        } else if (result != null && result.contains('error')) {
          emit(EmailAuthErrorState(error: result));
        }
      }
      if (event is EmailVerificationCheckEvent) {
        print('Handling EmailVerificationCheckEvent');
        try {
          bool isVerified = await authRepository.checkEmailVerification();
          print('Email verification result: $isVerified');

          if (isVerified) {
            emit(EmailAuthUserCreatedState());
          } else {
            emit(EmailVerificationSentState());
          }
        } catch (e) {
          print('Error during email verification: $e');
          // Handle the error appropriately, e.g., emit an error state.
        }
      }
    });
  }
}
