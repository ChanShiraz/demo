import 'package:bloc/bloc.dart';
import 'package:demo/model/user_details.dart';
import 'package:demo/repository/auth.dart';
import 'package:demo/repository/details.dart';
import 'package:meta/meta.dart';

part 'fetch_event.dart';
part 'fetch_state.dart';

class FetchBloc extends Bloc<FetchEvent, FetchState> {
  FetchBloc() : super(FetchInitial()) {
    AuthRepository authRepository = AuthRepository();
    on<FetchEvent>((event, emit) async {
      if (event is FetchUserEvent) {
        emit(FetchingUserState());
        if (await authRepository.getUser() != null) {
          UserModel? userModel = await authRepository.getUser();
          emit(FetchedUserState(userModel: userModel!));
        }
      }
    });
  }
}
