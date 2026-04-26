part of 'material_bloc.dart';

class MaterialEvent {}

class GetMaterial extends MaterialEvent {}

class AddMaterial extends MaterialEvent {
  final Map<String, dynamic> data;
  AddMaterial({required this.data});
}

class UpdateMaterial extends MaterialEvent {
  final Map<String, dynamic> data;
  UpdateMaterial({required this.data});
}

class DeleteMaterial extends MaterialEvent {
  final String materialId;
  DeleteMaterial({required this.materialId});
}

class SearchMaterial extends MaterialEvent {
  final String keyword;
  SearchMaterial({required this.keyword});
}
