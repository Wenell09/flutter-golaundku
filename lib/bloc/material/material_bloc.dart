import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/material_model.dart';
import 'package:flutter_golaundku/repository/material_repository.dart';

part 'material_event.dart';
part 'material_state.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final MaterialRepository materialRepository;
  StreamSubscription<List<MaterialModel>>? _subscription;
  List<MaterialModel> allMaterial = [];
  MaterialBloc(this.materialRepository) : super(MaterialInitial()) {
    on<StartMaterialStream>((event, emit) async {
      emit(MaterialLoading());
      await _subscription?.cancel();
      _subscription = materialRepository.streamMaterial().listen(
        (data) {
          add(GetMaterial(data: data));
        },
        onError: (error) {
          add(ErrorMaterialStream(message: error.toString()));
        },
      );
    });
    on<GetMaterial>((event, emit) async {
      allMaterial = event.data;
      emit(MaterialLoaded(materialData: allMaterial));
    });

    on<AddMaterial>((event, emit) async {
      try {
        await materialRepository.addMaterial(event.data);
        emit(MaterialAddSuccess());
      } catch (e) {
        emit(MaterialActionError(message: "gagal menambahkan stok barang!"));
      }
    });

    on<UpdateMaterial>((event, emit) async {
      try {
        await materialRepository.updateMaterial(event.data);
        emit(MaterialUpdateSuccess());
      } catch (e) {
        emit(MaterialActionError(message: "gagal mengupdate stok barang!"));
      }
    });

    on<DeleteMaterial>((event, emit) async {
      try {
        await materialRepository.deleteMaterial(event.materialId);
        emit(MaterialDeleteSuccess());
      } catch (e) {
        emit(MaterialActionError(message: "gagal menghapus stok barang!"));
      }
    });

    on<SearchMaterial>((event, emit) {
      final keyword = event.keyword.toLowerCase().trim();
      if (keyword.isEmpty) {
        emit(MaterialLoaded(materialData: allMaterial));
        return;
      }
      final filtered = allMaterial.where((service) {
        return service.name.toLowerCase().contains(keyword);
      }).toList();
      emit(MaterialLoaded(materialData: filtered));
    });
  }
}
