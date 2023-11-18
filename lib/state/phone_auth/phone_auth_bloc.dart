import 'package:bloc/bloc.dart';
import 'package:demo/repository/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  AuthRepository phoneAuthRepository = AuthRepository();
  final auth = FirebaseAuth.instance;

  PhoneAuthBloc() : super(PhoneAuthInitial()) {
    on<SendOtpToPhoneEvent>(_onSendOtp);

    on<VerifySentOtpEvent>(_onVerifyOtp);

    on<OnPhoneOtpSent>((event, emit) => emit(
        PhoneAuthCodeSentSuccessState(verificationId: event.verificationId)));

    on<OnPhoneAuthErrorEvent>(
        (event, emit) => emit(PhoneAuthErrorState(error: event.error)));

    on<OnPhoneAuthVerificationCompleteEvent>(_loginWithCredential);
  }

  Future<void> _onSendOtp(
      SendOtpToPhoneEvent event, Emitter<PhoneAuthState> emit) async {
    emit(PhoneAuthLoadingState());
    try {
      await phoneAuthRepository.verifyPhone(
        phoneNumber: event.phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
        },
        codeSent: (String verificationId, int? resendToken) {
          add(OnPhoneOtpSent(
              verificationId: verificationId, token: resendToken));
        },
        verificationFailed: (FirebaseAuthException e) {
          add(OnPhoneAuthErrorEvent(error: e.code));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(PhoneAuthErrorState(error: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifySentOtpEvent event, Emitter<PhoneAuthState> emit) async {
    try {
      emit(PhoneAuthLoadingState());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
    } catch (e) {
      emit(PhoneAuthErrorState(error: e.toString()));
    }
  }

  Future<void> _loginWithCredential(OnPhoneAuthVerificationCompleteEvent event,
      Emitter<PhoneAuthState> emit) async {
    try {
      await auth.signInWithCredential(event.credential).then((user) async {
        if (user.user != null) {
          if (await phoneAuthRepository.checkUser(user.user!)) {
            emit(PhoneAuthOldUserState());
          } else {
            emit(PhoneAuthVerifiedState());
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthErrorState(error: e.code));
    } catch (e) {
      emit(PhoneAuthErrorState(error: e.toString()));
    }
    return;
  }
}
