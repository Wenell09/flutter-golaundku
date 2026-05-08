part of 'order_bloc.dart';

class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orderData;
  OrderLoaded({required this.orderData});
}

class OrderAddSuccess extends OrderState {}

class OrderUpdateStatusSuccess extends OrderState {}

class OrderUpdatePaymentConfirmSuccess extends OrderState {}

class OrderStreamError extends OrderState {
  final String message;
  OrderStreamError({required this.message});
}

class OrderActionError extends OrderState {
  final String message;
  OrderActionError({required this.message});
}
