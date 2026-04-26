import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/service_model.dart';
import 'package:flutter_golaundku/repository/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;
  ServiceBloc(this.serviceRepository) : super(ServiceInitial()) {
    List<ServiceModel> allServices = [];
    on<AddService>((event, emit) async {
      emit(ServiceLoading());
      try {
        await serviceRepository.addService(event.data);
        emit(ServiceAddSuccess());
        add(GetService());
      } catch (e) {
        emit(ServiceError());
      }
    });

    on<GetService>((event, emit) async {
      emit(ServiceLoading());
      try {
        final serviceData = await serviceRepository.getService();
        allServices = serviceData;
        emit(ServiceLoaded(serviceData: allServices));
      } catch (e) {
        emit(ServiceError());
      }
    });

    on<UpdateService>((event, emit) async {
      emit(ServiceLoading());
      try {
        await serviceRepository.updateService(event.data);
        emit(ServiceUpdateSuccess());
        add(GetService());
      } catch (e) {
        emit(ServiceError());
      }
    });

    on<DeleteService>((event, emit) async {
      emit(ServiceLoading());
      try {
        await serviceRepository.deleteService(event.serviceId);
        emit(ServiceDeleteSuccess());
        add(GetService());
      } catch (e) {
        emit(ServiceError());
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
