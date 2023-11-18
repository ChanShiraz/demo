part of 'details_bloc.dart';

@immutable
class DetailsBlocState {}

class DetailsBlocInitial extends DetailsBlocState {}

class DetailsBlocUploadingState extends DetailsBlocState {}

class DetailsBlocErrorState extends DetailsBlocState {
  final String error;

  DetailsBlocErrorState({required this.error});
}

class DetailsBlocUploadedState extends DetailsBlocState {}
