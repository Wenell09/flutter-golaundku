part of 'service_bloc.dart';

class ServiceEvent {}

class StartServiceStream extends ServiceEvent {}

class ErrorServiceStream extends ServiceEvent {
  final String message;
  ErrorServiceStream({required this.message});
}

class GetService extends ServiceEvent {
  final List<ServiceModel> data;
  GetService({required this.data});
}

class AddService extends ServiceEvent {
  final Map<String, dynamic> data;
  AddService({required this.data});
}

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
