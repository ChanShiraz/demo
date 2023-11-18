part of 'details_bloc.dart';

@immutable
class DetailsBlocEvent {}

class UploadUserDetailsEvent extends DetailsBlocEvent {
  final UserModel userModel;
  File imageFile;

  UploadUserDetailsEvent({required this.userModel, required this.imageFile});
}
