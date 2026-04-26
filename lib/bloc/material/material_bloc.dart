import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/material_model.dart';
import 'package:flutter_golaundku/repository/material_repository.dart';

part 'material_event.dart';
part 'material_state.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final MaterialRepository materialRepository;
  MaterialBloc(this.materialRepository) : super(MaterialInitial()) {
    List<MaterialModel> allMaterial = [];
    on<GetMaterial>((event, emit) async {
      emit(MaterialLoading());
      try {
        final materialData = await materialRepository.getMaterial();
        allMaterial = materialData;
        emit(MaterialLoaded(materialData: allMaterial));
      } catch (e) {
        emit(MaterialError());
      }
    });

    on<AddMaterial>((event, emit) async {
      emit(MaterialLoading());
      try {
        await materialRepository.addMaterial(event.data);
        emit(MaterialAddSuccess());
        add(GetMaterial());
      } catch (e) {
        emit(MaterialError());
      }
    });

    on<UpdateMaterial>((event, emit) async {
      emit(MaterialLoading());
      try {
        await materialRepository.updateMaterial(event.data);
        emit(MaterialUpdateSuccess());
        add(GetMaterial());
      } catch (e) {
        emit(MaterialError());
      }
    });

    on<DeleteMaterial>((event, emit) async {
      emit(MaterialLoading());
      try {
        await materialRepository.deleteMaterial(event.materialId);
        emit(MaterialDeleteSuccess());
        add(GetMaterial());
      } catch (e) {
        emit(MaterialError());
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
