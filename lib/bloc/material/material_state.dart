part of 'material_bloc.dart';

class MaterialState {}

final class MaterialInitial extends MaterialState {}

final class MaterialLoading extends MaterialState {}

final class MaterialLoaded extends MaterialState {
  final List<MaterialModel> materialData;
  MaterialLoaded({required this.materialData});
}

final class MaterialAddSuccess extends MaterialState {}

final class MaterialUpdateSuccess extends MaterialState {}

final class MaterialDeleteSuccess extends MaterialState {}

final class MaterialActionError extends MaterialState {
  final String message;
  MaterialActionError({required this.message});
}

final class MaterialStreamError extends MaterialState {
  final String message;
  MaterialStreamError({required this.message});
}
