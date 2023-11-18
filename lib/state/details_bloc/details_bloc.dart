import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:demo/model/user_details.dart';
import 'package:demo/repository/details.dart';
import 'package:meta/meta.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsBlocEvent, DetailsBlocState> {
  DetailsBloc() : super(DetailsBlocInitial()) {
    DetailsRepository detailsRepository = DetailsRepository();
    on<DetailsBlocEvent>((event, emit) async {
      if (event is UploadUserDetailsEvent) {
        emit(DetailsBlocUploadingState());
        String result = await detailsRepository.uploadDetails(
            event.userModel, event.imageFile);
        if (result.contains('success')) {
          emit(DetailsBlocUploadedState());
        } else {
          emit(DetailsBlocErrorState(error: result));
        }
      }
    });
  }
}
