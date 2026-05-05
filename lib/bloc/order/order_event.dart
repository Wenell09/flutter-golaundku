part of 'order_bloc.dart';

class OrderEvent {}

class StartOrderStream extends OrderEvent {}

class ErrorOrderStream extends OrderEvent {
  final String message;
  ErrorOrderStream({required this.message});
}

class GetOrder extends OrderEvent {
  final List<OrderModel> data;
  GetOrder({required this.data});
}

class AddOrder extends OrderEvent {
  final OrderHeader orderHeader;
  final List<OrderItem> items;

  AddOrder({required this.orderHeader, required this.items});
}

class UpdateStatusOrder extends OrderEvent {
  final String orderId, status;
  UpdateStatusOrder({required this.orderId, required this.status});
}

class SearchOrder extends OrderEvent {
  final String keyword;
  SearchOrder({required this.keyword});
}
