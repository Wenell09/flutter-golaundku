import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/service_model.dart';
import 'package:flutter_golaundku/repository/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;
  List<ServiceModel> allServices = [];
  StreamSubscription<List<ServiceModel>>? _subscription;
  ServiceBloc(this.serviceRepository) : super(ServiceInitial()) {
    on<StartServiceStream>((event, emit) async {
      emit(ServiceLoading());
      await _subscription?.cancel();
      _subscription = serviceRepository.streamServices().listen(
        (data) {
          add(GetService(data: data));
        },
        onError: (error) {
          add(ErrorServiceStream(message: error.toString()));
        },
      );
    });
    on<GetService>((event, emit) async {
      allServices = event.data;
      emit(ServiceLoaded(serviceData: allServices));
    });
    on<AddService>((event, emit) async {
      try {
        await serviceRepository.addService(event.data);
        emit(ServiceAddSuccess());
      } catch (e) {
        emit(ServiceActionError(message: "gagal menambahkan layanan!"));
      }
    });

    on<UpdateService>((event, emit) async {
      try {
        await serviceRepository.updateService(event.data);
        emit(ServiceUpdateSuccess());
      } catch (e) {
        emit(ServiceActionError(message: "gagal mengupdate layanan!"));
      }
    });

    on<DeleteService>((event, emit) async {
      try {
        await serviceRepository.deleteService(event.serviceId);
        emit(ServiceDeleteSuccess());
      } catch (e) {
        emit(ServiceActionError(message: "gagal menghapus layanan!"));
      }
    });

    on<SearchService>((event, emit) {
      final keyword = event.keyword.toLowerCase().trim();
      if (keyword.isEmpty) {
        emit(ServiceLoaded(serviceData: allServices));
        return;
      }
      final filtered = allServices.where((service) {
        return service.name.toLowerCase().contains(keyword);
      }).toList();
      emit(ServiceLoaded(serviceData: filtered));
    });
  }
}
