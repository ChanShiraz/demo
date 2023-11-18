import 'package:bloc/bloc.dart';
import 'package:demo/repository/auth.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvents, SignInState> {
  AuthRepository authRepository = AuthRepository();
  SignInBloc() : super(SignInInitial()) {
    on<SignInEvents>((event, emit) async {
      if (event is SignInEvent) {
        emit(SignInLoadingState());
        String result =
            await authRepository.signInUser(event.email, event.password);
        if (result.contains('success')) {
          emit(SignInLoadedState());
        } else if (result.contains('error')) {
          emit(SignInErrorState(error: result));
        }
      }
      if (event is SignInInitialEvent) {
        emit(SignInInitial());
      }
    });
  }
}
