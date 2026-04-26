part of 'service_bloc.dart';

class ServiceState {}

final class ServiceInitial extends ServiceState {}

final class ServiceLoading extends ServiceState {}

final class ServiceLoaded extends ServiceState {
  final List<ServiceModel> serviceData;
  ServiceLoaded({required this.serviceData});
}

final class ServiceAddSuccess extends ServiceState {}

final class ServiceUpdateSuccess extends ServiceState {}

final class ServiceDeleteSuccess extends ServiceState {}

final class ServiceError extends ServiceState {}
