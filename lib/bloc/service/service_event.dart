part of 'service_bloc.dart';

class ServiceEvent {}

class AddService extends ServiceEvent {
  final Map<String, dynamic> data;
  AddService({required this.data});
}

class GetService extends ServiceEvent {}

class UpdateService extends ServiceEvent {
  final Map<String, dynamic> data;
  UpdateService({required this.data});
}

class DeleteService extends ServiceEvent {
  final String serviceId;
  DeleteService({required this.serviceId});
}

class SearchService extends ServiceEvent {
  final String keyword;
  SearchService(this.keyword);
}
