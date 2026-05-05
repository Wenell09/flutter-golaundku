part of 'detail_order_bloc.dart';

class DetailOrderState {}

final class DetailOrderInitial extends DetailOrderState {}

final class DetailOrderLoading extends DetailOrderState {}

final class DetailOrderLoaded extends DetailOrderState {
  final List<OrderItemsModel> detailOrderData;
  DetailOrderLoaded({required this.detailOrderData});
}

final class DetailOrderUpdateDeliverySuccess extends DetailOrderState {}

final class DetailOrderError extends DetailOrderState {}
